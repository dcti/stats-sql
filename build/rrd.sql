--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;

SET SESSION AUTHORIZATION 'decibel';

SET search_path = rrd, pg_catalog;

ALTER TABLE ONLY rrd.bucket DROP CONSTRAINT rrd_bucket__rrd_id;
ALTER TABLE ONLY rrd.rrd DROP CONSTRAINT rrd_rrd__rrd_parent;
ALTER TABLE ONLY rrd.bucket DROP CONSTRAINT rrd_bucket__rrd_id__end_time;
ALTER TABLE ONLY rrd.bucket DROP CONSTRAINT rrd_bucket__bucket_id;
ALTER TABLE ONLY rrd.rrd DROP CONSTRAINT rrd_rrd__rrd_name;
ALTER TABLE ONLY rrd.rrd DROP CONSTRAINT rrd_rrd__rrd_id;
DROP FUNCTION rrd.add_buckets(integer, interval, timestamp with time zone, timestamp with time zone);
DROP FUNCTION rrd.interval_time(timestamp with time zone, interval);
DROP TABLE rrd.bucket;
DROP TABLE rrd.rrd;
DROP FUNCTION rrd.update_buckets();
DROP FUNCTION rrd.max_end_time_to_delete(integer);
SET SESSION AUTHORIZATION DEFAULT;

DROP SCHEMA rrd;
--
-- TOC entry 3 (OID 582083278)
-- Name: rrd; Type: SCHEMA; Schema: -; Owner: 
--

CREATE SCHEMA rrd AUTHORIZATION decibel;


SET SESSION AUTHORIZATION 'decibel';

--
-- TOC entry 11 (OID 588605676)
-- Name: max_end_time_to_delete(integer); Type: FUNCTION; Schema: rrd; Owner: decibel
--

CREATE FUNCTION max_end_time_to_delete(integer) RETURNS timestamp with time zone
    AS '
DECLARE
    p_rrd_id ALIAS FOR $1;
    v_min_end_time TIMESTAMP WITH TIME ZONE;
BEGIN
    -- For each rrd if no data has been captured yet we''ll get a null. If we do
    -- that means don''t delete anything.

    -- Update maximum end_time that can be removed based on alert_rrd_status
    SELECT INTO v_min_end_time
            last_end_time
        FROM page_log.rrd_status
        WHERE rrd_id = p_rrd_id
    ;

    /*
    SELECT debug.f(''update_rrd_buckets v_min_end_time for rrd_id %s after alert_rrd = %s''::text
                , p_rrd_id::text
                , coalesce(v_min_end_time::text, ''NULL'')
        );
        */
    RAISE DEBUG ''v_min_end_time for rrd % after page_log.rrd_status = %'', p_rrd_id, v_min_end_time;

    -- If we get other RRDs in the system, their checks would go here:
    /*
    SELECT INTO v_min_end_time
            min(last_end_time, v_min_end_time)
        FROM blah_rrd
        WHERE rrd_id = rrd.rrd_id
    ;
    */

    -- Check on child RRDs
    -- Handle this one differently in case there are no children
    SELECT INTO v_min_end_time
            min(
                    (SELECT  coalesce( max(last_end_time), v_min_end_time )
                        FROM page_log.rrd_status s
                            JOIN rrd.rrd r ON (s.rrd_id = r.rrd_id)
                        WHERE r.parent = p_rrd_id
                    )
                    , v_min_end_time
                )
    ;
    
    /*
    SELECT debug.f(''update_rrd_buckets v_min_end_time for rrd_id %s children = %s''
                , p_rrd_id::text
                , CASE WHEN v_min_end_time::text IS NULL THEN ''NULL'' ELSE v_min_end_time END
        );
        */
    RAISE DEBUG ''v_min_end_time for rrd % children = %'', p_rrd_id, v_min_end_time;

    -- Check on keep_buckets
    SELECT INTO v_min_end_time
            min(    (SELECT max(end_time)
                                    FROM rrd.bucket
                                    WHERE rrd_id = p_rrd_id
                                ) - time_per_bucket * keep_buckets
                            , v_min_end_time
                        )
        FROM rrd.rrd
        WHERE rrd_id = p_rrd_id
    ;
    
    /*
    SELECT debug.f(''update_rrd_buckets v_min_end_time for rrd_id %s keep_buckets = %s''
                , p_rrd_id::text
                , CASE WHEN v_min_end_time::text IS NULL THEN ''NULL'' ELSE v_min_end_time END
            );
            */
    RAISE DEBUG ''v_min_end_time for rrd % keep buckets = %'', p_rrd_id, v_min_end_time;

    RETURN v_min_end_time;
END;
'
    LANGUAGE plpgsql;


--
-- TOC entry 13 (OID 588605677)
-- Name: update_buckets(); Type: FUNCTION; Schema: rrd; Owner: decibel
--

CREATE FUNCTION update_buckets() RETURNS integer
    AS '
DECLARE
    v_delete_end_time TIMESTAMP WITH TIME ZONE;
    v_first_end_time TIMESTAMP WITH TIME ZONE;
    v_last_end_time TIMESTAMP WITH TIME ZONE;
    v_rrd rrd.rrd%ROWTYPE;
    v_rows int;
    v_buckets_added int := 0;
BEGIN
    --debug.f(''update_buckets enter'');
    -- Run through each RRD
    FOR v_rrd IN SELECT * FROM rrd.rrd ORDER BY coalesce( parent, -1 ), rrd_id
    LOOP
        --debug.f(''update_buckets deleting old buckets for rrd_id %'', v_rrd.rrd_id);
        RAISE LOG ''update_buckets deleting old buckets for rrd_id %'', v_rrd.rrd_id;
        -- Find out the most recent bucket we can delete
        v_delete_end_time := max_end_time_to_delete(v_rrd.rrd_id);
        -- Do the delete (won''t find any records if v_delete_end_time ended up NULL)
        /*
        debug.f(''update_buckets DELETE FROM rrd.bucket WHERE rrd_id = % AND end_time <= %''
                    , v_rrd.rrd_id
                    , CASE WHEN v_delete_end_time IS NULL THEN ''NULL'' ELSE to_char(v_delete_end_time) END
            );
        */
        DELETE FROM rrd.bucket
            WHERE rrd_id = v_rrd.rrd_id
                AND end_time <= v_delete_end_time
        ;
        GET DIAGNOSTICS v_rows = ROW_COUNT;

        --debug.f(''update_buckets % buckets deleted for rrd_id %'', SQL%ROWCOUNT, v_rrd.rrd_id);
        -- Add new records
        --debug.f(''update_buckets adding new buckets for rrd_id %'', v_rrd.rrd_id);
        RAISE LOG ''update_buckets: % buckets deleted, adding new buckets for rrd_id %'', v_rows, v_rrd.rrd_id;
        -- Is parent NULL? If so do things differently
        IF v_rrd.parent IS NULL THEN
            -- First, see if buckets already exist.
            SELECT max(end_time)
                INTO v_first_end_time
                FROM rrd.bucket
                WHERE rrd_id = v_rrd.rrd_id
            ;
            -- No records exist? Figure out the oldest time to use.
            IF v_first_end_time IS NULL THEN
                /*
                debug.f(''update_buckets no data found in rrd.bucket for top level rrd_id %''
                            || '', checking page_log.log''
                            , v_rrd.rrd_id
                    );
                */
                RAISE DEBUG ''update_buckets no data found in rrd.bucket for top level rrd_id %, checking page_log.log'' , v_rrd.rrd_id ;
                SELECT min(log_time)
                    INTO v_first_end_time
                    FROM page_log.log
                ;
            END IF;

            -- Now, figure out what bucket we should start adding with
            IF v_first_end_time IS NULL THEN
                --debug.f(''update_buckets no data found in page_log.log, skipping to next RRD'');
                RAISE DEBUG ''update_buckets no data found in page_log.log, skipping to next RRD'';
            ELSE
                v_first_end_time := rrd.interval_time( v_first_end_time, v_rrd.time_per_bucket) + v_rrd.time_per_bucket;
                --debug.f(''update_buckets new first_end_time is %'', v_first_end_time);
                RAISE DEBUG ''update_buckets new first_end_time is %'', v_first_end_time;
                v_rows :=  add_buckets(v_rrd.rrd_id, v_rrd.time_per_bucket, v_first_end_time, NULL);
                v_buckets_added = v_buckets_added + v_rows;
                RAISE LOG ''update_buckets: % buckets added'', v_rows;
            END IF;
        ELSE
            -- Parent is NOT NULL.
            -- See what the max end time should be based on our parent. Note that we only round
            -- down and don''t add an interval because we don''t want to try and populate a bucket
            -- until all the parent buckets it will need exist
            -- See what our current max bucket is
            RAISE DEBUG ''rrd.parent IS NOT NULL'';
            SELECT max(end_time)
                INTO v_first_end_time
                FROM rrd.bucket
                WHERE rrd_id = v_rrd.rrd_id
            ;
            -- No records? Use the minimum end time of our parent
            IF v_first_end_time IS NULL THEN
                /*
                debug.f(''update_buckets no buckets found for rrd_id %, checking parent (%) for data''
                            , v_rrd.rrd_id, v_rrd.parent
                    );
                    */
                RAISE DEBUG ''update_buckets no buckets found for rrd_id %, checking parent (%) for data'' , v_rrd.rrd_id, v_rrd.parent ;
                SELECT min(end_time)
                    INTO v_first_end_time
                    FROM rrd.bucket
                    WHERE rrd_id = v_rrd.parent
                ;
            END IF;

            IF v_first_end_time IS NULL THEN
                --debug.f(''update_buckets no data available for rrd_id %, skipping to next RRD'', v_rrd.rrd_id);
                RAISE DEBUG ''update_buckets no data available for rrd_id %, skipping to next RRD'', v_rrd.rrd_id;
            ELSE
                SELECT max(end_time)
                    INTO v_last_end_time
                    FROM rrd.bucket
                    WHERE rrd_id = v_rrd.parent
                ;
                v_rows := add_buckets(v_rrd.rrd_id, v_rrd.time_per_bucket, v_first_end_time, v_last_end_time);
                v_buckets_added = v_buckets_added + v_rows;
                RAISE LOG ''update_buckets: % buckets added'', v_rows;
            END IF;
        END IF;
    END LOOP;
    --debug.f(''update_buckets exit'');
    RETURN v_buckets_added;
END;
'
    LANGUAGE plpgsql;


--
-- TOC entry 4 (OID 588605678)
-- Name: rrd; Type: TABLE; Schema: rrd; Owner: decibel
--

CREATE TABLE rrd (
    rrd_id integer NOT NULL,
    minor_divisor integer NOT NULL,
    major_divisor integer NOT NULL,
    keep_buckets integer NOT NULL,
    parent integer,
    parent_buckets integer,
    time_per_bucket interval(0) NOT NULL,
    rrd_name character varying(40) NOT NULL,
    CONSTRAINT rrd_rrd__ck_parent_rrd_id CHECK (((parent IS NULL) OR (parent < rrd_id)))
) WITHOUT OIDS;


--
-- TOC entry 5 (OID 588605683)
-- Name: bucket; Type: TABLE; Schema: rrd; Owner: decibel
--

CREATE TABLE bucket (
    bucket_id serial NOT NULL,
    rrd_id integer NOT NULL,
    end_time timestamp with time zone NOT NULL,
    prev_end_time timestamp with time zone NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 12 (OID 588605686)
-- Name: interval_time(timestamp with time zone, interval); Type: FUNCTION; Schema: rrd; Owner: decibel
--

CREATE FUNCTION interval_time(timestamp with time zone, interval) RETURNS timestamp with time zone
    AS '
SELECT ''1970-01-01 GMT''::timestamptz +
            (
                (
                    floor( extract( EPOCH FROM $1 ) / extract( EPOCH FROM $2 ) ) * extract( EPOCH FROM $2 )::int
                )::text || '' seconds''
            )::interval
;
'
    LANGUAGE sql IMMUTABLE STRICT;


--
-- TOC entry 14 (OID 588605687)
-- Name: add_buckets(integer, interval, timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: rrd; Owner: decibel
--

CREATE FUNCTION add_buckets(integer, interval, timestamp with time zone, timestamp with time zone) RETURNS integer
    AS '
DECLARE
    p_rrd_id ALIAS FOR $1;
    p_time_per_bucket ALIAS FOR $2;
    p_first_end_time ALIAS FOR $3;
    p_last_end_time ALIAS FOR $4;

    v_current_end_time    TIMESTAMP WITH TIME ZONE;
    v_max_end_time        TIMESTAMP WITH TIME ZONE;
    v_buckets_added       int := 0;
BEGIN
        --debug.f(''update_rrd_buckets: add_buckets called with NULL first_end_time'');
    IF p_first_end_time IS NOT NULL THEN
        RAISE DEBUG ''update_rrd_buckets: add_buckets enter (rrd_id=%, time_per_bucket=%, first_end_time=>%, last_end_time=>%)'', p_rrd_id, p_time_per_bucket, p_first_end_time, p_last_end_time;
        -- Set v_current_end_time to a "cleaned up" version of first_end_time that we know falls
        -- on the proper boundaries
        v_current_end_time := rrd.interval_time( p_first_end_time, p_time_per_bucket );

        -- Figure out what the most recent bucket we can create is
        v_max_end_time := rrd.interval_time( coalesce( p_last_end_time, current_timestamp ), p_time_per_bucket ); 
        /*
        debug.f(''add_buckets: adding buckets for rrd_id % between % and %''
                    , p_rrd_id
                    , v_current_end_time
                    , v_max_end_time
            );
        */
        RAISE DEBUG ''add_buckets: adding buckets for rrd_id % between % and %'', p_rrd_id, v_current_end_time, v_max_end_time;
        WHILE v_current_end_time <= v_max_end_time
        LOOP
            IF NOT EXISTS( SELECT * FROM rrd.bucket WHERE rrd_id = p_rrd_id AND end_time = v_current_end_time ) THEN
                INSERT INTO rrd.bucket(rrd_id, end_time, prev_end_time)
                    VALUES(p_rrd_id, v_current_end_time, v_current_end_time - p_time_per_bucket)
                ;
                v_buckets_added := v_buckets_added + 1;
            END IF;
            v_current_end_time := v_current_end_time + p_time_per_bucket;
        END LOOP;
        --debug.f(''update_rrd_buckets % buckets added to rrd_id %'', v_buckets_added, p_rrd_id);
        RAISE DEBUG ''add_buckets: % buckets added to rrd_id %'', v_buckets_added, p_rrd_id;
    END IF;

    RETURN v_buckets_added;
END;
'
    LANGUAGE plpgsql;


--
-- Data for TOC entry 15 (OID 588605678)
-- Name: rrd; Type: TABLE DATA; Schema: rrd; Owner: decibel
--

COPY rrd (rrd_id, minor_divisor, major_divisor, keep_buckets, parent, parent_buckets, time_per_bucket, rrd_name) FROM stdin;
1	1	10	60	\N	\N	00:01:00	last hour
2	1	10	60	1	4	00:04:00	last 4 hours
3	1	10	60	2	3	00:12:00	last 12 hours
4	2	12	48	1	30	00:30:00	last day
5	2	8	56	4	6	03:00:00	last week
6	6	42	168	4	8	04:00:00	last month
7	30	30	365	6	6	1 day	last year
\.


--
-- Data for TOC entry 16 (OID 588605683)
-- Name: bucket; Type: TABLE DATA; Schema: rrd; Owner: decibel
--

COPY bucket (bucket_id, rrd_id, end_time, prev_end_time) FROM stdin;
\.


--
-- TOC entry 7 (OID 588605688)
-- Name: rrd_rrd__rrd_id; Type: CONSTRAINT; Schema: rrd; Owner: decibel
--

ALTER TABLE ONLY rrd
    ADD CONSTRAINT rrd_rrd__rrd_id PRIMARY KEY (rrd_id);


--
-- TOC entry 8 (OID 588605690)
-- Name: rrd_rrd__rrd_name; Type: CONSTRAINT; Schema: rrd; Owner: decibel
--

ALTER TABLE ONLY rrd
    ADD CONSTRAINT rrd_rrd__rrd_name UNIQUE (rrd_name);


--
-- TOC entry 9 (OID 588605692)
-- Name: rrd_bucket__bucket_id; Type: CONSTRAINT; Schema: rrd; Owner: decibel
--

ALTER TABLE ONLY bucket
    ADD CONSTRAINT rrd_bucket__bucket_id PRIMARY KEY (bucket_id);


--
-- TOC entry 10 (OID 588605694)
-- Name: rrd_bucket__rrd_id__end_time; Type: CONSTRAINT; Schema: rrd; Owner: decibel
--

ALTER TABLE ONLY bucket
    ADD CONSTRAINT rrd_bucket__rrd_id__end_time UNIQUE (rrd_id, end_time);


--
-- TOC entry 17 (OID 588605696)
-- Name: rrd_rrd__rrd_parent; Type: FK CONSTRAINT; Schema: rrd; Owner: decibel
--

ALTER TABLE ONLY rrd
    ADD CONSTRAINT rrd_rrd__rrd_parent FOREIGN KEY (parent) REFERENCES rrd(rrd_id);


--
-- TOC entry 18 (OID 588605700)
-- Name: rrd_bucket__rrd_id; Type: FK CONSTRAINT; Schema: rrd; Owner: decibel
--

ALTER TABLE ONLY bucket
    ADD CONSTRAINT rrd_bucket__rrd_id FOREIGN KEY (rrd_id) REFERENCES rrd(rrd_id);


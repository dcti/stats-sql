--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;

--
-- TOC entry 3 (OID 591228954)
-- Name: rrd; Type: SCHEMA; Schema: -; Owner: 
--

CREATE OR REPLACE SCHEMA rrd AUTHORIZATION pgsql;


SET SESSION AUTHORIZATION 'pgsql';

SET search_path = rrd, pg_catalog;

--
-- TOC entry 16 (OID 591228955)
-- Name: update(); Type: FUNCTION; Schema: rrd; Owner: pgsql
--

CREATE OR REPLACE FUNCTION "update"() RETURNS integer
    AS '
DECLARE
    v_max_end_time rrd.bucket.end_time%TYPE;
    v_last_end_time rrd.bucket.end_time%TYPE;
    v_rows int;
    v_total_rows int;
    v_rrd rrd.rrd%ROWTYPE;
    v_source rrd.source%ROWTYPE;
    v_sql text;
BEGIN
    -- First, make sure all the buckets are up to date
    v_total_rows := rrd.update_buckets();

    -- Run through each source, updating each RRD for each source
    FOR v_source IN SELECT * FROM rrd.source
    LOOP
    RAISE INFO ''rrd.update: source_name = %'', v_source.source_name;
        -- Run through all the RRDs
        FOR v_rrd IN SELECT * FROM rrd.rrd ORDER BY coalesce( parent, -1 ), rrd_id
        LOOP
            v_rows := 0;
            SELECT max(end_time)
                INTO v_max_end_time
                FROM rrd.bucket
                WHERE rrd_id = v_rrd.rrd_id
            ;

            IF v_max_end_time IS NOT NULL THEN
                SELECT INTO v_last_end_time
                        last_end_time
                    FROM rrd.source_status
                    WHERE rrd_id = v_rrd.rrd_id
                        AND source_id = v_source.source_id
                ;
                IF NOT FOUND THEN
                    v_last_end_time := ''1970-01-01''::timestamptz;
                END IF;

                IF v_last_end_time = v_max_end_time THEN
                    RAISE INFO ''Nothing to do for % rrd_id %, skipping...'', v_source.source_name, v_rrd.rrd_id;
                ELSE
                    RAISE INFO ''Inserting into % for rrd_id % from % to %'', v_source.source_name, v_rrd.rrd_id, v_last_end_time, v_max_end_time;
                    IF v_rrd.parent IS NULL THEN
                        v_sql :=
                        ''INSERT INTO '' || v_source.insert_table || ''
                                            ( bucket_id, '' || v_source.group_clause || '', ''
                                                        || v_source.insert_aggregate_fields || '' )
                            SELECT a.rrd_bucket_id, '' || v_source.group_clause || ''
                                        , '' || v_source.primary_aggregate || ''
                                FROM
                                    (SELECT b.bucket_id AS rrd_bucket_id, s.*
                                        FROM rrd.bucket b
                                            JOIN '' || v_source.source_table || '' s
                                                ON (
                                                    b.prev_end_time  < '' || quote_ident(v_source.source_timestamptz_field) || ''
                                                    AND b.end_time >= '' || quote_ident(v_source.source_timestamptz_field) || '' )
                                        WHERE b.rrd_id = '' || quote_literal(v_rrd.rrd_id) || ''
                                            AND b.end_time <= '' || quote_literal(v_max_end_time) || ''
                                            AND b.end_time > '' || quote_literal(v_last_end_time) || ''
                                    ) a
                                GROUP BY rrd_bucket_id, '' || v_source.group_clause || '';''
                        ;
                    ELSE
                        -- Thanks to dealing with rrd.bucket twice, this query is a bit tricky. We want to look at rrd.bucket
                        -- for the rrd we''re *updating*, so that we know what our ranges are. Then, we want to query the 
                        -- parent data, and group it by the different ranges
                        v_sql := 
                        ''INSERT INTO '' || v_source.insert_table || ''
                                            ( bucket_id, '' || v_source.group_clause || '', ''
                                                        || v_source.insert_aggregate_fields || '' )
                            SELECT a.rrd_bucket_id, '' || v_source.group_clause || ''
                                        , '' || v_source.rrd_aggregate || ''
                                FROM 
                                    -- Wrap this whole thing in a sub-select to avoid field name conflicts
                                    (
                                    SELECT b.bucket_id AS rrd_bucket_id, r.*
                                        FROM '' || v_source.insert_table || '' r
                                            JOIN rrd.bucket p ON (r.bucket_id = p.bucket_id)
                                            , rrd.bucket b

                                        -- Get just the appropriate buckets for the RRD we are *updating*
                                        WHERE b.rrd_id = '' || quote_literal(v_rrd.rrd_id) || ''
                                            AND b.end_time <= '' || quote_literal(v_max_end_time) || ''
                                            AND b.end_time > '' || quote_literal(v_last_end_time) || ''

                                        -- Select the parent data but only for the appropriate time slots
                                            AND p.rrd_id = '' || quote_literal(v_rrd.parent) || ''
                                            AND p.end_time <= b.end_time
                                            AND p.end_time > b.prev_end_time
                                    ) a
                                GROUP BY rrd_bucket_id, '' || v_source.group_clause || '';''
                        ;
                    END IF;
                    RAISE DEBUG ''Executing query: %'', v_sql;
                    EXECUTE v_sql;

                    GET DIAGNOSTICS v_rows = ROW_COUNT;
                    RAISE INFO ''% rows inserted'', v_rows;

                    UPDATE rrd.source_status
                        SET last_end_time = v_max_end_time
                        WHERE rrd_id = v_rrd.rrd_id
                            AND source_id = v_source.source_id
                    ;
                    IF NOT FOUND THEN
                        INSERT INTO rrd.source_status( rrd_id, source_id, last_end_time )
                            VALUES( v_rrd.rrd_id, v_source.source_id, v_max_end_time )
                        ;
                    END IF;
                END IF;
            END IF;

            v_total_rows := v_total_rows + v_rows;
            --debug.f(''alert_rrd %s rows added for rrd_id %s'', v_rows, v_rrd.rrd_id);
        END LOOP;
    END LOOP;

    --debug.f(''alert_rrd exit'');
    RETURN v_total_rows;
END;
'
    LANGUAGE plpgsql;

--
-- TOC entry 17 (OID 591228975)
-- Name: max_end_time_to_delete(integer); Type: FUNCTION; Schema: rrd; Owner: pgsql
--

CREATE OR REPLACE FUNCTION max_end_time_to_delete(integer) RETURNS timestamp with time zone
    AS '
DECLARE
    p_rrd_id ALIAS FOR $1;
    v_min_end_time TIMESTAMP WITH TIME ZONE;
BEGIN
    -- For each rrd if no data has been captured yet we''ll get a null. If we do
    -- that means don''t delete anything.

    -- Update maximum end_time that can be removed based on rrd_source_status
    -- We don''t want to delete any buckets that have never been updated. We also
    -- need to consider that there may be sources with no records in source_status, so
    -- we do an outer join.
    -- We also need to take our parent RRDs into account.
    SELECT INTO v_min_end_time
            min(last_end_time)
        FROM rrd.source_status ss
            JOIN rrd.rrd r ON (ss.rrd_id = r.rrd_id)
            RIGHT JOIN rrd.source s ON (ss.source_id = s.source_id)
        WHERE r.rrd_id = p_rrd_id
            OR r.parent = p_rrd_id
    ;

    /*
    SELECT debug.f(''update_rrd_buckets v_min_end_time for rrd_id %s after alert_rrd = %s''::text
                , p_rrd_id::text
                , coalesce(v_min_end_time::text, ''NULL'')
        );
        */
    RAISE DEBUG ''v_min_end_time for rrd % after rrd.source_status = %'', p_rrd_id, v_min_end_time;

    -- Check on keep_buckets
    -- Find the last bucket created, and subtract keep buckets from it
    -- No reason to run this if v_min_end_time is already null
    IF v_min_end_time IS NOT NULL THEN
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
    END IF;
    
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
-- TOC entry 18 (OID 591228976)
-- Name: update_buckets(); Type: FUNCTION; Schema: rrd; Owner: pgsql
--

CREATE OR REPLACE FUNCTION update_buckets() RETURNS integer
    AS '
DECLARE
    v_delete_end_time TIMESTAMP WITH TIME ZONE;
    v_first_end_time TIMESTAMP WITH TIME ZONE;
    v_last_end_time TIMESTAMP WITH TIME ZONE;
    v_rrd rrd.rrd%ROWTYPE;
    v_source rrd.source%ROWTYPE;
    v_rows int;
    v_sql text;
    v_rec record;
    v_buckets_added int := 0;
BEGIN
    --debug.f(''update_buckets enter'');
    -- Run through each RRD
    FOR v_rrd IN SELECT * FROM rrd.rrd ORDER BY coalesce( parent, -1 ), rrd_id
    LOOP
        --debug.f(''update_buckets deleting old buckets for rrd_id %'', v_rrd.rrd_id);
        RAISE INFO ''update_buckets deleting old buckets for rrd_id %'', v_rrd.rrd_id;
        -- Find out the most recent bucket we can delete
        v_delete_end_time := rrd.max_end_time_to_delete(v_rrd.rrd_id);
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
        RAISE INFO ''update_buckets: % buckets deleted, adding new buckets for rrd_id %'', v_rows, v_rrd.rrd_id;
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
                RAISE LOG ''update_buckets no data found in rrd.bucket for top level rrd_id %, checking sources'' , v_rrd.rrd_id ;
                v_sql := NULL;
                FOR v_source IN SELECT * FROM rrd.source
                LOOP
                    IF v_sql IS NOT NULL THEN
                        v_sql := v_sql || ''
                                UNION ALL'';;
                    END IF;
                    v_sql := v_sql || ''
                        SELECT min('' || quote_ident(v_source.source_timestamptz_field) || '') AS ts
                            FROM '' || v_source.source_table 
                    ;
                END LOOP;
                v_sql := ''
                    SELECT min(ts) AS ts
                        FROM ('' || v_sql || ''
                            ) a
                    ''
                ;
                RAISE DEBUG ''executing SQL: %'', v_sql;
                FOR v_rec IN EXECUTE v_sql
                LOOP
                    v_first_end_time := v_rec.ts;
                END LOOP;
            END IF;

            -- Now, figure out what bucket we should start adding with
            IF v_first_end_time IS NULL THEN
                --debug.f(''update_buckets no data found in page_log.log, skipping to next RRD'');
                RAISE LOG ''update_buckets no data found in sources, skipping to next RRD'';
            ELSE
                v_first_end_time := rrd.interval_time( v_first_end_time, v_rrd.time_per_bucket) + v_rrd.time_per_bucket;
                --debug.f(''update_buckets new first_end_time is %'', v_first_end_time);
                RAISE LOG ''update_buckets new first_end_time is %'', v_first_end_time;
                v_rows :=  rrd.add_buckets(v_rrd.rrd_id, v_rrd.time_per_bucket, v_first_end_time, NULL::timestamptz);
                v_buckets_added = v_buckets_added + v_rows;
                RAISE INFO ''update_buckets: % buckets added'', v_rows;
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
                RAISE LOG ''update_buckets no buckets found for rrd_id %, checking parent (%) for data'' , v_rrd.rrd_id, v_rrd.parent ;
                SELECT min(end_time)
                    INTO v_first_end_time
                    FROM rrd.bucket
                    WHERE rrd_id = v_rrd.parent
                ;
            END IF;

            IF v_first_end_time IS NULL THEN
                --debug.f(''update_buckets no data available for rrd_id %, skipping to next RRD'', v_rrd.rrd_id);
                RAISE LOG ''update_buckets no data available for rrd_id %, skipping to next RRD'', v_rrd.rrd_id;
            ELSE
                SELECT max(end_time)
                    INTO v_last_end_time
                    FROM rrd.bucket
                    WHERE rrd_id = v_rrd.parent
                ;
                v_rows := rrd.add_buckets(v_rrd.rrd_id, v_rrd.time_per_bucket, v_first_end_time, v_last_end_time);
                v_buckets_added = v_buckets_added + v_rows;
                RAISE INFO ''update_buckets: % buckets added'', v_rows;
            END IF;
        END IF;
    END LOOP;
    --debug.f(''update_buckets exit'');
    RETURN v_buckets_added;
END;
'
    LANGUAGE plpgsql;


--
-- TOC entry 19 (OID 591228977)
-- Name: interval_time(timestamp with time zone, interval); Type: FUNCTION; Schema: rrd; Owner: pgsql
--

CREATE OR REPLACE FUNCTION interval_time(timestamp with time zone, interval) RETURNS timestamp with time zone
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
-- TOC entry 20 (OID 591228978)
-- Name: add_buckets(integer, interval, timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: rrd; Owner: pgsql
--

CREATE OR REPLACE FUNCTION add_buckets(integer, interval, timestamp with time zone, timestamp with time zone) RETURNS integer
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


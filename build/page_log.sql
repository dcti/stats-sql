--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;

SET SESSION AUTHORIZATION 'pgsql';

SET search_path = page_log, pg_catalog;

ALTER TABLE ONLY page_log.rrd DROP CONSTRAINT rrd__ri_bucket_id;
ALTER TABLE ONLY page_log.rrd DROP CONSTRAINT rrd__page_page_id;
ALTER TABLE ONLY page_log.rrd_status DROP CONSTRAINT rrd_status__ri_rrd_id;
ALTER TABLE ONLY page_log.log DROP CONSTRAINT log__page_id;
ALTER TABLE ONLY page_log.rrd DROP CONSTRAINT rrd__page_project_other_bucket;
ALTER TABLE ONLY page_log.rrd_status DROP CONSTRAINT rrd_status__rrd_id;
ALTER TABLE ONLY page_log.page DROP CONSTRAINT page__page_name;
ALTER TABLE ONLY page_log.page DROP CONSTRAINT pages__page_id;
DROP INDEX page_log.page_log_rrd__bucket_id;
DROP INDEX page_log.log__log_time;
DROP VIEW page_log.v_rrd;
DROP TABLE page_log.rrd;
DROP FUNCTION page_log.update_rrd();
DROP TABLE page_log.rrd_status;
DROP FUNCTION page_log.log(character varying, integer, character, interval);
DROP FUNCTION page_log.log(character varying, interval);
DROP FUNCTION page_log.page_inslect(character varying);
DROP TABLE page_log.log;
DROP TABLE page_log.page;
SET SESSION AUTHORIZATION DEFAULT;

DROP SCHEMA page_log;
--
-- TOC entry 3 (OID 582083283)
-- Name: page_log; Type: SCHEMA; Schema: -; Owner: 
--

CREATE SCHEMA page_log AUTHORIZATION pgsql;


SET SESSION AUTHORIZATION 'pgsql';

--
-- TOC entry 4 (OID 582083283)
-- Name: page_log; Type: ACL; Schema: -; Owner: pgsql
--

REVOKE ALL ON SCHEMA page_log FROM PUBLIC;
GRANT USAGE ON SCHEMA page_log TO PUBLIC;


--
-- TOC entry 5 (OID 582083286)
-- Name: page; Type: TABLE; Schema: page_log; Owner: pgsql
--

CREATE TABLE page (
    page_id serial NOT NULL,
    page_name character varying(200) NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 6 (OID 582083286)
-- Name: page; Type: ACL; Schema: page_log; Owner: pgsql
--

REVOKE ALL ON TABLE page FROM PUBLIC;
GRANT INSERT,SELECT ON TABLE page TO GROUP www;


--
-- TOC entry 12 (OID 582083286)
-- Name: page_page_id_seq; Type: ACL; Schema: page_log; Owner: pgsql
--

REVOKE ALL ON TABLE page_page_id_seq FROM PUBLIC;
GRANT SELECT ON TABLE page_page_id_seq TO GROUP www;
GRANT UPDATE ON TABLE page_page_id_seq TO www;


--
-- TOC entry 7 (OID 582083289)
-- Name: log; Type: TABLE; Schema: page_log; Owner: pgsql
--

CREATE TABLE log (
    log_time timestamp with time zone NOT NULL,
    page_id integer NOT NULL,
    duration interval NOT NULL,
    project_id integer,
    other character(1)
);


--
-- TOC entry 8 (OID 582083289)
-- Name: log; Type: ACL; Schema: page_log; Owner: pgsql
--

REVOKE ALL ON TABLE log FROM PUBLIC;
GRANT INSERT ON TABLE log TO GROUP www;


--
-- TOC entry 19 (OID 582083291)
-- Name: page_inslect(character varying); Type: FUNCTION; Schema: page_log; Owner: pgsql
--

CREATE FUNCTION page_inslect(character varying) RETURNS integer
    AS '
DECLARE
    v_page_name ALIAS FOR $1;
    v_page_id page_log.page.page_id%TYPE;
BEGIN
    SELECT page_id INTO v_page_id
        FROM page_log.page
        WHERE page_name = v_page_name
    ;
    IF NOT FOUND THEN
        INSERT INTO page_log.page( page_name ) VALUES( v_page_name );
        v_page_id := currval( ''page_log.page_page_id_seq'' );
    END IF;
    RETURN v_page_id;
END;
'
    LANGUAGE plpgsql;


--
-- TOC entry 20 (OID 582083292)
-- Name: log(character varying, interval); Type: FUNCTION; Schema: page_log; Owner: pgsql
--

CREATE FUNCTION log(character varying, interval) RETURNS void
    AS '
DECLARE
    v_page_name ALIAS FOR $1;
    v_duration ALIAS FOR $2;
BEGIN
    INSERT INTO page_log.log( log_time, page_id, duration )
        VALUES( now(), page_log.page_inslect( v_page_name ), v_duration )
    ;
    RETURN;
END;
'
    LANGUAGE plpgsql;


--
-- TOC entry 21 (OID 582083292)
-- Name: log(character varying, interval); Type: ACL; Schema: page_log; Owner: pgsql
--

REVOKE ALL ON FUNCTION log(character varying, interval) FROM PUBLIC;
GRANT ALL ON FUNCTION log(character varying, interval) TO PUBLIC;
GRANT ALL ON FUNCTION log(character varying, interval) TO GROUP www;


--
-- TOC entry 22 (OID 582083293)
-- Name: log(character varying, integer, character, interval); Type: FUNCTION; Schema: page_log; Owner: pgsql
--

CREATE FUNCTION log(character varying, integer, character, interval) RETURNS void
    AS '
DECLARE
    v_page_name ALIAS FOR $1;
    v_project_id ALIAS FOR $2;
    v_other ALIAS FOR $3;
    v_duration ALIAS FOR $4;
BEGIN
    INSERT INTO page_log.log( log_time, page_id, project_id, other, duration )
        VALUES( now(), page_log.page_inslect( v_page_name ), v_project_id, v_other, v_duration )
    ;
    RETURN;
END;
'
    LANGUAGE plpgsql;


--
-- TOC entry 9 (OID 582083294)
-- Name: rrd_status; Type: TABLE; Schema: page_log; Owner: pgsql
--

CREATE TABLE rrd_status (
    rrd_id integer NOT NULL,
    last_end_time timestamp with time zone NOT NULL
);


--
-- TOC entry 23 (OID 588605714)
-- Name: update_rrd(); Type: FUNCTION; Schema: page_log; Owner: pgsql
--

CREATE FUNCTION update_rrd() RETURNS integer
    AS '
DECLARE
    v_max_end_time rrd.bucket.end_time%TYPE;
    v_last_end_time rrd.bucket.end_time%TYPE;
    v_rows int;
    v_total_rows int := 0;
    v_rrd rrd.rrd%ROWTYPE;
BEGIN
    --debug.f(''alert_rrd enter'');
    -- Run through all the RRDs
    FOR v_rrd IN SELECT * FROM rrd.rrd ORDER BY coalesce( parent, -1 ), rrd_id
    LOOP
        v_rows := 0;
        SELECT max(end_time)
            INTO v_max_end_time
            FROM rrd.bucket
            WHERE rrd_id = v_rrd.rrd_id
        ;

        -- If there''s no data, just skip to the next RRD
        IF v_max_end_time IS NOT NULL THEN
            SELECT INTO v_last_end_time
                    last_end_time
                FROM page_log.rrd_status
                WHERE rrd_id = v_rrd.rrd_id
            ;
            IF NOT FOUND THEN
                v_last_end_time := ''1970-01-01''::timestamptz;
            END IF;

            RAISE LOG ''Inserting into page_log.rrd for rrd_id % from % to %'', v_rrd.rrd_id, v_last_end_time, v_max_end_time;
            IF v_rrd.parent IS NULL THEN
                INSERT INTO page_log.rrd( bucket_id, page_id, project_id, other
                                            , hits, min_hits, max_hits
                                        )
                    SELECT b.bucket_id, l.page_id, l.project_id, other
                                            , count(*), count(*), count(*)
                        FROM rrd.bucket b
                            JOIN page_log.log l ON ( l.log_time > b.prev_end_time AND l.log_time <= b.end_time )
                        WHERE b.rrd_id = v_rrd.rrd_id
                            AND b.end_time <= v_max_end_time
                            AND b.end_time > v_last_end_time
                        GROUP BY b.bucket_id, l.page_id, l.project_id, other
                ;
            ELSE
                -- Thanks to dealing with rrd.bucket twice, this query is a bit tricky. We want to look at rrd.bucket
                -- for the rrd we''re *updating*, so that we know what our ranges are. Then, we want to query the 
                -- parent data, and group it by the different ranges
                INSERT INTO page_log.rrd( bucket_id, page_id, project_id, other
                                            , hits, min_hits, max_hits
                                        )
                    SELECT b.bucket_id, l.page_id, l.project_id, other
                                            , sum(hits), min(hits), max(hits)
                        FROM rrd.bucket b
                            , page_log.v_rrd l

                        -- Get just the appropriate buckets for the RRD we''re *updating*
                        WHERE b.rrd_id = v_rrd.rrd_id
                            AND b.end_time <= v_max_end_time
                            AND b.end_time > v_last_end_time

                        -- Select the parent data but only for the appropriate time slots
                            AND l.rrd_id = v_rrd.parent
                            AND l.end_time <= b.end_time
                            AND l.end_time > b.prev_end_time
                        GROUP BY b.bucket_id, l.page_id, l.project_id, other
                ;
            END IF;

            GET DIAGNOSTICS v_rows = ROW_COUNT;
            RAISE LOG ''% rows inserted'', v_rows;

            UPDATE page_log.rrd_status
                SET last_end_time = v_max_end_time
                WHERE rrd_id = v_rrd.rrd_id
            ;
            IF NOT FOUND THEN
                INSERT INTO page_log.rrd_status( rrd_id, last_end_time )
                    VALUES( v_rrd.rrd_id, v_max_end_time )
                ;
            END IF;
        END IF;

        v_total_rows := v_total_rows + v_rows;
        --debug.f(''alert_rrd %s rows added for rrd_id %s'', v_rows, v_rrd.rrd_id);
    END LOOP;

    --debug.f(''alert_rrd exit'');
    RETURN v_total_rows;
END;
'
    LANGUAGE plpgsql;


--
-- TOC entry 10 (OID 588643449)
-- Name: rrd; Type: TABLE; Schema: page_log; Owner: pgsql
--

CREATE TABLE rrd (
    bucket_id integer NOT NULL,
    page_id integer NOT NULL,
    project_id integer NOT NULL,
    hits integer NOT NULL,
    min_hits double precision NOT NULL,
    max_hits double precision NOT NULL,
    other character(1) DEFAULT ''::bpchar NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 11 (OID 588643454)
-- Name: v_rrd; Type: VIEW; Schema: page_log; Owner: pgsql
--

CREATE VIEW v_rrd AS
    SELECT b.rrd_id, b.end_time, b.prev_end_time, r.bucket_id, r.page_id, r.project_id, r.other, r.hits, r.min_hits, r.max_hits FROM (rrd r JOIN rrd.bucket b ON ((r.bucket_id = b.bucket_id)));


--
-- TOC entry 15 (OID 588624158)
-- Name: log__log_time; Type: INDEX; Schema: page_log; Owner: pgsql
--

CREATE INDEX log__log_time ON log USING btree (log_time);


--
-- TOC entry 17 (OID 588643455)
-- Name: page_log_rrd__bucket_id; Type: INDEX; Schema: page_log; Owner: pgsql
--

CREATE INDEX page_log_rrd__bucket_id ON rrd USING btree (bucket_id);


--
-- TOC entry 14 (OID 582427015)
-- Name: pages__page_id; Type: CONSTRAINT; Schema: page_log; Owner: pgsql
--

ALTER TABLE ONLY page
    ADD CONSTRAINT pages__page_id PRIMARY KEY (page_id);


--
-- TOC entry 13 (OID 582427017)
-- Name: page__page_name; Type: CONSTRAINT; Schema: page_log; Owner: pgsql
--

ALTER TABLE ONLY page
    ADD CONSTRAINT page__page_name UNIQUE (page_name);


--
-- TOC entry 16 (OID 582427019)
-- Name: rrd_status__rrd_id; Type: CONSTRAINT; Schema: page_log; Owner: pgsql
--

ALTER TABLE ONLY rrd_status
    ADD CONSTRAINT rrd_status__rrd_id PRIMARY KEY (rrd_id);


--
-- TOC entry 18 (OID 588643456)
-- Name: rrd__page_project_other_bucket; Type: CONSTRAINT; Schema: page_log; Owner: pgsql
--

ALTER TABLE ONLY rrd
    ADD CONSTRAINT rrd__page_project_other_bucket PRIMARY KEY (page_id, project_id, other, bucket_id);


--
-- TOC entry 24 (OID 582427021)
-- Name: log__page_id; Type: FK CONSTRAINT; Schema: page_log; Owner: pgsql
--

ALTER TABLE ONLY log
    ADD CONSTRAINT log__page_id FOREIGN KEY (page_id) REFERENCES page(page_id);


--
-- TOC entry 25 (OID 588605723)
-- Name: rrd_status__ri_rrd_id; Type: FK CONSTRAINT; Schema: page_log; Owner: pgsql
--

ALTER TABLE ONLY rrd_status
    ADD CONSTRAINT rrd_status__ri_rrd_id FOREIGN KEY (rrd_id) REFERENCES rrd.rrd(rrd_id);


--
-- TOC entry 26 (OID 588643458)
-- Name: rrd__page_page_id; Type: FK CONSTRAINT; Schema: page_log; Owner: pgsql
--

ALTER TABLE ONLY rrd
    ADD CONSTRAINT rrd__page_page_id FOREIGN KEY (page_id) REFERENCES page(page_id);


--
-- TOC entry 27 (OID 588643462)
-- Name: rrd__ri_bucket_id; Type: FK CONSTRAINT; Schema: page_log; Owner: pgsql
--

ALTER TABLE ONLY rrd
    ADD CONSTRAINT rrd__ri_bucket_id FOREIGN KEY (bucket_id) REFERENCES rrd.bucket(bucket_id) ON DELETE CASCADE;



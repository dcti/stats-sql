--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;

--
-- TOC entry 3 (OID 443354)
-- Name: page_log; Type: SCHEMA; Schema: -; Owner: 
--

CREATE SCHEMA page_log AUTHORIZATION pgsql;


SET SESSION AUTHORIZATION 'pgsql';

--
-- TOC entry 4 (OID 443354)
-- Name: page_log; Type: ACL; Schema: -; Owner: pgsql
--

REVOKE ALL ON SCHEMA page_log FROM PUBLIC;
GRANT USAGE ON SCHEMA page_log TO PUBLIC;


SET SESSION AUTHORIZATION 'pgsql';

SET search_path = page_log, pg_catalog;

--
-- TOC entry 5 (OID 443357)
-- Name: page; Type: TABLE; Schema: page_log; Owner: pgsql
--

CREATE TABLE page (
    page_id serial NOT NULL,
    page_name character varying(200) NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 6 (OID 443357)
-- Name: page; Type: ACL; Schema: page_log; Owner: pgsql
--

REVOKE ALL ON TABLE page FROM PUBLIC;
GRANT INSERT,SELECT ON TABLE page TO GROUP www;


--
-- TOC entry 10 (OID 443357)
-- Name: page_page_id_seq; Type: ACL; Schema: page_log; Owner: pgsql
--

REVOKE ALL ON TABLE page_page_id_seq FROM PUBLIC;
GRANT SELECT ON TABLE page_page_id_seq TO GROUP www;
GRANT UPDATE ON TABLE page_page_id_seq TO www;


--
-- TOC entry 15 (OID 443362)
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
-- TOC entry 16 (OID 443363)
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
-- TOC entry 17 (OID 443363)
-- Name: log(character varying, interval); Type: ACL; Schema: page_log; Owner: pgsql
--

REVOKE ALL ON FUNCTION log(character varying, interval) FROM PUBLIC;
GRANT ALL ON FUNCTION log(character varying, interval) TO PUBLIC;
GRANT ALL ON FUNCTION log(character varying, interval) TO GROUP www;


--
-- TOC entry 18 (OID 443364)
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
-- TOC entry 7 (OID 443365)
-- Name: rrd; Type: TABLE; Schema: page_log; Owner: pgsql
--

CREATE TABLE rrd (
    bucket_id integer NOT NULL,
    page_id integer NOT NULL,
    project_id integer NOT NULL,
    hits integer NOT NULL,
    min_hits double precision NOT NULL,
    max_hits double precision NOT NULL,
    total_duration interval NOT NULL,
    min_duration interval NOT NULL,
    max_duration interval NOT NULL,
    other character(1) DEFAULT ''::bpchar NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 8 (OID 443370)
-- Name: v_rrd; Type: VIEW; Schema: page_log; Owner: pgsql
--

CREATE VIEW v_rrd AS
    SELECT b.rrd_id, b.end_time, b.prev_end_time, r.bucket_id, r.page_id, r.project_id, r.hits, r.min_hits, r.max_hits, r.total_duration, r.min_duration, r.max_duration, r.other, (r.total_duration / (hits)::double precision) AS avg_duration FROM (rrd r JOIN rrd.bucket b ON ((r.bucket_id = b.bucket_id)));


SET SESSION AUTHORIZATION 'pgsql';

--
-- TOC entry 9 (OID 2279347)
-- Name: log; Type: TABLE; Schema: page_log; Owner: pgsql
--

CREATE TABLE log (
    log_time timestamp with time zone NOT NULL,
    page_id integer NOT NULL,
    duration interval NOT NULL,
    project_id integer,
    other character(1)
);


SET SESSION AUTHORIZATION 'pgsql';

--
-- TOC entry 13 (OID 443372)
-- Name: page_log_rrd__bucket_id; Type: INDEX; Schema: page_log; Owner: pgsql
--

CREATE INDEX page_log_rrd__bucket_id ON rrd USING btree (bucket_id);


--
-- TOC entry 12 (OID 443373)
-- Name: pages__page_id; Type: CONSTRAINT; Schema: page_log; Owner: pgsql
--

ALTER TABLE ONLY page
    ADD CONSTRAINT pages__page_id PRIMARY KEY (page_id);


--
-- TOC entry 11 (OID 443375)
-- Name: page__page_name; Type: CONSTRAINT; Schema: page_log; Owner: pgsql
--

ALTER TABLE ONLY page
    ADD CONSTRAINT page__page_name UNIQUE (page_name);


--
-- TOC entry 14 (OID 443377)
-- Name: rrd__page_project_other_bucket; Type: CONSTRAINT; Schema: page_log; Owner: pgsql
--

ALTER TABLE ONLY rrd
    ADD CONSTRAINT rrd__page_project_other_bucket PRIMARY KEY (page_id, project_id, other, bucket_id);


--
-- TOC entry 19 (OID 443383)
-- Name: rrd__page_page_id; Type: FK CONSTRAINT; Schema: page_log; Owner: pgsql
--

ALTER TABLE ONLY rrd
    ADD CONSTRAINT rrd__page_page_id FOREIGN KEY (page_id) REFERENCES page(page_id);


--
-- TOC entry 20 (OID 443387)
-- Name: rrd__ri_bucket_id; Type: FK CONSTRAINT; Schema: page_log; Owner: pgsql
--

ALTER TABLE ONLY rrd
    ADD CONSTRAINT rrd__ri_bucket_id FOREIGN KEY (bucket_id) REFERENCES rrd.bucket(bucket_id) ON DELETE CASCADE;



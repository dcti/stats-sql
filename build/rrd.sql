--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;

--
-- TOC entry 3 (OID 591228954)
-- Name: rrd; Type: SCHEMA; Schema: -; Owner: 
--

CREATE SCHEMA rrd AUTHORIZATION pgsql;
GRANT USAGE ON SCHEMA rrd TO PUBLIC;


SET SESSION AUTHORIZATION 'pgsql';

SET search_path = rrd, pg_catalog;

--
-- TOC entry 4 (OID 591228957)
-- Name: rrd; Type: TABLE; Schema: rrd; Owner: pgsql
--

CREATE TABLE rrd (
    rrd_id integer NOT NULL,
    keep_buckets integer NOT NULL,
    parent integer,
    parent_buckets integer,
    time_per_bucket interval(0) NOT NULL,
    rrd_name character varying(40) NOT NULL,
    CONSTRAINT rrd_rrd__ck_parent_rrd_id CHECK (((parent IS NULL) OR (parent < rrd_id)))
) WITHOUT OIDS;


--
-- TOC entry 5 (OID 591228960)
-- Name: source_status; Type: TABLE; Schema: rrd; Owner: pgsql
--

CREATE TABLE source_status (
    rrd_id integer NOT NULL,
    source_id integer NOT NULL,
    last_end_time timestamp with time zone NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 6 (OID 591228964)
-- Name: bucket; Type: TABLE; Schema: rrd; Owner: pgsql
--

CREATE TABLE bucket (
    bucket_id serial NOT NULL,
    rrd_id integer NOT NULL,
    end_time timestamp with time zone NOT NULL,
    prev_end_time timestamp with time zone NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 7 (OID 591228969)
-- Name: source; Type: TABLE; Schema: rrd; Owner: pgsql
--

CREATE TABLE source (
    source_id serial NOT NULL,
    source_name character varying(80),
    insert_table text NOT NULL,
    source_table text NOT NULL,
    source_timestamptz_field text NOT NULL,
    group_clause text NOT NULL,
    insert_aggregate_fields text NOT NULL,
    primary_aggregate text NOT NULL,
    rrd_aggregate text NOT NULL
) WITHOUT OIDS;





--
-- Data for TOC entry 21 (OID 591228957)
-- Name: rrd; Type: TABLE DATA; Schema: rrd; Owner: pgsql
--

COPY rrd (rrd_id, keep_buckets, parent, parent_buckets, time_per_bucket, rrd_name) FROM stdin;
1	60	\N	\N	00:01:00	last hour
2	60	1	4	00:04:00	last 4 hours
3	60	2	3	00:12:00	last 12 hours
4	48	1	30	00:30:00	last day
5	56	4	6	03:00:00	last week
6	168	4	8	04:00:00	last month
7	365	6	6	1 day	last year
\.


--
-- Data for TOC entry 22 (OID 591228960)
-- Name: source_status; Type: TABLE DATA; Schema: rrd; Owner: pgsql
--

COPY source_status (rrd_id, source_id, last_end_time) FROM stdin;
\.


--
-- Data for TOC entry 23 (OID 591228964)
-- Name: bucket; Type: TABLE DATA; Schema: rrd; Owner: pgsql
--

COPY bucket (bucket_id, rrd_id, end_time, prev_end_time) FROM stdin;
\.


--
-- Data for TOC entry 24 (OID 591228969)
-- Name: source; Type: TABLE DATA; Schema: rrd; Owner: pgsql
--

COPY source (source_id, source_name, insert_table, source_table, source_timestamptz_field, group_clause, insert_aggregate_fields, primary_aggregate, rrd_aggregate) FROM stdin;
1	page_log	page_log.rrd	page_log.log	log_time	page_id,project_id,other	hits,min_hits,max_hits,total_duration,min_duration,max_duration	count(*),count(*),count(*),sum(duration),min(duration),max(duration)	sum(hits),min(min_hits),max(max_hits),sum(total_duration),min(min_duration),max(max_duration)
\.


--
-- TOC entry 10 (OID 591228979)
-- Name: rrd_rrd__rrd_id; Type: CONSTRAINT; Schema: rrd; Owner: pgsql
--

ALTER TABLE ONLY rrd
    ADD CONSTRAINT rrd_rrd__rrd_id PRIMARY KEY (rrd_id);


--
-- TOC entry 12 (OID 591228981)
-- Name: rrd_bucket__bucket_id; Type: CONSTRAINT; Schema: rrd; Owner: pgsql
--

ALTER TABLE ONLY bucket
    ADD CONSTRAINT rrd_bucket__bucket_id PRIMARY KEY (bucket_id);


--
-- TOC entry 14 (OID 591228983)
-- Name: rrd_source__source_id; Type: CONSTRAINT; Schema: rrd; Owner: pgsql
--

ALTER TABLE ONLY source
    ADD CONSTRAINT rrd_source__source_id PRIMARY KEY (source_id);


--
-- TOC entry 15 (OID 591228985)
-- Name: rrd_source__source_name; Type: CONSTRAINT; Schema: rrd; Owner: pgsql
--

ALTER TABLE ONLY source
    ADD CONSTRAINT rrd_source__source_name UNIQUE (source_name);


--
-- TOC entry 11 (OID 591228987)
-- Name: rrd_rrd__rrd_name; Type: CONSTRAINT; Schema: rrd; Owner: pgsql
--

ALTER TABLE ONLY rrd
    ADD CONSTRAINT rrd_rrd__rrd_name UNIQUE (rrd_name);


--
-- TOC entry 13 (OID 591228989)
-- Name: rrd_bucket__rrd_id__end_time; Type: CONSTRAINT; Schema: rrd; Owner: pgsql
--

ALTER TABLE ONLY bucket
    ADD CONSTRAINT rrd_bucket__rrd_id__end_time UNIQUE (rrd_id, end_time);


--
-- TOC entry 26 (OID 591228991)
-- Name: rrd_source_status__rrd_id; Type: FK CONSTRAINT; Schema: rrd; Owner: pgsql
--

ALTER TABLE ONLY source_status
    ADD CONSTRAINT rrd_source_status__rrd_id FOREIGN KEY (rrd_id) REFERENCES rrd(rrd_id) ON DELETE CASCADE;

ALTER TABLE ONLY source_status
    ADD CONSTRAINT rrd_source_status__source_id FOREIGN KEY (source_id) REFERENCES source(source_id) ON DELETE CASCADE;

--
-- TOC entry 25 (OID 591228995)
-- Name: rrd_rrd__rrd_parent; Type: FK CONSTRAINT; Schema: rrd; Owner: pgsql
--

ALTER TABLE ONLY rrd
    ADD CONSTRAINT rrd_rrd__rrd_parent FOREIGN KEY (parent) REFERENCES rrd(rrd_id);


--
-- TOC entry 27 (OID 591228999)
-- Name: rrd_bucket__rrd_id; Type: FK CONSTRAINT; Schema: rrd; Owner: pgsql
--

ALTER TABLE ONLY bucket
    ADD CONSTRAINT rrd_bucket__rrd_id FOREIGN KEY (rrd_id) REFERENCES rrd(rrd_id);


--
-- TOC entry 8 (OID 591228962)
-- Name: bucket_bucket_id_seq; Type: SEQUENCE SET; Schema: rrd; Owner: pgsql
--

SELECT pg_catalog.setval('bucket_bucket_id_seq', 1, false);


--
-- TOC entry 9 (OID 591228967)
-- Name: source_source_id_seq; Type: SEQUENCE SET; Schema: rrd; Owner: pgsql
--

SELECT pg_catalog.setval('source_source_id_seq', 1, false);

GRANT SELECT ON rrd TO PUBLIC;
GRANT SELECT ON source TO PUBLIC;
GRANT SELECT,UPDATE ON source_source_id_seq TO PUBLIC;
GRANT ALL ON bucket TO PUBLIC;
GRANT ALL ON source_status TO PUBLIC;
GRANT SELECT,UPDATE ON bucket_bucket_id_seq TO PUBLIC;


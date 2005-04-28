--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;

SET SESSION AUTHORIZATION 'pgsql';

SET search_path = public, pg_catalog;

--
-- Data for TOC entry 2 (OID 117870424)
-- Name: projects; Type: TABLE DATA; Schema: public; Owner: pgsql
--

COPY projects (status, project_id, start_date, end_date, due_date, project_type, name, prize, description, dist_unit_qty, dist_unit_name, work_unit_qty, work_unit_disp_multiplier, work_unit_disp_divisor, work_unit_import_multiplier, unscaled_work_unit_name, scaled_work_unit_name, logfile_prefix, sponsor_url, sponsor_name, logo_url) FROM stdin;
V	5	\N	\N	\N	RC5	RC5-64	10000.00	RC5-64 contest	68719476736	Blocks	18446744073709551616	1	268435456	268435456	Keys	Blocks	RC5	http://www.rsa.com	RSA Data Systems, Inc.	http://stats.distributed.net/rc5-64/logo.gif
H	6	\N	\N	\N	CSC	CSC	10000.00	CSC contest	268435456	blocks	18446744073709551616	1	1	1	Keys	Blocks	CSC	http://www.csc.com	CS Communications, Inc.	http://stats.distributed.net/csc/logo.gif
O	8	2002-12-02	\N	\N	R72	RC5-72	10000.00	RC5-72 encryption contest	1099511627776	Blocks	4722366482869645213696	1	4294967296	4294967296	Keys	Blocks	R72	http://www.rsa.com	RSA Data Systems, Inc.	http://stats.distributed.net/rc5-64/logo.gif
O	25	2000-07-31	\N	\N	OGRP2	OGR-25	0.00	Optimal Golumb Ruler with 25 marks	0	stubs	0	1	1000000000	1	nodes	Gnodes	OGR	 	 	http://stats.distributed.net/ogr-25/logo.gif
H	3	\N	\N	\N	RC5	RC5-56	10000.00	RC5-56 contest	268435456	blocks	72057594037927936	1	268435456	1	Keys	Blocks	RC5	http://www.rsa.com	RSA Data Systems, Inc.	http://stats.distributed.net/rc5-56/logo.gif
V	205	\N	\N	\N	RC5	RC5-64 (all)	10000.00	RC5-64 contest	68719476736	Blocks	18446744073709551616	1	268435456	268435456	Keys	Blocks	RC5	http://www.rsa.com	RSA Data Systems, Inc.	http://stats.distributed.net/rc5-64/logo.gif
V	24	2000-07-13	\N	\N	OGRP2	OGR-24	0.00	Optimal Golumb Ruler with 24 marks	0	stubs	0	1	1000000000	1	nodes	Gnodes	OGR	 	 	http://stats.distributed.net/ogr-24/logo.gif
\.



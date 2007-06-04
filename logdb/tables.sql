-- $Id: tables.sql,v 1.11 2007/06/04 05:39:42 decibel Exp $

CREATE TABLE log_type (
	log_type_id	smallint NOT NULL PRIMARY KEY
	, log_type	text NOT NULL UNIQUE
) WITHOUT OIDs;
COPY log_type (log_type_id, log_type) FROM stdin DELIMITER ',';
3,RC5
6,CSC
8,R72
24,OGR
25,OGRP2
\.


-- Note that we should probable just create this as a temp table in the import script
CREATE TABLE import (
	return_time	timestamp NOT NULL
	, ip_address	inet NOT NULL
	, os_type	integer NOT NULL
	, cpu_type	integer NOT NULL
	, version	integer NOT NULL
	, core		integer
	, rc5_cmc_count	integer
	, project_id	smallint NOT NULL
	, rc5_iter	smallint
	, ogr_status	smallint
	, rc5_cmc_ok	smallint
	, ogr_nodecount	bigint
	, workunit_tid	text NOT NULL
	, email		varchar(64) NOT NULL
	, rc5_cmc_last	text
) WITHOUT OIDs;

CREATE TABLE log_other (
	return_time	timestamp NOT NULL
	, ip_address	inet NOT NULL
	, email_id	int NOT NULL
	, platform_id	integer NOT NULL
	, core		integer
	, rc5_cmc_count	integer
	, project_id	smallint NOT NULL
	, rc5_iter	smallint
	, ogr_status	smallint
	, rc5_cmc_ok	smallint
	, ogr_nodecount	bigint
	, workunit_tid	text NOT NULL
	, rc5_cmc_last	text
) WITHOUT OIDs;

CREATE TABLE email (
	email_id	serial 		PRIMARY KEY
	, email		varchar(64) 	NOT NULL UNIQUE
) WITHOUT OIDs;

CREATE TABLE platform (
	platform_id	serial 	PRIMARY KEY
	, os		int	NOT NULL
	, cpu		int	NOT NULL
	, version	int	NOT NULL
	, UNIQUE (os, cpu, version)
) WITHOUT OIDs;

/*
	R72
*/

CREATE TABLE log_8 (
	return_time		timestamp NOT NULL
	, email_id		integer NOT NULL REFERENCES email
	, platform_id		integer NOT NULL REFERENCES platform
	, ip_address		inet
	, rc5_cmc_count		integer
	, rc5_cmc_ok		smallint
	, rc5_iter		smallint NOT NULL
	, core			smallint NOT NULL
	, log_type_id		smallint NOT NULL
	, workunit_tid		varchar(20) NOT NULL
	, rc5_cmc_last		varchar(20)
	, bad_ip_address	text
) WITHOUT OIDs;
CREATE INDEX log_8__email_id ON log_8( email_id );

CREATE TABLE log_rc5_other WITHOUT OIDs AS
	SELECT 0::smallint AS project_id, * FROM log_8
;
ALTER TABLE log_rc5_other ADD CONSTRAINT log_rc5_other__email_ri FOREIGN KEY ( email_id ) REFERENCES email;
ALTER TABLE log_rc5_other ADD CONSTRAINT log_rc5_other__platform_ri FOREIGN KEY ( platform_id ) REFERENCES platform;
CREATE INDEX log_rc5_other__email_id ON log_rc5_other( project_id, email_id );

/*
	OGR
*/

CREATE TABLE log_24 (
	return_time		timestamp NOT NULL
	, email_id		integer NOT NULL CONSTRAINT log_24__email_ri REFERENCES email
	, platform_id		integer NOT NULL CONSTRAINT log_24__platform_ri REFERENCES platform
	, ip_address		inet
	, ogr_status		smallint
	, log_type_id		smallint NOT NULL
	, ogr_nodecount		bigint NOT NULL
	, workunit_tid		text NOT NULL
	, bad_ip_address	text
) WITHOUT OIDs;
CREATE INDEX log_24__email_id ON log_24( email_id );

CREATE TABLE log_25 WITHOUT OIDs AS
	SELECT * FROM log_24
;
ALTER TABLE log_25 ADD CONSTRAINT log_25__email_ri FOREIGN KEY ( email_id ) REFERENCES email;
ALTER TABLE log_25 ADD CONSTRAINT log_25__platform_ri FOREIGN KEY ( platform_id ) REFERENCES platform;
CREATE INDEX log_25__email_id ON log_25( email_id );

CREATE TABLE log_ogr_other WITHOUT OIDs AS
	SELECT 0::smallint AS project_id, * FROM log_25
;
ALTER TABLE log_ogr_other ADD CONSTRAINT log_ogr_other__email_ri FOREIGN KEY ( email_id ) REFERENCES email;
ALTER TABLE log_ogr_other ADD CONSTRAINT log_ogr_other__platform_ri FOREIGN KEY ( platform_id ) REFERENCES platform;
CREATE INDEX log_ogr_other__email_id ON log_ogr_other( project_id, email_id );

/*
	LOG_HISTORY
	This stores when a log was done.  This also serves
	as a rudimentary locking mechanism.  Do not confuse this
	with real locking.
*/

CREATE TABLE log_history (
	logday			date NOT NULL
	, loghour		smallint NOT NULL
	, log_type_id		smallint NOT NULL
	, lines			integer
	, badlines		integer
	, starttime		timestamp
	, endtime		timestamp
	, PRIMARY KEY ( logday, loghour, log_type_id )
) WITHOUT OIDS;

-- vi: noexpandtab ts=8 sw=8

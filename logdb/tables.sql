-- $Id: tables.sql,v 1.7 2005/05/09 23:03:29 decibel Exp $

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

CREATE TABLE import_r72 (
	return_time	timestamp NOT NULL
	, ip_address	inet NOT NULL
	, os_type	integer NOT NULL
	, cpu_type	integer NOT NULL
	, version	integer NOT NULL
	, core		integer NOT NULL
	, cmc_count	integer
	, project_id	smallint NOT NULL
	, iter		smallint NOT NULL
	, cmc_ok	smallint
	, workunit_tid	varchar(20) NOT NULL
	, email		varchar(64) NOT NULL
	, cmc_last	varchar(20)
) WITHOUT OIDs;

CREATE TABLE log_8 (
	return_time		timestamp NOT NULL
	, ip_address		inet NOT NULL
	, email_id		integer NOT NULL REFERENCES email
	, platform_id		integer NOT NULL REFERENCES platform
	, cmc_count		integer
	, cmc_ok		smallint
	, iter			smallint NOT NULL
	, core			smallint NOT NULL
	, workunit_tid		varchar(20) NOT NULL
	, cmc_last		varchar(20)
) WITHOUT OIDs;
CREATE INDEX log_8__email_id ON log_8( email_id );

CREATE TABLE log_r72_other WITHOUT OIDs AS
	SELECT 0::smallint AS project_id, * FROM log_8
;
ALTER TABLE log_r72_other ADD CONSTRAINT log_r72_other__email_ri FOREIGN KEY email_id REFERENCES email;
ALTER TABLE log_r72_other ADD CONSTRAINT log_r72_other__platform_ri FOREIGN KEY platform_id REFERENCES platform;
CREATE INDEX log_r72_other__email_id ON log_r72_other( project_id, email_id );

/*
	OGR
*/

CREATE TABLE import_ogr (
	return_time	timestamp NOT NULL
	, ip_address	inet NOT NULL
	, os_type	integer NOT NULL
	, cpu_type	integer NOT NULL
	, version	integer NOT NULL
	, status	smallint
	, project_id	smallint NOT NULL
	, nodecount	bigint NOT NULL
	, email		varchar(64) NOT NULL
	-- TODO create a custom ogr node datatype
	, stub_marks	varchar(22) NOT NULL
) WITHOUT OIDs;

CREATE TABLE log_24 (
	return_time		timestamp NOT NULL
	, ip_address		inet NOT NULL
	, email_id		integer NOT NULL CONSTRAINT log_24__email_ri REFERENCES email
	, platform_id		integer NOT NULL CONSTRAINT log_24__platform_ri REFERENCES platform
	, status		smallint
	, nodecount		bigint NOT NULL
	, workunit_tid		text NOT NULL
) WITHOUT OIDs;
CREATE INDEX log_24__email_id ON log_24( email_id );

CREATE TABLE log_25 WITHOUT OIDs AS
	SELECT * FROM log_24
;
ALTER TABLE log_25 ADD CONSTRAINT log_25__email_ri FOREIGN KEY email_id REFERENCES email;
ALTER TABLE log_25 ADD CONSTRAINT log_25__platform_ri FOREIGN KEY platform_id REFERENCES platform;
CREATE INDEX log_25__email_id ON log_25( email_id );

CREATE TABLE log_ogr_other WITHOUT OIDs AS
	SELECT 0::smallint AS project_id, * FROM log_25
;
ALTER TABLE log_ogr_other ADD CONSTRAINT log_ogr_other__email_ri FOREIGN KEY email_id REFERENCES email;
ALTER TABLE log_ogr_other ADD CONSTRAINT log_ogr_other__platform_ri FOREIGN KEY platform_id REFERENCES platform;
CREATE INDEX log_ogr_other__email_id ON log_ogr_other( project_id, email_id );

-- vi: noexpandtab ts=8 sw=8

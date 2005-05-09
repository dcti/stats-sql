-- $Id: tables.sql,v 1.4 2005/05/09 22:43:04 decibel Exp $

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
	, email		varchar(64) NOT NULL
	, os_type	integer NOT NULL
	, cpu_type	integer NOT NULL
	, version	integer NOT NULL
	, project_id	smallint NOT NULL
	, workunit_tid	varchar(20) NOT NULL
	, iter		smallint NOT NULL
	, core		integer NOT NULL
	, cmc_last	varchar(20)
	, cmc_count	integer
	, cmc_ok	smallint
) WITHOUT OIDs;

CREATE TABLE log_8 (
	return_time		timestamp NOT NULL
	, ip_address		inet NOT NULL
	, email_id		integer NOT NULL REFERENCES email
	, platform_id		integer NOT NULL REFERENCES platform
	, iter			smallint NOT NULL
	, cmc_count		integer
	, cmc_ok		smallint
	, core			smallint NOT NULL
	, workunit_tid		varchar(20) NOT NULL
	, cmc_last		varchar(20)
) WITHOUT OIDs;
CREATE TABLE log_r72_other WITHOUT OIDs AS
	SELECT 0::smallint AS project_id, * FROM log_8
;

/*
	OGR
*/

CREATE TABLE import_ogr (
	return_time	timestamp NOT NULL
	, ip_address	inet NOT NULL
	, email		varchar(64) NOT NULL
	, os_type	integer NOT NULL
	, cpu_type	integer NOT NULL
	, version	integer NOT NULL
	, project_id	smallint NOT NULL
	-- TODO create a custom ogr node datatype
	, stub_marks	varchar(22) NOT NULL
	, nodecount	bigint NOT NULL
	, status	smallint
) WITHOUT OIDs;

CREATE TABLE log_24 (
	return_time		timestamp NOT NULL
	, ip_address		inet NOT NULL
	, email_id		integer NOT NULL REFERENCES email
	, platform_id		integer NOT NULL REFERENCES platform
	, workunit_tid		text NOT NULL
	, nodecount		bigint NOT NULL
	, status		smallint
) WITHOUT OIDs;

CREATE TABLE log_25 (
	return_time		timestamp NOT NULL
	, ip_address		inet NOT NULL
	, email_id		integer NOT NULL REFERENCES email
	, platform_id		integer NOT NULL REFERENCES platform
	, workunit_tid		text NOT NULL
	, nodecount		bigint NOT NULL
	, status		smallint
) WITHOUT OIDs;

CREATE TABLE log_ogr_other WITHOUT OIDs AS
	SELECT 0::smallint AS project_id, * FROM log_25
;

-- vi: noexpandtab ts=8 sw=8

-- $Id: tables.sql,v 1.21 2009/03/06 16:53:04 nerf Exp $

BEGIN;
CREATE TABLE log_type (
	log_type_id	smallint NOT NULL PRIMARY KEY
	, log_type	text NOT NULL UNIQUE
) WITHOUT OIDs;
COPY log_type (log_type_id, log_type) FROM stdin DELIMITER ',';
1,RC5
2,CSC
3,R72
4,OGR
5,OGRP2
6,OGRNG
\.


-- Note that we should probable just create this as a temp table in the import script
CREATE TABLE import (
	return_time		timestamp NOT NULL
	, os_type		integer NOT NULL
	, cpu_type		integer NOT NULL
	, version		integer NOT NULL
	, core			integer
	, rc5_cmc_count		integer
	, project_id		smallint NOT NULL
	, real_project_id	smallint
	, rc5_iter		smallint
	, ogr_status		smallint
	, rc5_cmc_ok		smallint
	, ogr_nodecount		bigint
	, workunit_tid		text NOT NULL
	, email			varchar(64) NOT NULL
	, rc5_cmc_last		text
	, ip_address		text
	, bad_ip_address	text
) WITHOUT OIDs;

CREATE TABLE email (
	email_id	serial 		PRIMARY KEY
	, email		varchar(64) 	NOT NULL UNIQUE
) WITHOUT OIDs;
CREATE TRIGGER not_allowed BEFORE UPDATE OR DELETE ON email FOR STATEMENT EXECUTE PROCEDURE tg_not_allowed();

CREATE TABLE platform (
	platform_id	serial 	PRIMARY KEY
	, os		int	NOT NULL
	, cpu		int	NOT NULL
	, version	int	NOT NULL
	, UNIQUE (os, cpu, version)
) WITHOUT OIDs;
CREATE TRIGGER not_allowed BEFORE UPDATE OR DELETE ON platform FOR STATEMENT EXECUTE PROCEDURE tg_not_allowed();

CREATE TABLE log_other (
	return_time		timestamp NOT NULL
	, email_id		integer NOT NULL REFERENCES email
	, platform_id		integer NOT NULL REFERENCES platform
	, ip_address		inet
	, core			integer
	, rc5_cmc_count		integer
	, project_id		smallint NOT NULL
	, real_project_id	smallint
	, log_type_id		smallint NOT NULL REFERENCES log_type
	, rc5_iter		smallint
	, ogr_status		smallint
	, rc5_cmc_ok		smallint
	, ogr_nodecount		bigint
	, workunit_tid		text NOT NULL
	, rc5_cmc_last		text
	, bad_ip_address	text
) WITHOUT OIDs;
CREATE TRIGGER not_allowed BEFORE UPDATE OR DELETE ON log_other FOR STATEMENT EXECUTE PROCEDURE tg_not_allowed();

/*
	R72
*/

CREATE TABLE log_5 (
	return_time		timestamp NOT NULL
	, email_id		integer NOT NULL REFERENCES email
	, platform_id		integer NOT NULL REFERENCES platform
	, ip_address		inet
	, rc5_iter		smallint NOT NULL
	, core			smallint NOT NULL
	, log_type_id		smallint NOT NULL REFERENCES log_type
	, workunit_tid		varchar(20) NOT NULL
	, bad_ip_address	text
) WITHOUT OIDs;
CREATE INDEX log_5__email_id ON log_5( email_id );
CREATE TRIGGER not_allowed BEFORE UPDATE OR DELETE ON log_5 FOR STATEMENT EXECUTE PROCEDURE tg_not_allowed();

CREATE TABLE log_8 (
	return_time		timestamp NOT NULL
	, email_id		integer NOT NULL REFERENCES email
	, platform_id		integer NOT NULL REFERENCES platform
	, ip_address		inet
	, rc5_cmc_count		integer
	, rc5_cmc_ok		smallint
	, rc5_iter		smallint NOT NULL
	, core			smallint NOT NULL
	, log_type_id		smallint NOT NULL REFERENCES log_type
	, workunit_tid		varchar(20) NOT NULL
	, rc5_cmc_last		varchar(20)
	, bad_ip_address	text
) WITHOUT OIDs;
CREATE INDEX log_8__email_id ON log_8( email_id );
CREATE TRIGGER not_allowed BEFORE UPDATE OR DELETE ON log_8 FOR STATEMENT EXECUTE PROCEDURE tg_not_allowed();

CREATE TABLE log_rc5_other WITHOUT OIDs AS
	SELECT 0::smallint AS project_id, * FROM log_8
;
ALTER TABLE log_rc5_other ADD FOREIGN KEY ( email_id ) REFERENCES email;
ALTER TABLE log_rc5_other ADD FOREIGN KEY ( platform_id ) REFERENCES platform;
ALTER TABLE log_rc5_other ADD FOREIGN KEY ( log_type_id ) REFERENCES log_type;
CREATE INDEX log_rc5_other__email_id ON log_rc5_other( project_id, email_id );
CREATE TRIGGER not_allowed BEFORE UPDATE OR DELETE ON log_rc5_other FOR STATEMENT EXECUTE PROCEDURE tg_not_allowed();

/*
	OGR
*/

CREATE TABLE log_24 (
	return_time		timestamp NOT NULL
	, email_id		integer NOT NULL REFERENCES email
	, platform_id		integer NOT NULL REFERENCES platform
	, ip_address		inet
	, ogr_status		smallint
	, log_type_id		smallint NOT NULL REFERENCES log_type
	, ogr_nodecount		bigint NOT NULL
	, workunit_tid		text NOT NULL
	, real_project_id	smallint
	, bad_ip_address	text
) WITHOUT OIDs;
CREATE INDEX log_24__email_id ON log_24( email_id );
CREATE TRIGGER not_allowed BEFORE UPDATE OR DELETE ON log_24 FOR STATEMENT EXECUTE PROCEDURE tg_not_allowed();

CREATE TABLE log_25 WITHOUT OIDs AS
	SELECT * FROM log_24
;
ALTER TABLE log_25 ADD FOREIGN KEY ( email_id ) REFERENCES email;
ALTER TABLE log_25 ADD FOREIGN KEY ( platform_id ) REFERENCES platform;
ALTER TABLE log_25 ADD FOREIGN KEY ( log_type_id ) REFERENCES log_type;
CREATE INDEX log_25__email_id ON log_25( email_id );
CREATE TRIGGER not_allowed BEFORE UPDATE OR DELETE ON log_25 FOR STATEMENT EXECUTE PROCEDURE tg_not_allowed();

CREATE TABLE log_26 WITHOUT OIDs AS
	SELECT * FROM log_24
;
ALTER TABLE log_26 ADD FOREIGN KEY ( email_id ) REFERENCES email;
ALTER TABLE log_26 ADD FOREIGN KEY ( platform_id ) REFERENCES platform;
ALTER TABLE log_26 ADD FOREIGN KEY ( log_type_id ) REFERENCES log_type;
CREATE INDEX log_26__email_id ON log_26( email_id );
CREATE TRIGGER not_allowed BEFORE UPDATE OR DELETE ON log_26 FOR STATEMENT EXECUTE PROCEDURE tg_not_allowed();

CREATE TABLE log_27 WITHOUT OIDs AS
	SELECT * FROM log_24
;
ALTER TABLE log_27 ADD FOREIGN KEY ( email_id ) REFERENCES email;
ALTER TABLE log_27 ADD FOREIGN KEY ( platform_id ) REFERENCES platform;
ALTER TABLE log_27 ADD FOREIGN KEY ( log_type_id ) REFERENCES log_type;
CREATE INDEX log_27__email_id ON log_27( email_id );
CREATE TRIGGER not_allowed BEFORE UPDATE OR DELETE ON log_27 FOR STATEMENT EXECUTE PROCEDURE tg_not_allowed();

CREATE TABLE log_ogr_other WITHOUT OIDs AS
	SELECT 0::smallint AS project_id, * FROM log_25
;
ALTER TABLE log_ogr_other ADD FOREIGN KEY ( email_id ) REFERENCES email;
ALTER TABLE log_ogr_other ADD FOREIGN KEY ( platform_id ) REFERENCES platform;
ALTER TABLE log_ogr_other ADD FOREIGN KEY ( log_type_id ) REFERENCES log_type;
CREATE INDEX log_ogr_other__email_id ON log_ogr_other( project_id, email_id );
CREATE TRIGGER not_allowed BEFORE UPDATE OR DELETE ON log_ogr_other FOR STATEMENT EXECUTE PROCEDURE tg_not_allowed();

/*
	LOG_HISTORY
	This stores when a log was done.  This also serves
	as a rudimentary locking mechanism.  Do not confuse this
	with real locking.
*/

CREATE TABLE log_history (
	log_day			date NOT NULL
	, log_hour		smallint NOT NULL
	, log_type_id		smallint NOT NULL REFERENCES log_type
	, lines_raw		int NOT NULL
	, lines_logmod		int NOT NULL
	, start_time		timestamp NOT NULL
	, end_time		timestamp NOT NULL
	, PRIMARY KEY ( log_day, log_hour, log_type_id )
) WITHOUT OIDS;
COMMIT;
COMMENT ON COLUMN log_history.log_hour IS $$Hour of the logfile. -1 if this is a daily-only log$$;
COMMENT ON COLUMN log_history.lines_raw IS $$Number of lines in the raw logfile$$;
COMMENT ON COLUMN log_history.lines_logmod IS $$Number of lines output by logmod$$;
CREATE TRIGGER not_allowed BEFORE UPDATE OR DELETE ON log_history FOR STATEMENT EXECUTE PROCEDURE tg_not_allowed();

-- vi: noexpandtab ts=8 sw=8

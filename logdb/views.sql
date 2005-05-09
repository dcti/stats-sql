-- $Id: views.sql,v 1.6 2005/05/09 22:43:04 decibel Exp $

/*
	R72
*/

CREATE OR REPLACE VIEW log_r72 AS
    SELECT * FROM log_r72_other
    UNION ALL
    SELECT 8::smallint AS project_id, * FROM log_8
;

CREATE OR REPLACE RULE log_r72_insert_nothing AS ON INSERT TO log_r72
    DO INSTEAD NOTHING
;

CREATE OR REPLACE RULE log_r72_insert_other AS ON INSERT TO log_r72
    WHERE NEW.project_id NOT IN ( 8 )
    DO INSTEAD
        INSERT INTO log_r72_other( project_id, return_time, ip_address, email_id, platform_id
                    , iter, cmc_count, cmc_ok, core, workunit_tid, cmc_last )
            VALUES( NEW.project_id, NEW.return_time, NEW.ip_address, NEW.email_id, NEW.platform_id
                    , NEW.iter, NEW.cmc_count, NEW.cmc_ok, NEW.core, NEW.workunit_tid, NEW.cmc_last )
;

CREATE OR REPLACE RULE log_r72_insert_8 AS ON INSERT TO log_r72
    WHERE NEW.project_id = 8
    DO INSTEAD
        INSERT INTO log_8( return_time, ip_address, email_id, platform_id
                    , iter, cmc_count, cmc_ok, core, workunit_tid, cmc_last )
            VALUES( NEW.return_time, NEW.ip_address, NEW.email_id, NEW.platform_id
                    , NEW.iter, NEW.cmc_count, NEW.cmc_ok, NEW.core, NEW.workunit_tid, NEW.cmc_last )
;

/*
	OGR
*/

CREATE OR REPLACE VIEW log_ogr AS
    SELECT * FROM log_ogr_other
    UNION ALL
    SELECT 24::smallint AS project_id, * FROM log_24
    UNION ALL
    SELECT 25::smallint AS project_id, * FROM log_25
;

CREATE OR REPLACE RULE log_ogr_insert_nothing AS ON INSERT TO log_ogr
    DO INSTEAD NOTHING
;

CREATE OR REPLACE RULE log_ogr_insert_other AS ON INSERT TO log_ogr
    WHERE NEW.project_id NOT IN ( 24, 25 )
    DO INSTEAD
        INSERT INTO log_ogr_other( project_id, return_time, ip_address, email_id, platform_id
                    , workunit_tid, nodecount, status )
            VALUES( NEW.project_id, NEW.return_time, NEW.ip_address, NEW.email_id, NEW.platform_id
                    , NEW.workunit_tid, NEW.nodecount, NEW.status )
;

CREATE OR REPLACE RULE log_ogr_insert_24 AS ON INSERT TO log_ogr
    WHERE NEW.project_id = 24
    DO INSTEAD
        INSERT INTO log_24( return_time, ip_address, email_id, platform_id
                    , workunit_tid, nodecount, status )
            VALUES( NEW.return_time, NEW.ip_address, NEW.email_id, NEW.platform_id
                    , NEW.workunit_tid, NEW.nodecount, NEW.status )
;

CREATE OR REPLACE RULE log_ogr_insert_25 AS ON INSERT TO log_ogr
    WHERE NEW.project_id = 25
    DO INSTEAD
        INSERT INTO log_25( return_time, ip_address, email_id, platform_id
                    , workunit_tid, nodecount, status )
            VALUES( NEW.return_time, NEW.ip_address, NEW.email_id, NEW.platform_id
                    , NEW.workunit_tid, NEW.nodecount, NEW.status )
;

-- vi: expandtab ts=4 sw=4

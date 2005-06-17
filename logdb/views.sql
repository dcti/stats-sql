-- $Id: views.sql,v 1.7 2005/06/17 22:54:02 decibel Exp $

/*
	R72
*/

CREATE OR REPLACE VIEW log_rc5 AS
    SELECT * FROM log_rc5_other
    UNION ALL
    SELECT 8::smallint AS project_id, * FROM log_8
;

CREATE OR REPLACE RULE log_rc5_insert_nothing AS ON INSERT TO log_rc5
    DO INSTEAD NOTHING
;

CREATE OR REPLACE RULE log_rc5_insert_other AS ON INSERT TO log_rc5
    WHERE NEW.project_id NOT IN ( 8 )
    DO INSTEAD
        INSERT INTO log_rc5_other( project_id, return_time, ip_address, email_id, platform_id
                    , rc5_iter, rc5_cmc_count, rc5_cmc_ok, core, workunit_tid, rc5_cmc_last )
            VALUES( NEW.project_id, NEW.return_time, NEW.ip_address, NEW.email_id, NEW.platform_id
                    , NEW.rc5_iter, NEW.rc5_cmc_count, NEW.rc5_cmc_ok, NEW.core, NEW.workunit_tid, NEW.rc5_cmc_last )
;

CREATE OR REPLACE RULE log_rc5_insert_8 AS ON INSERT TO log_rc5
    WHERE NEW.project_id = 8
    DO INSTEAD
        INSERT INTO log_8( return_time, ip_address, email_id, platform_id
                    , rc5_iter, rc5_cmc_count, rc5_cmc_ok, core, workunit_tid, rc5_cmc_last )
            VALUES( NEW.return_time, NEW.ip_address, NEW.email_id, NEW.platform_id
                    , NEW.rc5_iter, NEW.rc5_cmc_count, NEW.rc5_cmc_ok, NEW.core, NEW.workunit_tid, NEW.rc5_cmc_last )
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
                    , workunit_tid, ogr_nodecount, ogr_status )
            VALUES( NEW.project_id, NEW.return_time, NEW.ip_address, NEW.email_id, NEW.platform_id
                    , NEW.workunit_tid, NEW.ogr_nodecount, NEW.ogr_status )
;

CREATE OR REPLACE RULE log_ogr_insert_24 AS ON INSERT TO log_ogr
    WHERE NEW.project_id = 24
    DO INSTEAD
        INSERT INTO log_24( return_time, ip_address, email_id, platform_id
                    , workunit_tid, ogr_nodecount, ogr_status )
            VALUES( NEW.return_time, NEW.ip_address, NEW.email_id, NEW.platform_id
                    , NEW.workunit_tid, NEW.ogr_nodecount, NEW.ogr_status )
;

CREATE OR REPLACE RULE log_ogr_insert_25 AS ON INSERT TO log_ogr
    WHERE NEW.project_id = 25
    DO INSTEAD
        INSERT INTO log_25( return_time, ip_address, email_id, platform_id
                    , workunit_tid, ogr_nodecount, ogr_status )
            VALUES( NEW.return_time, NEW.ip_address, NEW.email_id, NEW.platform_id
                    , NEW.workunit_tid, NEW.ogr_nodecount, NEW.ogr_status )
;

/*
    GENERIC
*/

CREATE OR REPLACE VIEW log AS
    SELECT project_id, return_time, ip_address, email_id, platform_id, workunit_tid
            , core, rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last
            , ogr_status, ogr_nodecount
        FROM log_other
    UNION ALL
    SELECT project_id, return_time, ip_address, email_id, platform_id, workunit_tid
            , core, rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last
            , NULL AS ogr_status, NULL AS ogr_nodecount
        FROM log_rc5
    UNION ALL
    SELECT project_id, return_time, ip_address, email_id, platform_id, workunit_tid
            , NULL AS core, NULL AS rc5_cmc_count, NULL AS rc5_cmc_ok, NULL AS rc5_iter, NULL AS rc5_cmc_last
            , ogr_status, ogr_nodecount
        FROM log_ogr
;

CREATE OR REPLACE RULE log_insert_nothing AS ON INSERT TO log
    DO INSTEAD NOTHING
;

CREATE OR REPLACE RULE log_insert_other AS ON INSERT TO log
    WHERE NEW.project_id NOT IN ( 8, 24, 25 )
    DO INSTEAD
        INSERT INTO log_other( project_id, return_time, ip_address, email_id, platform_id, workunit_tid
                    , core, rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last
                    , ogr_status, ogr_nodecount )
            VALUES( NEW.project_id, NEW.return_time, NEW.ip_address, NEW.email_id, NEW.platform_id, NEW.workunit_tid
                    , NEW.core, NEW.rc5_cmc_count, NEW.rc5_cmc_ok, NEW.rc5_iter, NEW.rc5_cmc_last
                    , NEW.ogr_status, NEW.ogr_nodecount )
;

CREATE OR REPLACE RULE log_insert_rc5 AS ON INSERT TO log
    WHERE NEW.project_id NOT IN ( 5, 8 )
    DO INSTEAD
        INSERT INTO log_rc5( project_id, return_time, ip_address, email_id, platform_id, workunit_tid
                    , core, rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last )
            VALUES( NEW.project_id, NEW.return_time, NEW.ip_address, NEW.email_id, NEW.platform_id, NEW.workunit_tid
                    , NEW.core, NEW.rc5_cmc_count, NEW.rc5_cmc_ok, NEW.rc5_iter, NEW.rc5_cmc_last )
;

CREATE OR REPLACE RULE log_insert_ogr AS ON INSERT TO log
    WHERE NEW.project_id NOT IN ( 24, 25 )
    DO INSTEAD
        INSERT INTO log_ogr( project_id, return_time, ip_address, email_id, platform_id, workunit_tid
                    , ogr_status, ogr_nodecount )
            VALUES( NEW.project_id, NEW.return_time, NEW.ip_address, NEW.email_id, NEW.platform_id, NEW.workunit_tid
                    , NEW.ogr_status, NEW.ogr_nodecount )
;

-- vi: expandtab ts=4 sw=4

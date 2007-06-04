-- $Id: views.sql,v 1.8 2007/06/04 05:39:43 decibel Exp $

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
        INSERT INTO log_rc5_other( project_id, return_time, email_id, platform_id, ip_address
                    , rc5_iter, rc5_cmc_count, rc5_cmc_ok, core, log_type_id
                    , workunit_tid, rc5_cmc_last, bad_ip_address )
            VALUES( NEW.project_id, NEW.return_time, NEW.email_id, NEW.platform_id, NEW.ip_address
                    , NEW.rc5_iter, NEW.rc5_cmc_count, NEW.rc5_cmc_ok, NEW.core, NEW.log_type_id
                    , NEW.workunit_tid, NEW.rc5_cmc_last, NEW.bad_ip_address  )
;

CREATE OR REPLACE RULE log_rc5_insert_8 AS ON INSERT TO log_rc5
    WHERE NEW.project_id = 8
    DO INSTEAD
        INSERT INTO log_8( return_time, email_id, platform_id, ip_address
                    , rc5_iter, rc5_cmc_count, rc5_cmc_ok, core, log_type_id
                    , workunit_tid, rc5_cmc_last, bad_ip_address )
            VALUES( NEW.return_time, NEW.email_id, NEW.platform_id, NEW.ip_address
                    , NEW.rc5_iter, NEW.rc5_cmc_count, NEW.rc5_cmc_ok, NEW.core, NEW.log_type_id
                    , NEW.workunit_tid, NEW.rc5_cmc_last, NEW.bad_ip_address  )
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
        INSERT INTO log_ogr_other( project_id, return_time, email_id, platform_id, ip_address
                    , workunit_tid, ogr_nodecount, ogr_status, log_type_id, bad_ip_address )
            VALUES( NEW.project_id, NEW.return_time, NEW.email_id, NEW.platform_id, NEW.ip_address
                    , NEW.workunit_tid, NEW.ogr_nodecount, NEW.ogr_status, NEW.log_type_id, NEW.bad_ip_address )
;

CREATE OR REPLACE RULE log_ogr_insert_24 AS ON INSERT TO log_ogr
    WHERE NEW.project_id = 24
    DO INSTEAD
        INSERT INTO log_24( return_time, email_id, platform_id, ip_address
                    , workunit_tid, ogr_nodecount, ogr_status, log_type_id, bad_ip_address )
            VALUES( NEW.return_time, NEW.email_id, NEW.platform_id, NEW.ip_address
                    , NEW.workunit_tid, NEW.ogr_nodecount, NEW.ogr_status, NEW.log_type_id, NEW.bad_ip_address )
;

CREATE OR REPLACE RULE log_ogr_insert_25 AS ON INSERT TO log_ogr
    WHERE NEW.project_id = 25
    DO INSTEAD
        INSERT INTO log_25( return_time, email_id, platform_id, ip_address
                    , workunit_tid, ogr_nodecount, ogr_status, log_type_id, bad_ip_address )
            VALUES( NEW.return_time, NEW.email_id, NEW.platform_id, NEW.ip_address
                    , NEW.workunit_tid, NEW.ogr_nodecount, NEW.ogr_status, NEW.log_type_id, NEW.bad_ip_address )
;

/*
    GENERIC
*/

CREATE OR REPLACE VIEW log AS
    SELECT project_id, return_time, ip_address, email_id, platform_id, workunit_tid
            , core, rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last
            , ogr_status, ogr_nodecount, log_type_id, bad_ip_address
        FROM log_other
    UNION ALL
    SELECT project_id, return_time, ip_address, email_id, platform_id, workunit_tid
            , core, rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last
            , NULL AS ogr_status, NULL AS ogr_nodecount, log_type_id, bad_ip_address
        FROM log_rc5
    UNION ALL
    SELECT project_id, return_time, ip_address, email_id, platform_id, workunit_tid
            , NULL AS core, NULL AS rc5_cmc_count, NULL AS rc5_cmc_ok, NULL AS rc5_iter, NULL AS rc5_cmc_last
            , ogr_status, ogr_nodecount, log_type_id, bad_ip_address
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
                    , ogr_status, ogr_nodecount, log_type_id, bad_ip_address )
            VALUES( NEW.project_id, NEW.return_time, NEW.ip_address, NEW.email_id, NEW.platform_id, NEW.workunit_tid
                    , NEW.core, NEW.rc5_cmc_count, NEW.rc5_cmc_ok, NEW.rc5_iter, NEW.rc5_cmc_last
                    , NEW.ogr_status, NEW.ogr_nodecount, NEW.log_type_id, NEW.bad_ip_address )
;

CREATE OR REPLACE RULE log_insert_rc5 AS ON INSERT TO log
    WHERE NEW.project_id NOT IN ( 5, 8 )
    DO INSTEAD
        INSERT INTO log_rc5( project_id, return_time, ip_address, email_id, platform_id, workunit_tid
                    , core, rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last, log_type_id, bad_ip_address )
            VALUES( NEW.project_id, NEW.return_time, NEW.ip_address, NEW.email_id, NEW.platform_id, NEW.workunit_tid
                    , NEW.core, NEW.rc5_cmc_count, NEW.rc5_cmc_ok, NEW.rc5_iter, NEW.rc5_cmc_last, NEW.log_type_id, NEW.bad_ip_address )
;

CREATE OR REPLACE RULE log_insert_ogr AS ON INSERT TO log
    WHERE NEW.project_id NOT IN ( 24, 25 )
    DO INSTEAD
        INSERT INTO log_ogr( project_id, return_time, ip_address, email_id, platform_id, workunit_tid
                    , ogr_status, ogr_nodecount, log_type_id, bad_ip_address )
            VALUES( NEW.project_id, NEW.return_time, NEW.ip_address, NEW.email_id, NEW.platform_id, NEW.workunit_tid
                    , NEW.ogr_status, NEW.ogr_nodecount, NEW.log_type_id, NEW.bad_ip_address )
;

-- vi: expandtab ts=4 sw=4

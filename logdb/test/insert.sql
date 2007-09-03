-- $Id: insert.sql,v 1.1 2007/09/03 01:58:06 decibel Exp $

\echo Setup initial values we'll need
INSERT INTO email( email_id, email ) VALUES( 0, 'moo@distributed.net' );
INSERT INTO platform( platform_id, os, cpu, version )
    VALUES( 0, 10, 20, 999999 );


/*
 * Do all the normal cases first. Right now we're not doing any kind of
 * checking for valid email, workunit, or CMC formatting, so the test is
 * intentionally lazy about that stuff.
 */

\echo *** Normal rows ***
\echo RC5-64
INSERT INTO log( project_id, return_time, ip_address, email_id
                    , platform_id, workunit_tid, core
                    , rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last
                    , ogr_status, ogr_nodecount, log_type_id, bad_ip_address )
    VALUES( 5, '2000-12-18 1:23:45', '100.100.100.100', 0
            , 0, 'rc5-64 workunit', 5
            , NULL, NULL, NULL, NULL
            , NULL, NULL, 3, NULL )
;

\echo TODO CSC

\echo RC5-72
INSERT INTO log( project_id, return_time, ip_address, email_id
                    , platform_id, workunit_tid, core
                    , rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last
                    , ogr_status, ogr_nodecount, log_type_id, bad_ip_address )
    VALUES( 8, '2000-12-18 1:23:45', '100.100.100.100', 0
            , 0, 'rc5-72 workunit', 5
            , 2, 1, 15, 'cmc last'
            , NULL, NULL, 8, NULL )
;

\echo TODO OGR-24

\echo TODO OGR-25

\echo OGR-25 P2
INSERT INTO log( project_id, return_time, ip_address, email_id
                    , platform_id, workunit_tid, core
                    , rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last
                    , ogr_status, ogr_nodecount, log_type_id, bad_ip_address )
    VALUES( 25, '2000-12-18 1:23:45', '100.100.100.100', 0
            , 0, 'OGR-25 P2 workunit', 5
            , NULL, NULL, NULL, NULL
            , 9, 12345678901234, 25, NULL )
;

\echo
\echo *** Bad IP address ***
\echo RC5-64
INSERT INTO log( project_id, return_time, ip_address, email_id
                    , platform_id, workunit_tid, core
                    , rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last
                    , ogr_status, ogr_nodecount, log_type_id, bad_ip_address )
    VALUES( 5, '2000-12-18 1:23:45', NULL, 0
            , 0, 'rc5-64 workunit', 5
            , NULL, NULL, NULL, NULL
            , NULL, NULL, 3, 'bad IP' )
;

\echo TODO CSC

\echo RC5-72
INSERT INTO log( project_id, return_time, ip_address, email_id
                    , platform_id, workunit_tid, core
                    , rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last
                    , ogr_status, ogr_nodecount, log_type_id, bad_ip_address )
    VALUES( 8, '2000-12-18 1:23:45', NULL, 0
            , 0, 'rc5-72 workunit', 5
            , 2, 1, 15, 'cmc last'
            , NULL, NULL, 8, 'bad IP' )
;

\echo TODO OGR-24

\echo TODO OGR-25

\echo OGR-25 P2
INSERT INTO log( project_id, return_time, ip_address, email_id
                    , platform_id, workunit_tid, core
                    , rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last
                    , ogr_status, ogr_nodecount, log_type_id, bad_ip_address )
    VALUES( 25, '2000-12-18 1:23:45', NULL, 0
            , 0, 'OGR-25 P2 workunit', 5
            , NULL, NULL, NULL, NULL
            , 9, 12345678901234, 25, 'bad IP' )
;

\echo
\echo *** Bad platform ***
\echo RC5-64
INSERT INTO log( project_id, return_time, ip_address, email_id
                    , platform_id, workunit_tid, core
                    , rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last
                    , ogr_status, ogr_nodecount, log_type_id, bad_ip_address )
    VALUES( 5, '2000-12-18 1:23:45', '100.100.100.100', 0
            , -10, 'rc5-64 workunit', 5
            , NULL, NULL, NULL, NULL
            , NULL, NULL, 3, NULL )
;

\echo TODO CSC

\echo RC5-72
INSERT INTO log( project_id, return_time, ip_address, email_id
                    , platform_id, workunit_tid, core
                    , rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last
                    , ogr_status, ogr_nodecount, log_type_id, bad_ip_address )
    VALUES( 8, '2000-12-18 1:23:45', '100.100.100.100', 0
            , -10, 'rc5-72 workunit', 5
            , 2, 1, 15, 'cmc last'
            , NULL, NULL, 8, NULL )
;

\echo TODO OGR-24

\echo TODO OGR-25

\echo OGR-25 P2
INSERT INTO log( project_id, return_time, ip_address, email_id
                    , platform_id, workunit_tid, core
                    , rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last
                    , ogr_status, ogr_nodecount, log_type_id, bad_ip_address )
    VALUES( 25, '2000-12-18 1:23:45', '100.100.100.100', 0
            , -10, 'OGR-25 P2 workunit', 5
            , NULL, NULL, NULL, NULL
            , 9, 12345678901234, 25, NULL )
;

\echo
\echo *** Bad email ***
\echo RC5-64
INSERT INTO log( project_id, return_time, ip_address, email_id
                    , platform_id, workunit_tid, core
                    , rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last
                    , ogr_status, ogr_nodecount, log_type_id, bad_ip_address )
    VALUES( 5, '2000-12-18 1:23:45', NULL, -10
            , 0, 'rc5-64 workunit', 5
            , NULL, NULL, NULL, NULL
            , NULL, NULL, 3, 'bad IP' )
;

\echo TODO CSC

\echo RC5-72
INSERT INTO log( project_id, return_time, ip_address, email_id
                    , platform_id, workunit_tid, core
                    , rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last
                    , ogr_status, ogr_nodecount, log_type_id, bad_ip_address )
    VALUES( 8, '2000-12-18 1:23:45', NULL, -10
            , 0, 'rc5-72 workunit', 5
            , 2, 1, 15, 'cmc last'
            , NULL, NULL, 8, 'bad IP' )
;

\echo TODO OGR-24

\echo TODO OGR-25

\echo OGR-25 P2
INSERT INTO log( project_id, return_time, ip_address, email_id
                    , platform_id, workunit_tid, core
                    , rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last
                    , ogr_status, ogr_nodecount, log_type_id, bad_ip_address )
    VALUES( 25, '2000-12-18 1:23:45', NULL, -10
            , 0, 'OGR-25 P2 workunit', 5
            , NULL, NULL, NULL, NULL
            , 9, 12345678901234, 25, 'bad IP' )
;

-- vi: noexpandtab ts=4 sw=4

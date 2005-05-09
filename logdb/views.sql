-- $Id: views.sql,v 1.1 2005/05/09 05:56:06 decibel Exp $

CREATE OR REPLACE VIEW log_ogr AS
    SELECT * FROM log_24
    UNION ALL
    SELECT * FROM log_25
;

CREATE OR REPLACE log_ogr_insert_24 AS ON INSERT TO log_ogr
    WHERE NEW.project_id = 24
    DO INSTEAD
        INSERT INTO log_24( return_time, ip_address, email_id, platform_id, ogr_stub, nodecount, status )
            VALUES( NEW.return_time, NEW.ip_address, NEW.email_id, NEW.platform_id, NEW.ogr_stub, NEW.nodecount, NEW.status )
;
CREATE OR REPLACE log_ogr_insert_25 AS ON INSERT TO log_ogr
    WHERE NEW.project_id = 25
    DO INSTEAD
        INSERT INTO log_25( return_time, ip_address, email_id, platform_id, ogr_stub, nodecount, status )
            VALUES( NEW.return_time, NEW.ip_address, NEW.email_id, NEW.platform_id, NEW.ogr_stub, NEW.nodecount, NEW.status )
;

-- vi: expandtab ts=4 sw=4

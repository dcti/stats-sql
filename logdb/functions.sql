-- $Id: functions.sql,v 1.1 2007/10/26 20:35:10 nerf Exp $

CREATE OR REPLACE FUNCTION integrate ()
BEGIN
  INSERT INTO email(email)
    SELECT email
    FROM (
      SELECT DISTINCT email FROM import
    ) i
    WHERE NOT EXISTS (
      SELECT 1
      FROM email e
      WHERE i.email = e.email
    );

  INSERT INTO platform(os, cpu, version)
    SELECT os_type, cpu_type, version
    FROM (
      SELECT DISTINCT os_type, cpu_type, version FROM import
    ) i
    WHERE NOT EXISTS (
      SELECT 1
      FROM platform p
      WHERE i.os_type = p.os
        AND i.cpu_type = p.cpu
        AND i.version = p.version
    );
END

CREATE OR REPLACE FUNCTION process_log (log_day,log_hour,log_type)
BEGIN
  INSERT INTO log_history(log_day,log_hour,log_type_id,start_time)
    VALUES (log_day,log_hour,log_type,now());

  INSERT INTO log (project_id, return_time, ip_address, email_id,
      platform_id, workunit_tid, core, rc5_cmc_count, rc5_cmc_ok,
      rc5_iter, rc5_cmc_last, ogr_status, ogr_nodecount, log_type_id,
      bad_ip_address, real_project_id)
    SELECT  project_id,return_time, ip_address::inet, e.email_id, p.platform_id,
      workunit_tid, core, rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last,
      ogr_status, ogr_nodecount, log_type_id, bad_ip_address, real_project_id
      FROM import i, email e, platform p
      WHERE i.email = e.email
        AND i.os_type = p.os
        AND i.cpu_type = p.cpu
        AND i.version = p.version
  ;

  UPDATE log_history SET end_time = now()
    WHERE log_history.log_day = log_day
      AND log_history.log_hour = log_hour
      AND log_history.log_type_id = log_type
  ;
END


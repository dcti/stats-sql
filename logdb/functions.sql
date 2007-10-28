-- $Id: functions.sql,v 1.5 2007/10/28 22:38:38 decibel Exp $

CREATE OR REPLACE FUNCTION process_parent_tables () RETURNS void LANGUAGE plpgsql AS $process_parent_tables$
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
END;
$process_parent_tables$;

CREATE OR REPLACE FUNCTION process_log (
  p_log_day log_history.log_day%TYPE
  , p_log_hour log_history.log_hour%TYPE
  , p_log_type log_type.log_type%TYPE
  , p_lines_raw log_history.lines_raw%TYPE
  , p_lines_logmod log_history.lines_logmod%TYPE
) RETURNS void LANGUAGE plpgsql AS $process_log$
DECLARE
  v_count bigint;
BEGIN
  INSERT INTO log_history( log_day, log_hour, log_type_id, start_time, lines_raw, lines_logmod )
    SELECT p_log_day, p_log_hour, log_type_id, now(), p_lines_raw, p_lines_logmod
      FROM log_type
      WHERE log_type = p_log_type
  ;

  SELECT INTO v_count
      count(*)
    FROM import
  ;
  IF v_count != p_lines_logmod THEN
    RAISE EXCEPTION $$Number of lines in import table (%) does not match number of lines from logmod (%)$$, v_count, p_lines_logmod;
  END IF;

  ANALYZE import;

  PERFORM process_parent_tables();

  INSERT INTO log (
        project_id, return_time, ip_address, email_id,
        platform_id, workunit_tid, core, rc5_cmc_count, rc5_cmc_ok,
        rc5_iter, rc5_cmc_last, ogr_status, ogr_nodecount, log_type_id,
        bad_ip_address, real_project_id
      )
    SELECT project_id,return_time, ip_address::inet, e.email_id, p.platform_id,
        workunit_tid, core, rc5_cmc_count, rc5_cmc_ok, rc5_iter, rc5_cmc_last,
        ogr_status, ogr_nodecount, log_type_id, bad_ip_address, real_project_id
      FROM log_type l, import i
        JOIN email e ON ( i.email = e.email )
        JOIN platform p ON ( i.os_type = p.os AND i.cpu_type = p.cpu AND i.version = p.version )
      WHERE l.log_type = p_log_type
  ;

  UPDATE log_history SET end_time = timeofday()::timestamptz
    WHERE log_history.log_day = log_day
      AND log_history.log_hour = log_hour
      AND log_history.log_type_id = log_type
  ;

  TRUNCATE import;
END;
$process_log$;

-- vi: expandtab sw=2 ts=2

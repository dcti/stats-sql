-- $Id: cleanup.sql,v 1.11 2003/06/13 01:43:09 decibel Exp $
\set ON_ERROR_STOP 1

select now() as start into temp start_time;
\t
select '$RCSfile: cleanup.sql,v $ start time: ' || start from start_time;
\t

alter table projects drop column deprecated_fields ;
alter table projects drop column work_unit_name;
alter table projects drop column dist_unit_scale;
alter table projects drop column work_unit_scale;
-- Do update to force reclaming space from dropped columns
UPDATE projects SET project_id = project_id;

alter table project_statsrun rename column last_hourly_date to last_date;
alter table project_statsrun drop column last_master_date;
alter table project_statsrun drop column last_email_date;
alter table project_statsrun drop column last_team_date;
alter table project_statsrun drop column last_summary_date;
-- Do update to force reclaming space from dropped columns
UPDATE project_statsrun SET project_id = project_id;

vacuum full analyze verbose;

\t
select '$RCSfile: cleanup.sql,v $ stop time: ' || now() || ', duration: ' || age(now(),start) from start_time;

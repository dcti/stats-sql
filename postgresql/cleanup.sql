-- $Id: cleanup.sql,v 1.10 2003/04/20 22:05:21 decibel Exp $
\set ON_ERROR_STOP 1

select now() as start into temp start_time;
\t
select '$RCSfile: cleanup.sql,v $ start time: ' || start from start_time;
\t

alter table projects drop column deprecated_fields ;
alter table projects drop column work_unit_name;
alter table projects drop column dist_unit_scale;
alter table projects drop column work_unit_scale;

alter table project_statsrun rename column last_hourly_date to last_date;
alter table project_statsrun drop column last_master_date;
alter table project_statsrun drop column last_email_date;
alter table project_statsrun drop column last_team_date;
alter table project_statsrun drop column last_summary_date;

vacuum full analyze verbose;

\t
select '$RCSfile: cleanup.sql,v $ stop time: ' || now() || ', duration: ' || age(now(),start) from start_time;

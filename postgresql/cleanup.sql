-- $Id: cleanup.sql,v 1.9 2003/04/14 21:47:41 decibel Exp $
\set ON_ERROR_STOP 1

select now() as start into temp start_time;
\t
select '$RCSfile: cleanup.sql,v $ start time: ' || start from start_time;
\t

alter table projects drop column deprecated_fields ;
alter table projects drop column work_unit_name;
alter table projects drop column dist_unit_scale;
alter table projects drop column work_unit_scale;

vacuum full analyze verbose;

\t
select '$RCSfile: cleanup.sql,v $ stop time: ' || now() || ', duration: ' || age(now(),start) from start_time;

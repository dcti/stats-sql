-- $Id: cleanup.sql,v 1.4 2003/04/14 14:04:37 decibel Exp $
\set ON_ERROR_STOP 1

alter table stats_participant drop column team;
alter table projects drop column deprecated_fields ;
alter table projects drop column work_unit_name;
alter table projects drop column dist_unit_scale;
alter table projects drop column work_unit_scale;

vacuum full analyze verbose;

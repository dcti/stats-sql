-- $Id: cleanup.sql,v 1.3 2003/04/09 16:23:48 decibel Exp $
alter table stats_participant drop column team;
alter table projects drop column deprecated_fields ;
alter table projects drop column work_unit_name;
alter table projects drop column dist_unit_scale;
alter table projects drop column work_unit_scale;

vacuum full analyze verbose;

-- $Id: cleanup.sql,v 1.2 2003/04/09 15:55:41 decibel Exp $
alter table stats_participant drop column team;

vacuum full analyze verbose;

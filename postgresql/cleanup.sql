-- $Id: cleanup.sql,v 1.1 2003/04/08 15:48:32 decibel Exp $
alter table stats_participant drop column team;

vacuum full analyze verbose stats;

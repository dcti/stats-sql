#!/bin/sh
#
# $Id: build.sh,v 1.4 2005/04/28 05:58:45 decibel Exp $

load () {
    psql -f $1 stats
}

createdb -T template0 stats
load accounts.sql
load schema_dump.sql
load notes.sql
load project_status.dat.sql
load projects.dat.sql
load stats_country.dat.sql
load stats_cpu.dat.sql
load stats_dem_heard.dat.sql
load stats_dem_motivation.dat.sql
load stats_nonprofit.dat.sql
load stats_os.dat.sql

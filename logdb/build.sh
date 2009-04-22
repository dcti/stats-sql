#!/bin/sh
#
# $Id: build.sh,v 1.4 2009/04/22 06:05:10 nerf Exp $

# uncomment these if you need to first create the database
# createdb -E UTF8 logs
# createlang plpgsql logs

load () {
    psql -f $1 logs
}

load trigger_functions.sql
load tables.sql
load views.sql
load functions.sql

# vi: expandtab sw=4 ts=4

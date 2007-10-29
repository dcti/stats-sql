#!/bin/sh
#
# $Id: build.sh,v 1.3 2007/10/29 00:38:48 decibel Exp $

load () {
    psql -f $1 logs
}

load trigger_functions.sql
load tables.sql
load views.sql
load functions.sql

# vi: expandtab sw=4 ts=4

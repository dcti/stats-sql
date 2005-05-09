#!/bin/sh
#
# $Id: build.sh,v 1.1 2005/05/09 20:59:50 decibel Exp $

load () {
    psql -f $1 logs
}

load tables.sql
load views.sql

# vi: expandtab sw=4 ts=4

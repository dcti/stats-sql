#!/bin/sh
#
# $Id: build.sh,v 1.2 2007/10/27 06:53:21 nerf Exp $

load () {
    psql -f $1 logs
}

load tables.sql
load views.sql
load functions.sql

# vi: expandtab sw=4 ts=4

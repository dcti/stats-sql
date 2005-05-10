#!/bin/sh
#
# $Id: build.sh,v 1.5 2005/05/10 23:22:24 decibel Exp $

load () {
    psql -f $1 stats
}

createdb -T template0 stats
load accounts.sql
load schema_dump.sql
load notes.sql
load load_data.sql

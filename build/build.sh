#!/bin/sh
#
# $Id: build.sh,v 1.1 2003/11/19 21:53:59 decibel Exp $

createdb -T template0 stats
psql -f accounts.sql stats
psql -f schema_dump.sql stats

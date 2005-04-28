#!/bin/sh
#
# $Id: build.sh,v 1.3 2005/04/28 05:33:04 decibel Exp $

createdb -T template0 stats
psql -f accounts.sql stats
psql -f schema_dump.sql stats
psql -f notes.sql stats
psql -f projects.dat.sql stats

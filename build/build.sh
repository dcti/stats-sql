#!/bin/sh
#
# $Id: build.sh,v 1.2 2005/01/08 02:52:24 decibel Exp $

createdb -T template0 stats
psql -f accounts.sql stats
psql -f schema_dump.sql stats
psql -f notes.sql stats

#!/bin/sh
#
# $Id: team_renumber.sh,v 1.1 2003/11/19 20:29:00 decibel Exp $

while psql -f team_renumber.psql stats; do
    sleep 2
done

#!/bin/sh
# $Id: stats_participant.sh,v 1.1 2003/04/14 19:26:44 decibel Exp $

./move.pl stats STATS_Participant || exit 1
psql stats < stats_participant.sql 2>&1 | grep -v NOTICE || exit 1

#!/bin/sh
# $Id: rebuild_team.sh,v 1.3 2003/09/09 20:43:55 decibel Exp $

if [ x$1 = x ]; then
    echo Must specify project ID!
    exit 1;
fi
if [ x$2 = x ]; then
    database=stats
else
    database=$2
fi

psql -d $database -v ProjectID=$1 -f team_members.sql  && psql -d $database -v ProjectID=$1 -f team_rank.sql  && psql -d $database -v ProjectID=$1 -f ../../../stats-proc/daily/tm_rank.sql  && psql -d $database -v ProjectID=$1 -f team_rank_2.sql  && psql -d $database -v ProjectID=$1 -f ../../../stats-proc/daily/tm_rank.sql 

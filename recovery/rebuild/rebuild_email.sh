#!/bin/sh
# $Id: rebuild_email.sh,v 1.3.2.2 2003/04/27 22:06:56 decibel Exp $

if [ x$1 = x ]; then
    echo Must specify project ID!
    exit 1;
fi
if [ x$2 = x ]; then
    database=stats
else
    database=$2
fi

psql -d $database -v ProjectID=$1 -f email_rank.sql && psql -d $database -v ProjectID=$1 -f ../../../stats-proc/daily/em_rank.sql && psql -d $database -v ProjectID=$1 -f email_rank_2.sql  && psql -d $database -v ProjectID=$1 -f ../../../stats-proc/daily/em_rank.sql 

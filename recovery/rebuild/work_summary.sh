#!/bin/sh
# $Id: work_summary.sh,v 1.2 2003/09/09 20:43:55 decibel Exp $

if [ x$1 = x ]; then
    echo Must specify project ID!
    exit 1;
fi
if [ x$2 = x ]; then
    database=stats
else
    database=$2
fi

psql -d $database -v ProjectID=$1 -f work_summary.sql

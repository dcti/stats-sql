#!/bin/sh
# $Id: work_summary.sh,v 1.1.2.2 2003/04/27 22:10:49 decibel Exp $

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

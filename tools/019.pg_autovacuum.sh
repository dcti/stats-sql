#!/bin/sh
#
# $Id: 019.pg_autovacuum.sh,v 1.4 2004/10/13 01:55:08 decibel Exp $

RUNSCRIPT=~pgsql/pg_autovacuum.sh
case $1 in
start)
    if [ -x ${RUNSCRIPT} ]; then
        [ x${LOGFILE} != x ] && CONFIG="${CONFIG} -L ${LOGFILE}"
        su -l pgsql -c "${RUNSCRIPT} &" > /var/run/pg_autovacuum.pid && echo -n ' pg_autovacuum'
    else
        echo $0: $RUNSCRIPT is not executable
    fi
    ;;
stop)
    kill `cat /var/run/pg_autovacuum.pid`
    rm /var/run/pg_autovacuum.pid
    ;;

*)
    echo "usage: `basename $0` {start|stop}" >&2
    exit 64
    ;;
esac

#!/bin/sh
#
# $Id: 019.pg_autovacuum.sh,v 1.3 2004/04/23 22:50:19 decibel Exp $

CONFIG=""
LOGFILE=/var/log/pg_autovacuum.log

PREFIX=/usr/local
PGBIN=${PREFIX}/bin

case $1 in
start)
    [ -x ${PGBIN}/pg_autovacuum ] && {
	[ x${LOGFILE} != x ] && CONFIG="${CONFIG} -L ${LOGFILE}"
	echo -n ' pg_autovacuum'
	su -l pgsql -c "exec ${PREFIX}/bin/pg_autovacuum -D ${CONFIG}"
    }
    ;;

*)
    echo "usage: `basename $0` {start}" >&2
    exit 64
    ;;
esac

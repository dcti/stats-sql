#!/bin/sh
#
# $Id: 019.pg_autovacuum.sh,v 1.2 2004/04/22 18:40:48 decibel Exp $

CONFIG="-d 2"
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

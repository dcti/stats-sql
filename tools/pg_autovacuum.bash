#!/bin/bash
#
# $Id: pg_autovacuum.bash,v 1.2 2004/10/13 23:36:26 decibel Exp $

CONFIG=""
LOGFILE=/var/log/pg_autovacuum

PREFIX=/usr
PGBIN=${PREFIX}/bin

log () {
    [ x${LOGFILE} != x ] && echo $@ >> ${LOGFILE}
}

sendsig () {
    if [ x${running_pid} != x ]; then
        if [ x$2 != x ]; then
            log "Signal $1 received, sending signal $2 to PID ${running_pid}"
            kill -${2} ${running_pid} 2> /dev/null
        else
            log "Signal $1 received, sending to PID ${running_pid}"
            kill -${1} ${running_pid} 2> /dev/null
        fi
    else
        log "signal $1 received but \$running_pid isn't set; ignoring"
    fi
}

sigdie () {
    if [ x${running_pid} != x ]; then
        if [ x$2 != x ]; then
            log "Signal $1 received, sending signal $2 to PID ${running_pid} and exiting"
            kill -${2} ${running_pid} 2> /dev/null
        else
            log "Signal $1 received, sending to PID ${running_pid} and exiting"
            kill -${1} ${running_pid} 2> /dev/null
        fi
    else
        log "signal $1 received but \$running_pid isn't set; exiting"
    fi
    exit
}

trap 'sendsig 1' 1
trap 'sigdie 2 15' 2
trap 'sigdie 9' 9
trap 'sigdie 15' 15

echo $$

log "pg_autovacuum.sh started, PID=$$"

[ x${LOGFILE} != x ] && CONFIG="${CONFIG} -L ${LOGFILE}"
COMMAND=${PREFIX}/bin/pg_autovacuum

#set -o trapsasync

while true; do
    ${PREFIX}/bin/pg_autovacuum ${CONFIG} &
    running_pid=$!
    wait

    # Sleep a bit before we start checking incase there was an error starting up
    sleep 10

    #while ( ps -p $running_pid 2> /dev/null | grep -q "${COMMAND}" ); do
    #    sleep 300
    #done

    log "pg_autovacuum died; restarting"
done

# vi: expandtab sw=4 ts=4

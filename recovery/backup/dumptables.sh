#!/bin/sh
#
# $Id: dumptables.sh,v 1.1 2003/09/16 20:41:53 decibel Exp $

# Defaults
database=stats
user=`whoami`
compression=n

while [ x"$1" != x ]; do
    case $1 in
        -b) compression=b
            shift
            continue;;
        -bb) compression=bb
            shift
            continue;;
        -c) compression=$2
            shift
            shift
            continue;;
        -t) table_list=$2
            shift
            shift
            continue;;
        -d) dump_options=$2
            shift
            shift
            continue;;
        -o) cd $2 || exit
            shift
            shift
            continue;;
         *) tables=$@
            break;;
    esac
done

for table in $tables
do
    echo Dumping $table
    case $compression in
        n) pg_dump -d $database --use-set-session-authorization -U $user $dump_options -f $table.tbl -t $table
            continue;;
        bb) pg_dump -d $database --use-set-session-authorization -U $user $dump_options -f $table.tbl -t $table
            echo Beginning compression of $table.tbl in the background
            (bzip2 $table.tbl && echo Compression of $table.tbl done) &
            continue;;
        b) pg_dump -d $database --use-set-session-authorization -U $user $dump_options -t $table | bzip2 > $table.tbl.bz2
            continue;;
    esac
done

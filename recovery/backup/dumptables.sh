#!/bin/sh
#
# $Id: dumptables.sh,v 1.2 2004/02/03 22:51:50 decibel Exp $

# Defaults
database=stats
user=`whoami`
compression=n
table_list=''
output=.

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
        -t) table_list="$table_list $2"
            shift
            shift
            continue;;
        -d) dump_options=$2
            shift
            shift
            continue;;
        -o) output=$2
            shift
            shift
            continue;;
         *) tables=$@
            break;;
    esac
done

if [ ! -d $output ]; then
    echo $output is not a directory
    exit 1
fi

dump ( ) {
    echo Dumping $table
    case $compression in
        n) pg_dump -d $database --use-set-session-authorization -U $user $dump_options -f $output/$table.tbl -t $table
            continue;;
        bb) pg_dump -d $database --use-set-session-authorization -U $user $dump_options -f $output/$table.tbl -t $table
            echo Beginning compression of $output/$table.tbl in the background
            (bzip2 $output/$table.tbl && echo Compression of $output/$table.tbl done) &
            continue;;
        b) pg_dump -d $database --use-set-session-authorization -U $user $dump_options -t $table | bzip2 > $output/$table.tbl.bz2
            continue;;
    esac
}

if [ $table_list ]; then
    for table in `cat $table_list | grep -v '#'`
    do
        dump $table
    done
fi

for table in $tables
do
    dump $table
done

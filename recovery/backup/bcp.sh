#!/bin/sh
#
# $Id: bcp.sh,v 1.1 2000/11/05 13:44:06 decibel Exp $

table_list='tables.txt'
savedir='./'
SYBASE='/usr/local/sybase'
sqsh_flags='-w 256'

#Source the config file
if [ -r bcp.conf ]; then
	. bcp.conf
else
	echo "Unable to read config file!" 2>&1
	die
fi

for table in `cat $table_list`
do
	echo "Starting backup of $table"
	echo "getting table info..."
	sqsh -S $server -U $user -P $password ${sqsh_flags} -i tabledef.sql $table > ${savedir}${table}.def
	echo "getting table def..."
	sqsh -S $server -U $user -P $password ${sqsh_flags} -i info.sql $table > ${savedir}${table}.info
	echo "bcp'ing..."
	${SYBASE}/bin/bcp ${table} out ${savedir}${table}.bcp -n -S${server} -U${user} -P${password} | grep -v \
		'1000 rows successfully bulk-copied'
	echo "done."
	echo
	echo
done

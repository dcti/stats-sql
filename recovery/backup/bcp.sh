#!/bin/sh
#
# $Id: bcp.sh,v 1.6 2000/11/09 13:18:18 decibel Exp $

table_list='tables.txt'
savedir='./'
sqsh_flags='-w 256'
nobcp=false

#Source the config file
if [ -r bcp.conf ]; then
	. bcp.conf
else
	echo "Unable to read config file!" 2>&1
	exit
fi

while [ x"$1" != x ]; do
	case $1 in
	    -n)	nobcp=true
		shift
		continue;;
	    -t) table_list=$2
		shift
		shift
		continue;;
	     *) echo "Unknown command $1"
		exit
	esac
done

for table in `cat $table_list | grep -v '#'`
do
	echo "Starting backup of $table"
	echo "getting table info..."
	sqsh -S $server -U $user -P $password ${sqsh_flags} -i tabledef.sql $table > ${savedir}${table}.def
	echo "getting table def..."
	sqsh -S $server -U $user -P $password ${sqsh_flags} -i info.sql $table > ${savedir}${table}.info
	if [ $nobcp = false ]; then
		if [ -e ${savedir}${table}.bcp ]; then
			echo "${savedir}${table}.bcp already exists, no BCP will be performed!"
		else
			echo "bcp'ing..."
			${SYBASE}/bin/bcp ${table} out ${savedir}${table}.bcp -n -S${server} -U${user} -P${password} | grep -v \
				'1000 rows successfully bulk-copied'
		fi
	fi
	echo "done."
	echo
	echo
done

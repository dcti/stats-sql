#!/bin/sh
#
# $Id: bcp.sh,v 1.9 2002/12/15 22:24:38 decibel Exp $

table_list='tables.txt'
savedir='./'
sqsh_flags='-w 256'
nobcp=false
bzip=false

#Source the config file
if [ -r bcp.conf ]; then
	. bcp.conf
else
	echo "Unable to read config file!" 2>&1
	exit
fi

while [ x"$1" != x ]; do
	case $1 in
	    -b) bzip=true
	        shift
		continue;;
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
	sqsh -S $server -U $user -P $password ${sqsh_flags} -i indexes.sql $table > ${savedir}${table}.idx
	echo "getting table def..."
	sqsh -S $server -U $user -P $password ${sqsh_flags} -i info.sql $table > ${savedir}${table}.info
	if [ $nobcp = false ]; then
		if [ -e ${savedir}${table}.bcp* ]; then
			echo "${savedir}${table}.bcp* already exists, no BCP will be performed!"
		else
			echo "bcp'ing..."
			${SYBASE}/bin/bcp ${table} out ${savedir}${table}.bcp -c -t, -S${server} -U${user} -P${password} | grep -v \
				'1000 rows successfully bulk-copied'
		fi
	fi
	if [ -r ${savedir}${table}.bcp -a $bzip = true ]; then
	    echo "spawning bzip..."
	    bzip2 ${savedir}${table}.bcp &
	fi
	echo "done."
	echo
	echo
done

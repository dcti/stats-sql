#!/bin/sh

# Definitions
version='$Id: psearch.sh,v 1.6 2001/12/26 01:24:06 decibel Exp $'
sqlpath=psearch/
deletescript=${sqlpath}delete.sql
insertscript=${sqlpath}template
main_proc=${sqlpath}main.def

# Variable initialization
deleteonly=false
sqshargs=""

# Functions
setupsql () {
	echo
	echo Adding $2
	sqsh $sqshargs -i ${deletescript} $1 $2
	if [ "$deleteonly" != "true" ]; then
		sqsh $sqshargs -i ${insertscript}.def $1 $2
	fi
	return
}

setupsql2 () {
	echo
	echo Adding $2
	sqsh $sqshargs -i ${deletescript} $1 $2
	if [ "$deleteonly" != "true" ]; then
		sqsh $sqshargs -i ${insertscript}2.def $1 $2
	fi
	return
}

# Parse the cowmand-line arguments
while [ x"$1" != x ]; do
	case $1 in
	    -d) deleteonly=true
		shift
		continue;;
	    -o) shift
		sqshargs="$1"
		shift
		continue;;
	    -v) echo $version
		exit 0 ;;
	    -?) cat << EOF
Usage: psearch.sh [options] database 
Options:
  -d		Delete only (only drop the procedures)
  -o "options"	Options for sqsh
  -v		Print version information, then exit
EOF
		exit 0 ;;
	     *) database="$1"
		shift
		tables="$@"
		break ;;
	esac
done

if [ $database = "" ]; then
	echo "You must specify a database to use!"
	exit 1
fi

sqsh $sqshargs -i $main_proc $database

setupsql $database csc
setupsql $database rc5_64
setupsql2 $database new

[ -f ${sqlpath}depends ] && echo && cat ${sqlpath}depends

#!/bin/sh

# Definitions
version='$Id: psearch.sh,v 1.4 2000/03/17 04:55:58 decibel Exp $'
sqlpath=psearch/
deletescript=${sqlpath}delete.sql
insertscript=${sqlpath}template.def
main_proc=${sqlpath}main.def

# Variable initialization
deleteonly=false
sqshargs=""

# Functions
function setupsql () {
	echo
	echo Adding for $1
	sqsh $sqshargs -i ${deletescript} $1
	if [ "$deleteonly" != "true" ]; then
		sqsh $sqshargs -i $insertscript $1
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

sqsh $sqshargs -i $main_proc

setupsql csc
setupsql rc5_64

[ -f ${sqlpath}depends ] && echo && cat ${sqlpath}depends

#!/bin/sh

# Definitions
version='$Id: phistory.sh,v 1.1 2000/10/18 10:59:07 decibel Exp $'
sqlpath=phistory/
deletescript=${sqlpath}delete.sql
insertscript=${sqlpath}template
main_proc=${sqlpath}main.def

# Variable initialization
deleteonly=false
sqshargs=""

# Functions
function setupsql () {
	echo
	echo Adding $2
	sqsh $sqshargs -i ${deletescript} $1 $2 $3
	if [ "$deleteonly" != "true" ]; then
		sqsh $sqshargs -i ${insertscript}.def $1 $2 $3
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
Usage: phistory.sh [options] database 
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

setupsql $database "date_asc" "DATE"
setupsql $database "date_desc" "DATE desc"
setupsql $database "work_units_asc" "WORK_UNITS, DATE"
setupsql $database "work_units_desc" "WORK_UNITS desc, DATE"

[ -f ${sqlpath}depends ] && echo && cat ${sqlpath}depends

#!/bin/sh

# Definitions
version='$Id: set_lastupdate.sh,v 1.1 2002/12/16 19:51:27 decibel Exp $'
sqlpath=set_lastupdate/
deletescript=${sqlpath}delete.sql
insertscript=${sqlpath}template

# Variable initialization
deleteonly=false
sqshargs=""

# Functions
setupsql () {
	sqsh $sqshargs -i ${deletescript} $database $1
	if [ "$deleteonly" != "true" ]; then
		sqsh $sqshargs -i ${insertscript}.def $database $1 $2
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
Usage: lastupdate.sh [options] database 
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

if [ x$database = x ]; then
	echo "You must specify a database to use!"
	exit 1
fi

setupsql e Email_Rank_Last_Update LAST_DATE
setupsql t Team_Rank_Last_Update LAST_DATE
setupsql m Team_Members_Last_Update LAST_DATE
setupsql ec Email_Contrib_Last_Update LAST_DATE
setupsql pc Platform_Contrib_Last_Update LAST_DATE

[ -f ${sqlpath}depends ] && echo && cat ${sqlpath}depends

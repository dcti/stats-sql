#!/bin/sh

# Definitions
version='$Id: lastupdate.sh,v 1.9 2002/10/06 22:53:01 decibel Exp $'
sqlpath=lastupdate/
deletescript=${sqlpath}delete.sql
insertscript=${sqlpath}template
main_proc=${sqlpath}main.def

# Variable initialization
deleteonly=false
sqshargs=""

# Functions
setupsql () {
	sqsh $sqshargs -i ${deletescript} $database $1
	if [ "$deleteonly" != "true" ]; then
		sqsh $sqshargs -i ${insertscript}.def $database $1 $2 $3
	fi
	return
}

setupsql2 () {
	sqsh $sqshargs -i ${deletescript} $database $1
	if [ "$deleteonly" != "true" ]; then
		sqsh $sqshargs -i ${insertscript}2.def $database $1 $2 $3
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

sqsh $sqshargs -i $main_proc $database

setupsql csc_e_o statproc.csc_CACHE_em_rank last
setupsql csc_e_y statproc.csc_CACHE_em_yrank last
setupsql csc_t_o statproc.csc_CACHE_tm_rank last
setupsql csc_t_y statproc.csc_CACHE_tm_yrank last
setupsql csc_m csc_master date
setupsql csc_p csc_platform date

setupsql2 new_e Email_Rank LAST_DATE
setupsql2 new_t Team_Rank LAST_DATE
setupsql2 new_m Email_Contrib_Last_Update LAST_DATE
setupsql2 new_p Platform_Contrib DATE

[ -f ${sqlpath}depends ] && echo && cat ${sqlpath}depends

#!/bin/sh

# Definitions
version='$Id: lastupdate.sh,v 1.3 2000/03/17 04:55:58 decibel Exp $'
sqlpath=lastupdate/
deletescript=${sqlpath}lastupdate_delete.sql
insertscript=${sqlpath}lastupdate_template.def
main_proc=${sqlpath}main_proc.def

# Variable initialization
deleteonly=false
sqshargs=""

# Functions
function setupsql () {
	sqsh $sqshargs -i ${deletescript} $database $1
	if [ "$deleteonly" != "true" ]; then
		sqsh $sqshargs -i $insertscript $database $1 $2 $3
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

if [ $database = "" ]; then
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

setupsql rc5_64_e_o statproc.rc5_64_CACHE_em_rank last
setupsql rc5_64_e_y statproc.rc5_64_CACHE_em_yrank last
setupsql rc5_64_t_o statproc.rc5_64_CACHE_tm_rank last
setupsql rc5_64_t_y statproc.rc5_64_CACHE_tm_yrank last
setupsql rc5_64_m rc5_64_master date
setupsql rc5_64_p rc5_64_platform date

[ -f ${sqlpath}depends ] && echo && cat ${sqlpath}depends

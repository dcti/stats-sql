#!/bin/sh

sqlpath=lastupdate/
deletescript=${sqlpath}lastupdate_delete.sql
insertscript=${sqlpath}lastupdate_template.def
main_proc=${sqlpath}main_proc.def

function setupsql () {
	sqsh $sqshargs -i ${deletescript} $1
	if [ "$deleteonly" != "true" ]; then
		sqsh $sqshargs -i $insertscript $1 $2
	fi
	return
}

if [ "$1" = "-d" ]; then
	deleteonly=true
	shift
else
	deleteonly=false
fi

sqshargs=$@

sqsh $sqshargs -i $main_proc

setupsql csc_e_o csc_CACHE_em_rank
setupsql csc_e_y csc_CACHE_em_yrank
setupsql csc_t_o csc_CACHE_tm_rank
setupsql csc_t_y csc_CACHE_tm_yrank
setupsql rc5_64_e_o rc5_64_CACHE_em_rank
setupsql rc5_64_e_y rc5_64_CACHE_em_yrank
setupsql rc5_64_t_o rc5_64_CACHE_tm_rank
setupsql rc5_64_t_y rc5_64_CACHE_tm_yrank


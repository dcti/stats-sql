#!/bin/sh

sqlpath=lastupdate/
deletescript=${sqlpath}lastupdate_delete.sql
insertscript=${sqlpath}lastupdate_template.def
main_proc=${sqlpath}main_proc.def

function setupsql () {
	sqsh $sqshargs -i ${deletescript} $1
	if [ "$deleteonly" != "true" ]; then
		sqsh $sqshargs -i $insertscript $1 $2 $3
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


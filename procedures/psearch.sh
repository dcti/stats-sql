#!/bin/sh

sqlpath=psearch/
deletescript=${sqlpath}delete.sql
insertscript=${sqlpath}template.def
main_proc=${sqlpath}main.def

function setupsql () {
	echo
	echo Adding for $1
	sqsh $sqshargs -i ${deletescript} $1
	if [ "$deleteonly" != "true" ]; then
		sqsh $sqshargs -i $insertscript $1
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

setupsql csc
setupsql rc5_64

[ -f ${sqlpath}depends ] && echo && cat ${sqlpath}depends

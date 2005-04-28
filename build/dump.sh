#!/bin/sh

do_dump () {
    echo Dumping $1
    pg_dump -at $1 stats > $1.dat.sql
}

do_dump projects
do_dump project_status
do_dump stats_country
do_dump stats_cpu
do_dump stats_dem_heard
do_dump stats_dem_motivation
do_dump stats_nonprofit
do_dump stats_os

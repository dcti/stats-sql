#!/usr/bin/sqsh -i
#
# $Id: er_sub_yesterday.sql,v 1.1 2004/06/23 22:24:55 decibel Exp $
#
# This script will subtract yesterday's numbers from the overall numbers
# in Email_Rank. This is used for doing re-ranking to find yesterday's
# rank, so that all the rank diffs work right.
#
# Arguments:
#	PROJECT_ID

update Email_Rank set WORK_TOTAL = WORK_TOTAL - WORK_TODAY where PROJECT_ID = ${1}
go

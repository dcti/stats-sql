#!/usr/bin/sqsh -i
#
# $Id: er_add_yesterday.sql,v 1.1 2004/06/23 22:24:55 decibel Exp $
#
# This script will add yesterday's numbers to the overall numbers in
# Email_Rank. It will also move the current ranking numbers to rank_previous.
# This is used for doing re-ranking to find yesterday's rank, so that all
# the rank diffs work right.
#
# Arguments:
#	PROJECT_ID

update Email_Rank set WORK_TOTAL = WORK_TOTAL + WORK_TODAY, : where PROJECT_ID = ${1}
go

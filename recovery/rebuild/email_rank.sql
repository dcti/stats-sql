#!/usr/local/bin/sqsh -i
#
# $Id: email_rank.sql,v 1.7 2001/12/29 08:32:08 decibel Exp $
#
# Phase 1 of repopulating Email_Rank for a project. After this script, you should
# re-rank, then run email_rank_2.sql.
# Notes:
#	The script does *not* re-rank.
#	It assumes that the summary table has been created using make_summary.sql
#
# Arguments:
#       PROJECT_ID

set flushmessage on
use stats
go

print "Deleting old data"
delete Email_Rank
where PROJECT_ID = ${1}

print "Inserting new data"
insert into Email_Rank (PROJECT_ID, ID, FIRST_DATE, LAST_DATE, WORK_TODAY, WORK_TOTAL,
		DAY_RANK, DAY_RANK_PREVIOUS, OVERALL_RANK, OVERALL_RANK_PREVIOUS)
	select ${1}, ID, min(FIRST_DATE) as FIRST_DATE, max(LAST_DATE) as LAST_DATE, sum(WORK_YESTERDAY), sum(WORK_TOTAL) - sum(WORK_TODAY),
		0, 0, 0, 0
	from WorkSummary_${1}
	group by id
go

print "All done. Run the email ranking script, then run email_rank_2.sql"
go

#!/usr/local/bin/sqsh -i
#
# $Id: email_rank_2.sql,v 1.2 2001/12/29 08:32:08 decibel Exp $
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

print "Creating summary table"
select ID, sum(WORK_TODAY) as WORK_TODAY into #EmailSum
	from WorkSummary_${1}
	group by id
go

print "Updating Email_Rank"
update Email_Rank set DAY_RANK_PREVIOUS = DAY_RANK,
		OVERALL_RANK_PREVIOUS = OVERALL_RANK,
		WORK_TODAY = s.WORK_TODAY,
		WORK_TOTAL = WORK_TOTAL + s.WORK_TODAY
	from #EmailSum s
	where Email_Rank.PROJECT_ID = ${1}
		and Email_Rank.ID = s.ID
go

print "All done. Run the email ranking script one last time."
go

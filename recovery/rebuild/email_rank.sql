#!/usr/bin/sqsh -i
#
# $Id: email_rank.sql,v 1.4 2000/10/21 22:54:31 decibel Exp $
#
# Repopulates Email_Rank for a project.
# Notes:
#	The script does *not* re-rank.
#	It assumes that the summary table has been created using make_summary.sql
#
# Arguments:
#       PROJECT_ID

set flushmessage on
go

print "Deleting old data"
delete Email_Rank
where PROJECT_ID = ${1}

print "Inserting new data"
declare @max_rank int
select @max_rank = count(*)+1 from STATS_Participant
insert into Email_Rank (PROJECT_ID, ID, FIRST_DATE, LAST_DATE, WORK_TODAY, WORK_TOTAL,
		DAY_RANK, DAY_RANK_PREVIOUS, OVERALL_RANK, OVERALL_RANK_PREVIOUS)
	select ${1}, ID, min(FIRST_DATE) as FIRST_DATE, max(LAST_DATE) as LAST_DATE, sum(WORK_TODAY), sum(WORK_TOTAL),
		@max_rank, @max_rank, @max_rank, @max_rank
	from WorkSummary_${1}
	group by id
go

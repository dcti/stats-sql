#!/usr/bin/sqsh -i
#
# $Id: email_rank.sql,v 1.1 2000/09/26 04:17:14 decibel Exp $
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
	select ${1}, ID, min(FIRST_DATE) as FIRST_DATE, max(LAST_DATE) as LAST_DATE, 0, sum(WORK_TOTAL),
		@max_rank, @max_rank, @max_rank, @max_rank
	from WorkSummary_${1}
	group by id

print "Updating records with today's info"
declare @stats_date smalldatetime
select @stats_date = LAST_STATS_DATE
        from Projects
        where PROJECT_ID = ${1}
update Email_Rank
	set WORK_TODAY = ec.WORK_UNITS
	from Email_Contrib ec
	where ec.ID = Email_Rank.ID
		and Email_Rank.PROJECT_ID = ${1}
		and ec.PROJECT_ID = ${1}
		and ec.DATE = @stats_date
go

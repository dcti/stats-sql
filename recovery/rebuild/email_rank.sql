#!/usr/bin/sqsh -i
#
# $Id: email_rank.sql,v 1.3 2000/10/11 20:01:33 decibel Exp $
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
go

print "Updating records with today's info"
print "  create temp table"
declare @yesterday_date smalldatetime
select @yesterday_date = max(date)
        from Email_Contrib
        where PROJECT_ID = ${1}
select ID, WORK_UNITS
	into #WorkToday
	from Email_Contrib
	where PROJECT_ID = ${1}
		and DATE = @yesterday_date
go

print "  update temp table for retires"
update #WorkToday
	set ID = sp.RETIRE_TO
	from Stats_Participant sp
	where sp.ID = #WorkToday.ID
		and sp.RETIRE_TO > 0
create clustered index ID on #WorkToday(ID) with fillfactor=100
go

update Email_Rank
	set WORK_TODAY = isnull( (select sum(WORK_UNITS) from #WorkToday where ID = Email_Rank.ID), 0)
	where Email_Rank.PROJECT_ID = ${1}
go

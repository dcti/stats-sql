#!/usr/bin/sqsh -i
#
# $Id: team_rank.sql,v 1.4 2000/10/30 13:46:21 decibel Exp $
#
# Repopulates Team_Members for a project.
# Notes:
#	The script does *not* re-rank.
#	It assumes that the summary table has been created using make_summary.sql
#
# Arguments:
#       PROJECT_ID

set flushmessage on
go

print "Deleting old data"
delete Team_Rank
where PROJECT_ID = ${1}

print ""
print ""
print "Inserting new data"
declare @stats_date smalldatetime
select @stats_date = LAST_STATS_DATE
        from Projects
        where PROJECT_ID = ${1}
declare @max_rank int
select @max_rank = count(*)+1 from STATS_Team

insert into Team_Rank (PROJECT_ID, TEAM_ID, FIRST_DATE, LAST_DATE, WORK_TODAY, WORK_TOTAL,
		DAY_RANK, DAY_RANK_PREVIOUS, OVERALL_RANK, OVERALL_RANK_PREVIOUS,
		MEMBERS_TODAY, MEMBERS_OVERALL, MEMBERS_CURRENT)
	select ${1}, tm.TEAM_ID, min(tm.FIRST_DATE) as FIRST_DATE, max(tm.LAST_DATE) as LAST_DATE, sum(tm.WORK_TODAY),
			sum(tm.WORK_TOTAL),
		@max_rank, @max_rank, @max_rank, @max_rank,
		count(*), sum(sign(WORK_TODAY)), 0
	from Team_Members tm
	where tm.PROJECT_ID = ${1}
	group by TEAM_ID

print ""
print ""
print "Counting current team membership"
select TEAM_ID, count(*) as MEMBERS
	into #Team_Members_Current
	from Team_Joins
	where JOIN_DATE <= @stats_date
		and isnull(LAST_DATE, @stats_date) >= @stats_date
	group by TEAM_ID

print ""
print ""
print "Updating MEMBERS_CURRENT"
update Team_Rank
	set MEMBERS_CURRENT = MEMBERS
	from #Team_Members_Current tmc
	where tmc.TEAM_ID = Team_Rank.TEAM_ID
		and PROJECT_ID = ${1}
go

#!/usr/local/bin/sqsh -i
#
# $Id: team_rank.sql,v 1.8 2001/12/29 08:32:08 decibel Exp $
#
# Repopulates Team_Members for a project.
# Notes:
#	The script does *not* re-rank.
#
# Arguments:
#       PROJECT_ID

set flushmessage on
use stats
go

print "Deleting old data"
delete Team_Rank
where PROJECT_ID = ${1}

print ""
print ""
print "Inserting new data"
declare @stats_date smalldatetime
select @stats_date = max(LAST_DATE)
        from Team_Members
        where PROJECT_ID = ${1}
declare @max_rank int
select @max_rank = count(*)+1 from STATS_Team

insert into Team_Rank (PROJECT_ID, TEAM_ID, FIRST_DATE, LAST_DATE, WORK_TODAY, WORK_TOTAL,
		DAY_RANK, DAY_RANK_PREVIOUS, OVERALL_RANK, OVERALL_RANK_PREVIOUS,
		MEMBERS_TODAY, MEMBERS_OVERALL, MEMBERS_CURRENT)
	select ${1}, tm.TEAM_ID, min(tm.FIRST_DATE) as FIRST_DATE, max(tm.LAST_DATE) as LAST_DATE, sum(tm.WORK_TODAY),
			sum(tm.WORK_TOTAL),
		@max_rank, @max_rank, @max_rank, @max_rank,
		sum(sign(WORK_TODAY)), count(*), 0
	from Team_Members tm
	where tm.PROJECT_ID = ${1}
	group by TEAM_ID

print ""
print ""
print "Counting current team membership"
select tm.TEAM_ID, count(*) as MEMBERS
	into #Team_Members_Current
	from Team_Joins tj, Team_Members tm
	where tj.JOIN_DATE <= @stats_date
		and isnull(tj.LAST_DATE, @stats_date) >= @stats_date
		and tj.ID = tm.ID
		and tj.TEAM_ID = tm.TEAM_ID
		and tm.PROJECT_ID = ${1}
	group by tm.TEAM_ID
go

print "Updating MEMBERS_CURRENT"
update Team_Rank
	set MEMBERS_CURRENT = MEMBERS
	from #Team_Members_Current tmc
	where tmc.TEAM_ID = Team_Rank.TEAM_ID
		and PROJECT_ID = ${1}
go

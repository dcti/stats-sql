#!/usr/local/bin/sqsh -i
#
# $Id: team_rank_2.sql,v 1.2 2002/10/23 03:03:26 decibel Exp $
#
# Repopulates Team_Members for a project.
#
# Arguments:
#       PROJECT_ID

set flushmessage on
use stats
go

print "Creating summary table"
go

select PROJECT_ID, TEAM_ID, min(FIRST_DATE) as FIRST_DATE, max(LAST_DATE) as LAST_DATE,
		sum(WORK_TODAY) as WORK_TODAY, sum(sign(WORK_TODAY)) as MEMBERS_TODAY, count(*) as MEMBERS_OVERALL
	into #TeamSummary
	from Team_Members tm
	where PROJECT_ID = ${1}
	group by PROJECT_ID, TEAM_ID
go

print "Counting current team membership"   
go

declare @stats_date smalldatetime   
select @stats_date = max(LAST_DATE)   
	from Team_Members   
	where PROJECT_ID = ${1} 
select tm.PROJECT_ID, tm.TEAM_ID, count(*) as MEMBERS   
	into #Team_Members_Current   
	from Team_Joins tj, Team_Members tm   
	where tj.JOIN_DATE <= @stats_date   
		and isnull(tj.LAST_DATE, @stats_date) >= @stats_date   
		and tj.ID = tm.ID   
		and tj.TEAM_ID = tm.TEAM_ID   
		and tm.PROJECT_ID = ${1}   
	group by tm.PROJECT_ID, tm.TEAM_ID   
go 


print ""
print ""
print "Updating Team_Rank"
update Team_Rank set DAY_RANK_PREVIOUS = DAY_RANK,
		OVERALL_RANK_PREVIOUS = OVERALL_RANK,
		WORK_TODAY = s.WORK_TODAY,
		WORK_TOTAL = WORK_TOTAL + s.WORK_TODAY,
		MEMBERS_TODAY = s.MEMBERS_TODAY,
		MEMBERS_OVERALL = s.MEMBERS_OVERALL,
		MEMBERS_CURRENT = tmc.MEMBERS
	from #TeamSummary s, #Team_Members_Current tmc
	where Team_Rank.PROJECT_ID = s.PROJECT_ID
		and Team_Rank.PROJECT_ID = tmc.PROJECT_ID
		and s.PROJECT_ID = tmc.PROJECT_ID
		and Team_Rank.TEAM_ID = s.TEAM_ID
		and Team_Rank.TEAM_ID = tmc.TEAM_ID
		and s.TEAM_ID = tmc.TEAM_ID
go

#!/usr/local/bin/sqsh -i
#
# $Id: team_rank.sql,v 1.10 2002/10/23 02:52:45 decibel Exp $
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

select TEAM_ID, min(FIRST_DATE) as FIRST_DATE, max(LAST_DATE) as LAST_DATE,
		sum(WORK_YESTERDAY) as WORK_YESTERDAY, sum(WORK_TODAY) as WORK_TODAY, sum(WORK_TOTAL) as WORK_TOTAL
	into #TeamSummary
	from WorkSummary_${1}
	where TEAM_ID >= 1
		and TEAM_ID not in (select TEAM_ID from STATS_Team_Blocked)
	group by TEAM_ID
go

print "Deleting old data"
delete Team_Rank
	where PROJECT_ID = ${1}

print ""
print ""
print "Inserting new data"
insert into Team_Rank (PROJECT_ID, TEAM_ID, FIRST_DATE, LAST_DATE, WORK_TODAY, WORK_TOTAL,
		DAY_RANK, DAY_RANK_PREVIOUS, OVERALL_RANK, OVERALL_RANK_PREVIOUS,
		MEMBERS_TODAY, MEMBERS_OVERALL, MEMBERS_CURRENT)
	select ${1}, TEAM_ID, FIRST_DATE, LAST_DATE, WORK_YESTERDAY, WORK_TOTAL-WORK_TODAY,
		0, 0, 0, 0,
		0, 0, 0
	from #TeamSummary
go

#!/usr/bin/sqsh -i
#
# $Id: team_members.sql,v 1.6 2000/10/30 13:46:21 decibel Exp $
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
delete Team_Members
where PROJECT_ID = ${1}

print "Inserting new data"
insert into Team_Members (PROJECT_ID, ID, TEAM_ID, FIRST_DATE, LAST_DATE, WORK_TODAY, WORK_TOTAL,
		DAY_RANK, DAY_RANK_PREVIOUS, OVERALL_RANK, OVERALL_RANK_PREVIOUS)
	select ${1}, ws.ID, ws.TEAM_ID, min(ws.FIRST_DATE) as FIRST_DATE, max(ws.LAST_DATE) as LAST_DATE,
		sum(ws.WORK_TODAY), sum(ws.WORK_TOTAL), 0, 0, 0, 0
	from WorkSummary_${1} ws, STATS_Team st
	where st.team = ws.TEAM_ID
		and st.LISTMODE < 10
	group by ID, TEAM_ID
go

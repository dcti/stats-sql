#!/usr/bin/sqsh -i
#
# $Id: team_members.sql,v 1.2 2000/09/27 07:13:40 decibel Exp $
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
	select ${1}, ws.ID, ws.TEAM_ID, min(ws.FIRST_DATE) as FIRST_DATE, max(ws.LAST_DATE) as LAST_DATE, 0, sum(ws.WORK_TOTAL),
		0, 0, 0, 0
	from WorkSummary_${1} ws, STATS_Team st
	where st.LISTMODE <= 9
	group by TEAM_ID, ID

print "Updating records with today's info"
declare @stats_date smalldatetime
select @stats_date = LAST_STATS_DATE
        from Projects
        where PROJECT_ID = ${1}
update Team_Members
	set WORK_TODAY = ec.WORK_UNITS
	from Team_Contrib ec
	where ec.ID = Team_Members.ID
		and ec.TEAM_ID = Team_Members.ID
		and Team_Members.PROJECT_ID = ${1}
		and ec.PROJECT_ID = ${1}
		and ec.DATE = @stats_date
go

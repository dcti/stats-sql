#!/usr/bin/sqsh -i
#
# $Id: work_summary.sql,v 1.2 2000/10/08 07:47:35 decibel Exp $
#
# Creates a summary table containing all work for a project
#

set flushmessage on
go

print ""
print "Note:"
print "Make sure that WorkSummary_${1} does not exist!!!"
print ""

print "First pass summary"
-- Include PROJECT_ID here so that it can be used in the join in the next query. If we don't, the next
-- query will treat PROJECT_ID = ${1} as an SARG and everything else as a JOIN, which means we can't
-- fully utilize our index.
select ${1} as PROJECT_ID, ID, TEAM_ID, min(DATE) as FIRST_DATE, max(DATE) as LAST_DATE,
		sum(WORK_UNITS) as WORK_TOTAL, sum(WORK_UNITS) as WORK_TODAY
-- Use sum(WORK_UNITS) as a place holder for WORK_TODAY so that we know that the field is big enough
	into #WorkSummary1
	from Email_Contrib
	where PROJECT_ID = ${1}
	group by ID, TEAM_ID
go

print "Update for work today"
update #WorkSummary1
	set WORK_TODAY = isnull(ec.WORK_UNITS, 0)
	from Email_Contrib ec
	where ec.PROJECT_ID = #WorkSummary1.PROJECT_ID
		and ec.ID = #WorkSummary1.ID
		and ec.TEAM_ID = #WorkSummary1.TEAM_ID
		and ec.DATE = #WorkSummary1.LAST_DATE
go

print "Update for retire_to"
update #WorkSummary1
	set ID = sp.RETIRE_TO
	from Stats_Participant sp
	where sp.ID = #WorkSummary1.ID
		and sp.RETIRE_TO > 0

print "Second pass summary"
select ws.ID, ws.TEAM_ID, min(FIRST_DATE) as FIRST_DATE, max(LAST_DATE) as LAST_DATE,
		sum(WORK_TOTAL) as WORK_TOTAL, sum(WORK_TODAY) as WORK_TODAY
	into WorkSummary_${1}
	from #WorkSummary1 ws, Stats_Participant sp
	where ws.ID = sp.ID
		and sp.LISTMODE <= 9
	group by ws.ID, ws.TEAM_ID

drop table #WorkSummary1
go

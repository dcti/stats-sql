#!/usr/bin/sqsh -i
#
# $Id: work_summary.sql,v 1.1 2000/09/26 04:17:14 decibel Exp $
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
select ID, TEAM_ID, min(DATE) as FIRST_DATE, max(DATE) as LAST_DATE, sum(WORK_UNITS) as WORK_TOTAL
	into #WorkSummary1
	from Email_Contrib
	where PROJECT_ID = ${1}
	group by ID, TEAM_ID
go

print "Update for retire_to"
update #WorkSummary1
	set ID = sp.RETIRE_TO
	from Stats_Participant sp
	where sp.ID = #WorkSummary1.ID
		and sp.RETIRE_TO > 0

print "Second pass summary"
select ws.ID, ws.TEAM_ID, min(FIRST_DATE) as FIRST_DATE, max(LAST_DATE) as LAST_DATE, sum(WORK_TOTAL) as WORK_TOTAL
	into WorkSummary_${1}
	from #WorkSummary1 ws, Stats_Participant sp
	where ws.ID = sp.ID
		and sp.LISTMODE <= 9
	group by ws.ID, ws.TEAM_ID

drop table #WorkSummary1
go

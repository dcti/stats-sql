#!/usr/local/bin/sqsh -i
#
# $Id: work_summary.sql,v 1.17 2002/10/06 22:59:18 decibel Exp $
#
# Creates a summary table containing all work for a project
#

set flushmessage on
use stats
go

print ""
print "Note:"
print "Make sure that WorkSummary_${1} does not exist!!!"
print ""

print "First pass summary"
-- Include PROJECT_ID here so that it can be used in the join in the next query. If we don't, the next
-- query will treat PROJECT_ID = ${1} as an SARG and everything else as a JOIN, which means we can't
-- fully utilize our index.
create table #WorkSummary (
	PROJECT_ID tinyint,
	ID int,
	TEAM_ID int,
	FIRST_DATE smalldatetime,
	LAST_DATE smalldatetime,
	WORK_TOTAL numeric(20,0),
	WORK_TODAY numeric(20,0),
	WORK_YESTERDAY numeric(20,0)
)
go
insert into #WorkSummary (PROJECT_ID, ID, TEAM_ID, FIRST_DATE, LAST_DATE, WORK_TOTAL, WORK_TODAY, WORK_YESTERDAY)
	select ${1}, ID, TEAM_ID, min(DATE), max(DATE), sum(WORK_UNITS), 0, 0
	from Email_Contrib
	where PROJECT_ID = ${1}
	group by PROJECT_ID, ID, TEAM_ID
go

print "Update for work today"
declare @last smalldatetime
declare @yest smalldatetime
select @last=max(LAST_DATE)
	from #WorkSummary
select @yest = dateadd(day, -1, @last)
update #WorkSummary
	set WORK_TODAY = ec.WORK_UNITS
	from Email_Contrib ec
	where ec.PROJECT_ID = #WorkSummary.PROJECT_ID
		and ec.ID = #WorkSummary.ID
		and ec.TEAM_ID = #WorkSummary.TEAM_ID
		and ec.DATE = @last
update #WorkSummary
	set WORK_YESTERDAY = ec.WORK_UNITS
	from Email_Contrib ec
	where ec.PROJECT_ID = #WorkSummary.PROJECT_ID
		and ec.ID = #WorkSummary.ID
		and ec.TEAM_ID = #WorkSummary.TEAM_ID
		and ec.DATE = @yest
go

print "Update for retire_to"
declare @last smalldatetime
select @last=max(LAST_DATE)
	from #WorkSummary

update #WorkSummary
	set ID = sp.RETIRE_TO
	from Stats_Participant sp
	where sp.ID = #WorkSummary.ID
		and sp.RETIRE_TO > 0
		and (sp.RETIRE_DATE <= @last or sp.RETIRE_DATE is NULL)
go

print "Second pass summary"
select ws.ID, ws.TEAM_ID, min(FIRST_DATE) as FIRST_DATE, max(LAST_DATE) as LAST_DATE,
		sum(WORK_TOTAL) as WORK_TOTAL, sum(WORK_TODAY) as WORK_TODAY, sum(WORK_YESTERDAY) as WORK_YESTERDAY
	into WorkSummary_${1}
	from #WorkSummary ws
	where ws.ID not in (select ID from STATS_Participant_Blocked)
	group by ws.ID, ws.TEAM_ID

drop table #WorkSummary
go

create index team on WorkSummary_${1}(TEAM_ID)
go

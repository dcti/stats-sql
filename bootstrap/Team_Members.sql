/*
# Create the team membership table and populate it from _master
*/
drop table Team_Members
go
create table Team_Members
(
	PROJECT_ID		tinyint,
	ID			int		not NULL,
	TEAM_ID			int		not NULL,
	FIRST_DATE		smalldatetime,
	LAST_DATE		smalldatetime,
	WORK_TODAY		numeric (20,0),
	WORK_TOTAL		numeric (20,0),
	DAY_RANK		int		not NULL,
	DAY_RANK_PREVIOUS	int		not NULL,
	OVERALL_RANK		int		not NULL,
	OVERALL_RANK_PREVIOUS	int		not NULL
)
go

print "::  Filling cache table with data (project,id,team,first,last,blocks)"
go
select PROJECT_ID, ID, TEAM_ID, min(DATE) 'FIRST_DATE', max(DATE) 'LAST_DATE', sum(WORK_UNITS) 'WORK_UNITS'
into #RANKa
from Email_Contrib
where TEAM_ID >= 1
group by PROJECT_ID, ID, TEAM_ID
go

print "::  Honoring all retire_to requests"
go
update #RANKa
  set ID = s.RETIRE_TO
  from STATS_Participant s
  where s.ID = #RANKa.ID
  	and s.retire_to <> s.id
  	and s.retire_to is not NULL
  	and s.retire_to <> 0

print ":: Populating Team_Members table"
go
insert into Team_Members
  (PROJECT_ID, ID, TEAM_ID, FIRST_DATE, LAST_DATE, WORK_TODAY, WORK_TOTAL, DAY_RANK, DAY_RANK_PREVIOUS,
  	OVERALL_RANK, OVERALL_RANK_PREVIOUS)
select PROJECT_ID, ID, TEAM_ID, min(FIRST_DATE), max(LAST_DATE), 0, sum(WORK_UNITS), 1000000, 1000000,
	1000000, 1000000
from #RANKa
group by PROJECT_ID, ID, TEAM_ID
go

create index iMain on Team_Members(PROJECT_ID,TEAM_ID, ID)
go

grant select on Team_Members to public
go


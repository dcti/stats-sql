/*
# Create the team membership table and populate it from _master
*/

create table Team_Members
(
	PROJECT_ID	tinyint,
	ID		int not NULL,
	TEAM		int not NULL,
	FIRST_DATE	smalldatetime,
	LAST_DATE	smalldatetime,
	WORK_UNITS	numeric (20,0)
)
go

print "::  Filling cache table with data (id,team,first,last,blocks)"
go
select PROJECT_ID, ID, TEAM, min(date), max(date), sum(blocks)
into #RANKa
from ${1}_master
where TEAM > 0
group by PROJECT_ID, ID, TEAM
go

print "::  Honoring all retire_to requests"
go
update #RANKa
  set ID = s.retire_to
  from STATS_Participant s
  where s.ID = #RANKa.ID
  	and s.retire_to <> s.id
  	and s.retire_to is not NULL
  	and s.retire_to <> 0

print ":: Populating PREBUILD_${1}_tm_MEMBERS table"
go
insert into Team_Members
  (PROJECT_ID, ID, TEAM, FIRST_DATE, LAST_DATE, WORK_UNITS)
select PROJECT_ID, ID, TEAM, min(FIRST_DATE), max(LAST_DATE), sum(WORK_UNITS)
from #RANKa
group by PROJECT_ID, ID, TEAM
go

create index iMain on Team_Members(TEAM, WORK_UNITS)
go

grant select on Team_Members to public
go


print 'Creating table Team_Members'
go
if object_id('Team_Members') is not NULL
begin
	exec ('if not exists (select * from Team_Members) begin drop table Team_Members end')
end
go
create table Team_Members
(
	PROJECT_ID	tinyint,
	ID		int,
	TEAM_ID		int,
	FIRST_DATE	smalldatetime,
	LAST_DATE	smalldatetime,
	WORK_UNITS	numeric (20,0)
)
go
create index main on Team_Members (TEAM_ID, WORK_UNITS)
go

grant select on Team_Members to public
go

print 'Finished.'
go
print 'Creating table OGR_Team_Members'
go
if object_id('OGR_Team_Members') is not NULL
begin
	exec ('if not exists (select * from OGR_Team_Members) begin drop table OGR_Team_Members end')
end
go
create table OGR_Team_Members
(
	ID		int,
	TEAM		int,
	FIRST_DATE	smalldatetime,
	LAST_DATE	smalldatetime,
	WORK_UNITS	numeric (20,0)
)
go
create index main on OGR_Team_Members (team, blocks)
go

grant select on OGR_Team_Members to public
go

print 'Finished.'
go
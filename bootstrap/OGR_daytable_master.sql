use stats
go

print 'Creating table OGR_Day_Master'
go
if object_id('OGR_Day_Master') is not NULL
begin
	drop table OGR_Day_Master
end
go

create table OGR_Day_Master
(
	PROJECT_ID	tinyint		not NULL,
	email		varchar(64)	not NULL,
	id		int		not NULL,
	team		int		not NULL,
	size		numeric(20, 0)	not NULL
)
go

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
	EMAIL		varchar(64)	not NULL,
	ID		int		not NULL,
	TEAM		int		not NULL,
	WORK_UNITS	numeric(20, 0)	not NULL
)
go

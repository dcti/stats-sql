print 'Creating table OGR_Day_Platform'
go
if object_id('OGR_Day_Platform') is not NULL
begin
	drop table OGR_Day_Platform
end
go

create table OGR_Day_Platform
(
	PROJECT_ID	tinyint		not NULL,
	cpu		smallint	not NULL,
	os		smallint	not NULL,
	ver		smallint	not NULL,
	size		numeric(20, 0)	not NULL
)
go
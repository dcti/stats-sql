use stats
go

print 'Creating table Email_Contrib_Day'
go
if object_id('Email_Contrib_Day') is not NULL
begin
	drop table Email_Contrib_Day
end
go

create table Email_Contrib_Day
(
	PROJECT_ID	tinyint		not NULL,
	EMAIL		varchar(64)	not NULL,
	ID		int		not NULL,
	TEAM		int		not NULL,
	WORK_UNITS	numeric(20, 0)	not NULL
)
go

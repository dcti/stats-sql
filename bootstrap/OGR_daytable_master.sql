use stats
go

print 'Creating table Email_Contrib_Today'
go
if object_id('Email_Contrib_Today') is not NULL
begin
	drop table Email_Contrib_Today
end
go

create table Email_Contrib_Today
(
	PROJECT_ID	tinyint		not NULL,
	EMAIL		varchar(64)	not NULL,
	ID		int		not NULL,
	TEAM_ID		int		not NULL,
	WORK_UNITS	numeric(20, 0)	not NULL,
	CREDIT_ID	int		not NULL
)
go

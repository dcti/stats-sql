print 'Creating table Platform_Contrib_Day'
go
if object_id('Platform_Contrib_Day') is not NULL
begin
	drop table Platform_Contrib_Day
end
go

create table Platform_Contrib_Day
(
	PROJECT_ID	tinyint		not NULL,
	CPU		smallint	not NULL,
	OS		smallint	not NULL,
	VER		smallint	not NULL,
	SIZE		numeric(20, 0)	not NULL
)
go
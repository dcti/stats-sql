print 'Creating table Platform_Contrib_Today'
go
if object_id('Platform_Contrib_Today') is not NULL
begin
	drop table Platform_Contrib_Today
end
go

create table Platform_Contrib_Today
(
	PROJECT_ID	tinyint		not NULL,
	CPU		smallint	not NULL,
	OS		smallint	not NULL,
	VER		smallint	not NULL,
	WORK_UNITS	numeric(20, 0)	not NULL
)
go
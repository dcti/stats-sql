-- $Id: OGR_daytable_master.sql,v 1.5 2000/06/28 10:23:50 decibel Exp $

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
	ID		int		not NULL,
	TEAM_ID		int		not NULL,
	WORK_UNITS	numeric(20, 0)	not NULL,
	CREDIT_ID	int		not NULL
)
go

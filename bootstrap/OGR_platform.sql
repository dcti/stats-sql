/*
# $Id: OGR_platform.sql,v 1.2 2000/04/13 15:00:19 bwilson Exp $
#
# OGR_Platform
#
# This is the platform table for the OGR contest.  This script
# will create the table.
#
# For safety's sake, this script does not include the appropriate
# "drop table" command.  If the table already exists, you will have
# to manually drop the table before this script will function.
#
*/

use stats
go

print 'Creating table Platform_Contrib'
go
if object_id('Platform_Contrib') is not NULL
begin
	exec ('if not exists (select * from Platform_Contrib) begin drop table Platform_Contrib end')
end
go

create table Platform_Contrib
(
	PROJECT_ID	tinyint,
	DATE		smalldatetime,
	CPU		smallint,
	OS		smallint,
	VER		smallint,
	WORK_UNITS	numeric (20,0)
)
go

/* TODO: Review appropriateness of these indexes */
create clustered index iOSDATE
	on Platform_Contrib (OS, DATE, PROJECT_ID)
go
alter table Platform_Contrib
	add constraint pk_OGR_Platform
	primary key nonclustered (CPU, OS, VER, DATE, PROJECT_ID)
go
create index iCPUDATE
	on Platform_Contrib (CPU, DATE, PROJECT_ID)
go
grant select on Platform_Contrib to public
grant insert on Platform_Contrib to statproc
go

/*
# $Id: OGR_platform.sql,v 1.1 2000/03/21 21:55:28 bwilson Exp $
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

print 'Creating table OGR_Platform'
go
if object_id('OGR_Platform') is not NULL
begin
	exec ('if not exists (select * from OGR_Platform) begin drop table OGR_Platform end')
end
go

create table OGR_Platform
(
  CPU           smallint,
  OS            smallint,
  VER           smallint,
  DATE          smalldatetime,
  PROJECT_ID	tinyint,
  WORK_UNITS	numeric (20,0)
)
go

create clustered index iOSDATE
	on OGR_Platform (OS, DATE, PROJECT_ID)
go
alter table OGR_Platform
	add constraint pk_OGR_Platform
	primary key nonclustered (CPU, OS, VER, DATE, PROJECT_ID)
go
create index iCPUDATE
	on OGR_Platform (CPU, DATE, PROJECT_ID)
go
grant select on OGR_Platform to public
grant insert on OGR_Platform to statproc
go

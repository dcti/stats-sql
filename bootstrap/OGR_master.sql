/*
# $Id: OGR_master.sql,v 1.1 2000/03/21 21:55:28 bwilson Exp $
#
# OGR_Master
#
# This is the primary table for the OGR contest.  This script
# will create the table.
#
# For safety's sake, this script does not include the appropriate
# "drop table" command.  If the table already exists, you will have
# to manually drop the table before this script will function.
#
*/

use stats
go

print 'Creating table OGR_Master'
go
create procedure temp_ddl_drop as if not exists (select * from OGR_Master) drop table OGR_Master
go
if object_id('OGR_Master') is not NULL
begin
	exec temp_ddl_drop
end
go
drop procedure temp_ddl_drop
go

create table OGR_Master
(
  ID		int		not NULL,
  TEAM		int		not NULL,
  DATE		smalldatetime	not NULL,
  PROJECT_ID	tinyint		not NULL,
  WORK_UNITS	numeric (20,0)	not NULL
)
go
alter table OGR_Master
	add constraint pk_OGR_Master primary key clustered (ID, DATE, PROJECT_ID)
go
create index team_date on OGR_Master(TEAM, DATE, PROJECT_ID)
create index date_project on OGR_Master(DATE, PROJECT_ID)
go

grant select on OGR_Master to public
grant insert on OGR_Master to statproc
go

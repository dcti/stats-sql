/*
# $Id: OGR_master.sql,v 1.2 2000/04/13 15:00:19 bwilson Exp $
#
# Email_Contrib
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

print 'Creating table Email_Contrib'
go
create procedure temp_ddl_drop as if not exists (select * from Email_Contrib) drop table Email_Contrib
go
if object_id('Email_Contrib') is not NULL
begin
	exec temp_ddl_drop
end
go
drop procedure temp_ddl_drop
go

create table Email_Contrib
(
	ID		int		not NULL,
	TEAM_ID		int		not NULL,
	DATE		smalldatetime	not NULL,
	PROJECT_ID	tinyint		not NULL,
	WORK_UNITS	numeric (20,0)	not NULL
)
go
alter table Email_Contrib
	add constraint pkEmail_Contrib primary key clustered (ID, DATE, PROJECT_ID)
go
create index team_date on Email_Contrib(TEAM, DATE, PROJECT_ID)
create index date_project on Email_Contrib(DATE, PROJECT_ID)
go

grant select on Email_Contrib to public
grant insert on Email_Contrib to statproc
go

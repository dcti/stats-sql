/*
# $Id: OGR_import.sql,v 1.2 2000/06/25 21:57:41 decibel Exp $
#
# import_bcp
#
# This is the import table for the OGR-24 contest.  This script
# will create the table.
#
# For safety's sake, this script does not include the appropriate
# "drop table" command.  If the table already exists, you will have
# to manually drop the table before this script will function.
#
*/

use stats
go

print 'Creating table import_bcp'
go
create procedure temp_ddl_drop as if not exists (select * from import_bcp) drop table import_bcp
go
if object_id('import_bcp') is not NULL
begin
	exec temp_ddl_drop
end
go
drop procedure temp_ddl_drop
go

create table import_bcp
(
	TIME_STAMP	smalldatetime	not NULL,
	EMAIL		varchar(64)	not NULL,
	PROJECT_ID	tinyint		not NULL,
	WORK_UNITS	numeric (20,0)	not NULL,
	OS		int		not NULL,
	CPU		int		not NULL,
	VER		int		not NULL
)
go

grant all on import_bcp to public
go

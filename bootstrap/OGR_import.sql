/*
# $Id: OGR_import.sql,v 1.1 2000/06/17 22:21:27 decibel Exp $
#
# import_24
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

print 'Creating table import_24'
go
create procedure temp_ddl_drop as if not exists (select * from import_24) drop table import_24
go
if object_id('import_24') is not NULL
begin
	exec temp_ddl_drop
end
go
drop procedure temp_ddl_drop
go

create table import_24
(
	TIME_STAMP	datetime	not NULL,
	IP		char(15)	,
	EMAIL		varchar(64)	not NULL,
	PROJECT_ID	tinyint		not NULL,
	BLOCK_ID	char(24)	,
	WORK_UNITS	numeric (20,0)	not NULL,
	OS		int		not NULL,
	CPU		int		not NULL,
	VER		int		not NULL
)
go

grant all on import_24 to public
go

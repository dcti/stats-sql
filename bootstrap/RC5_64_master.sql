# $Id: RC5_64_master.sql,v 1.3 1999/09/29 20:50:34 nugget Exp $
#
# RC5_64_master
#
# This is the primary table for the RC5-64 contest.  This script
# will create the table.
#
# For safety's sake, this script does not include the appropriate
# "drop table" command.  If the table already exists, you will have
# to manually drop the table before this script will function.
#

use stats
go

# drop view RC5_64_master
# go

create table RC5_64_master
(
  id		numeric (7,0)	,
  team		int		default 0,
  date		smalldatetime	,
  blocks	numeric (7,0)	
)
go

create clustered index team on RC5_64_master(team) with allow_dup_row
go

create index id on RC5_64_master(id) 
go

grant select on RC5_64_master to public
go

grant insert on RC5_64_master to statproc
go

# $Id: CSC_master.sql,v 1.1 1999/11/18 20:58:15 nugget Exp $
#
# CSC_master
#
# This is the primary table for the CSC contest.  This script
# will create the table.
#
# For safety's sake, this script does not include the appropriate
# "drop table" command.  If the table already exists, you will have
# to manually drop the table before this script will function.
#

use stats
go

# drop view CSC_master
# go

create table CSC_master
(
  id		numeric (7,0)	,
  team		int		default 0,
  date		smalldatetime	,
  blocks	numeric (7,0)	
)
go

create clustered index team on CSC_master(team) with allow_dup_row
go

create index id on CSC_master(id) 
go

grant select on CSC_master to public
go

grant insert on CSC_master to statproc
go

# $Id: CSC_platform.sql,v 1.1 1999/11/18 21:02:22 nugget Exp $
#
# CSC_platform
#
# This is the platform table for the CSC contest.  This script
# will create the table.
#
# For safety's sake, this script does not include the appropriate
# "drop table" command.  If the table already exists, you will have
# to manually drop the table before this script will function.
#

use stats
go

# drop view CSC_platform
# go

create table CSC_platform
(
  cpu           int,
  os            int,
  ver           int,
  date          smalldatetime,
  blocks	numeric (7,0)	
)
go

create clustered index osdate on CSC_platform(os,date) with allow_dup_row
go

create index cpudate on CSC_platform(cpu,date)
go

create index everything on CSC_platform(cpu,os,ver,date)
go

grant select on CSC_platform to public
go

grant insert on CSC_platform to statproc
go

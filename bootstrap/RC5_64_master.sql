# $Id: RC5_64_master.sql,v 1.4 1999/11/29 16:37:09 nugget Exp $
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
  id            int,
  team          int,
  date          smalldatetime,
  blocks        numeric (7,0)	
)
go

create clustered index iddate on RC5_64_master(id,date)
go

create index team on RC5_64_master(team,date) 
go

grant select on RC5_64_master to public
go

grant insert on RC5_64_master to statproc
go

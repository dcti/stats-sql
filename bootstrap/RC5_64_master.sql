# $Id: RC5_64_master.sql,v 1.1 1999/07/25 06:03:21 nugget Exp $
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

create table vRC5_64_master
(
  id numeric (7,0),
  team int,
  date smalldatetime,
  blocks numeric (7,0)
)
go

grant insert on RC5_64_master to statproc
go

create index id on RC5_64_master(id)
go

create index team on RC5_64_master(team)
go

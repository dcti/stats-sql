# $Id: daytotals.sql,v 1.2 1999/12/18 20:07:01 decibel Exp $

use stats
go

print "Dropping ${1}_daytotals"
drop table ${1}_daytotals
go

print "Creating ${1}_daytotals"
create table ${1}_daytotals
(	date smalldatetime,
	master numeric(10,0) null,
	platform numeric(10,0) null,
	delta numeric(10,0) null,
	absdelta numeric(10,0) null
)
go

print "Inserting into ${1}_daytotals from ${1}_master"
insert into ${1}_daytotals(date, master)
select date, sum(blocks)
from ${1}_master
group by date
go

print "Creating temp table"
select date, sum(blocks) as platform
into #platblocks
from ${1}_platform
group by date
go

print "Creating index on temp table"
create unique clustered index idate on #platblocks(date)
go

print "Adding data from temp table to ${1}_daytotals"
update ${1}_daytotals
set platform = pb.platform
from #platblocks pb
where pb.date=${1}_daytotals.date)
go

# code from bwilson to insert any rows from _platform that aren't in _master :)

print "Updating extra fields in ${1}_daytotals"
update ${1}_daytotals
set delta = master - platform, absdelta = abs(master - platform)
go


# $Id: daytotals.sql,v 1.3 1999/12/18 21:43:17 decibel Exp $

use stats
go

if ("${2}" != "nocreate")
begin
	print "Dropping ${1}_daytotals"
	drop table ${1}_daytotals
end
else
	print "Skipping table drop"
go
	
if ("${2}" != "nocreate")
begin
	print "Creating ${1}_daytotals"
	create table ${1}_daytotals
	(	date smalldatetime,
		master numeric(10,0) null,
		platform numeric(10,0) null,
		dailies numeric(10,0) null
	)
end
else
	print "Skipping table creation"
go
	
if ("${2}" != "nocreate")
begin
	print "Inserting into ${1}_daytotals from ${1}_master"
	insert into ${1}_daytotals(date, master)
	select date, sum(blocks)
	from ${1}_master
	group by date
end
else
	print "Skipping table insert"
go

print "Creating platform temp table"
select date, sum(blocks) as platform
into #platblocks
from ${1}_platform
group by date
go

print "Creating index on platform temp table"
create unique clustered index idate on #platblocks(date)
go

print "Adding data from temp table to ${1}_daytotals"
update ${1}_daytotals
set platform = pb.platform
from #platblocks pb
where pb.date=${1}_daytotals.date
go

print "Inserting platform rows not found in master"
insert ${1}_daytotals (date, platform)
  select date, platform
  from #platblocks
  where date not in (select date from ${1}_daytotals)
go
drop table #platblocks
go



print "Creating dailies temp table"
select date, sum(blocks) as dailies
into #dailyblocks
from ${1}_dailies
group by date
go

print "Creating index on dailies temp table"
create unique clustered index idate on #dailyblocks(date)
go

print "Adding data from temp table to ${1}_daytotals"
update ${1}_daytotals
set dailies = pb.dailies
from #dailyblocks pb
where pb.date=${1}_daytotals.date
go

print "Inserting dailies rows not found in master"
insert ${1}_daytotals (date, dailies)
  select date, dailies
  from #dailyblocks
  where date not in (select date from ${1}_daytotals)
go
drop table #dailyblocks
go




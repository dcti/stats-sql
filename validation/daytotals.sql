drop table ${1}_daytotals
go

create table ${1}_daytotals
(	date smalldatetime,
	master numeric(10,0) null,
	platform numeric(10,0) null,
	delta numeric(10,0) null
	absdelta numeric(10,0) null
)
go

insert into ${1}_daytotals
select date, sum(blocks)
from ${1}_master
group by date
go

select date, sum(blocks) as platform
into #platblocks
from ${1}_platform
group by date
go

update ${1}_daytotals
set platform = (select platform from #platblocks where date=${1}_daytotals.date)
go

# code from bwilson to insert any rows from _platform that aren't in _master :)

update ${1}_daytotals
set delta = master - platform
set absdelta = abs(delta)
go


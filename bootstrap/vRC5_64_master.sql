# $Id: vRC5_64_master.sql,v 1.1 1999/07/27 21:04:52 nugget Exp $
#
# vRC5_64_master
#
# The intention is that users will access this view as opposed to the
# raw RC5_64_master table.  The functional difference being that this
# view is pre-filter to account for retired accounts.
#

use stats
go

drop view vRC5_64_master
go

create view vRC5_64_master
as
select m.id, m.team, m.date, m.blocks, p.retire_to
from RC5_64_master m, STATS_Participant p
where m.id = p.id
go

grant select on vRC5_64_master to public
go

# $Id: STATS_dailies.sql,v 1.2 1999/07/27 21:04:52 nugget Exp $
#
# STATS_dailies
#
# This table holds miscellaneous figures for each day of the contest.
#
# In addition to creating the table, this script will attempt to 
# populate it with data from an existing RC5_64_master table.
#
# For safety's sake, this script does not include the appropriate
# "drop table" command.  If the table already exists, you will have
# to manually drop the table before this script will function.
#

use stats
go

drop table STATS_dailies
go

create table STATS_dailies
(
  date            smalldatetime,
  blocks          numeric(10,0),
  participants    int,
  top_participant int,
  top_pblocks     numeric(10,0),
  teams           int,
  top_team        int,
  top_tblocks     numeric(10,0)
)
go

# Population routine

insert into
  STATS_dailies (date,blocks,participants,teams,top_team,top_tblocks,
	         top_participant, top_pblocks)
  select distinct
    date,
    sum(blocks) as blocks,
    count(id) as participants,
    0 as teams,
    0 as top_team,
    0 as top_tblocks,
    0 as top_participant,
    0 as top_pblocks
  from RC5_64_master
  group by date
  order by date
go

select distinct
  date,
  team
into #teamcounts
from RC5_64_master
group by date,team
go

select distinct
  date,
  count(team) as teamcount
into #teamsums
from #teamcounts
group by date
go

update STATS_dailies set
  teams = teamcount
from STATS_dailies, #teamsums 
where #teamsums.date = STATS_dailies.date
go

create index top_participant on STATS_dailies(top_participant)
go

create index top_team on STATS_dailies(top_team)
go

grant insert on STATS_dailies to statproc
go

grant select on STATS_dailies to public
go


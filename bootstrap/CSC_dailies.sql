# $Id: CSC_dailies.sql,v 1.1 1999/11/18 21:33:16 nugget Exp $
#
# CSC
#
# This table holds miscellaneous figures for each day of the contest.
#
# In addition to creating the table, this script will attempt to 
# populate it with data from an existing CSC_master table.
#
# For safety's sake, this script does not include the appropriate
# "drop table" command.  If the table already exists, you will have
# to manually drop the table before this script will function.
#

use stats
go

#drop table CSC_dailies
#go

create table CSC_dailies
(
  date             smalldatetime,
  blocks           numeric(10,0),
  participants     int,
  top_oparticipant int,
  top_opblocks     numeric(10,0),
  top_yparticipant int,
  top_ypblocks     numeric(10,0),
  teams            int,
  top_oteam        int,
  top_otblocks     numeric(10,0),
  top_yteam        int,
  top_ytblocks     numeric(10,0)
)
go

# Population routine

insert into
  CSC_dailies (date,blocks,
                 participants,top_oparticipant,top_opblocks,top_yparticipant,top_ypblocks,
                 teams,top_oteam,top_otblocks,top_yteam,top_ytblocks)
  select distinct
    date,
    sum(blocks) as blocks,
    count(id) as participants,
    0 as top_oparticipant,
    0 as top_opblocks,
    0 as top_yparticipant,
    0 as top_ypblocks,
    0 as teams,
    0 as top_oteam,
    0 as top_otblocks,
    0 as top_yteam,
    0 as top_ytblocks
  from CSC_master
  group by date
  order by date
go

select distinct
  date,
  team
into #teamcounts
from CSC_master
group by date,team
go

select distinct
  date,
  count(team) as teamcount
into #teamsums
from #teamcounts
group by date
go

update CSC_dailies set
  teams = teamcount
from CSC_dailies, #teamsums 
where #teamsums.date = CSC_dailies.date
go

create index date on CSC_dailies(date)
go

create index top_oparticipant on CSC_dailies(top_oparticipant)
go

create index top_yparticipant on CSC_dailies(top_yparticipant)
go

create index top_oteam on CSC_dailies(top_oteam)
go

create index top_yteam on CSC_dailies(top_yteam)
go

grant insert on CSC_dailies to statproc
go

grant select on CSC_dailies to public
go


/*
# $Id: OGR_dailies.sql,v 1.2 2000/04/11 14:11:12 bwilson Exp $
#
# OGR
#
# This table holds miscellaneous figures for each day of each project.
#
# In addition to creating the table, this script will attempt to
# populate it with data from an existing OGR_Master table.
#
# For safety's sake, this script does not include the appropriate
# "drop table" command.  If the table already exists, you will have
# to manually drop the table before this script will function.
#
*/
use stats
go

print 'Creating table Daily_Summary'
go
if object_id('Daily_Summary') is not NULL
begin
	drop table Daily_Summary
end
go
create table Daily_Summary
(
	DATE			smalldatetime	not NULL,
	PROJECT_ID		tinyint		not NULL,
	WORK_UNITS		numeric(20,0)	not NULL,
	PARTICIPANTS		int		not NULL,
	TOP_OPARTICIPANT	int		not NULL,
	TOP_OPWORK		numeric(20,0)	not NULL,
	TOP_YPARTICIPANT	int		not NULL,
	TOP_YPWORK		numeric(20,0)	not NULL,
	TEAMS			int		not NULL,
	TOP_OTEAM		int		not NULL,
	TOP_OTWORK		numeric(20,0)	not NULL,
	TOP_YTEAM		int		not NULL,
	TOP_YTEAMWORK		numeric(20,0)	not NULL
)
go

print 'Population routine'
go
insert into
  Daily_Summary (date, PROJECT_ID, WORK_UNITS, PARTICIPANTS,
                 TOP_oparticipant, TOP_OPWORK,
                 TOP_YPARTICIPANT, TOP_YPWORK,
                 teams,
                 TOP_OTEAM, TOP_OTWORK,
                 TOP_yteam, TOP_YTWORK)
  select
    date,
    PROJECT_ID,
    sum(blocks) as blocks,
    count(distinct id) as participants,
    0 as TOP_oparticipant,
    0 as TOP_OPWORK,
    0 as TOP_YPARTICIPANT,
    0 as TOP_YPWORK,
    0 as teams,
    0 as TOP_OTEAM,
    0 as TOP_OTWORK,
    0 as TOP_yteam,
    0 as TOP_YTEAMWORK
  from OGR_Master
  group by date, PROJECT_ID
  order by date, PROJECT_ID
go

select distinct date, PROJECT_ID, team
into #teamcounts
from OGR_Master
go

select date, PROJECT_ID, count(team) as teamcount
  into #teamsums
  from #teamcounts
  group by date, PROJECT_ID
go

update Daily_Summary
  set teams = teamcount
  from Daily_Summary, #teamsums
  where #teamsums.date = Daily_Summary.date
  	and #teamsums.PROJECT_ID = Daily_Summary.PROJECT_ID
go

alter table Daily_Summary
	add constraint pk_Daily_Summary primary key clustered (date, PROJECT_ID)
go
grant insert on Daily_Summary to statproc
grant select on Daily_Summary to public
go


/*
# $Id: OGR_dailies.sql,v 1.3 2000/04/20 13:14:01 bwilson Exp $
#
# This table holds summary statistics for each day of each project.
#
# In addition to creating the table, this script will attempt to
# populate it with data from an existing Email_Contrib table.
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
insert Daily_Summary (DATE, PROJECT_ID, WORK_UNITS,
		PARTICIPANTS, TOP_OPARTICIPANT, TOP_OPWORK, TOP_YPARTICIPANT, TOP_YPWORK,
		TEAMS, TOP_OTEAM, TOP_OTWORK, TOP_YTEAM, TOP_YTWORK)
	select DATE, PROJECT_ID, sum(WORK_UNITS), 
		count(distinct ID), 0, 0, 0, 0,
  		0, 0, 0 ,0, 0)
	from Email_Contrib
	group by DATE, PROJECT_ID
	order by DATE, PROJECT_ID
go

select DATE, PROJECT_ID, count(distinct TEAM_ID) as TEAMCOUNT
	into #teamcounts
	from Email_Contrib
	group by DATE, PROJECT_ID
go

update Daily_Summary
  set TEAMS = TEAMCOUNT
  from Daily_Summary, #teamcounts
  where #teamcounts.DATE = Daily_Summary.DATE
  	and #teamcounts.PROJECT_ID = Daily_Summary.PROJECT_ID
go

alter table Daily_Summary
	add constraint pk_Daily_Summary primary key clustered (DATE, PROJECT_ID)
go
grant insert on Daily_Summary to statproc
grant select on Daily_Summary to public
go


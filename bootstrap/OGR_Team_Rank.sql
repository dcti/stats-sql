# $Id: OGR_Team_Rank.sql,v 1.3 2000/06/26 23:09:57 decibel Exp $
print 'Creating table Team_Rank'
go
if object_id('Team_Rank') is not NULL
begin
	exec ('if not exists (select * from Team_Rank) begin drop table Team_Rank end')
end
go
create table Team_Rank
(
	PROJECT_ID		tinyint		not NULL,
	TEAM_ID			int		not NULL,
	FIRST_DATE		smalldatetime	not NULL,
	LAST_DATE		smalldatetime	not NULL,
	WORK_TODAY		numeric(20, 0)	not NULL,
	WORK_TOTAL		numeric(20, 0)	not NULL,
	DAY_RANK		int		not NULL,
	DAY_RANK_PREVIOUS	int		not NULL,
	OVERALL_RANK		int		not NULL,
	OVERALL_RANK_PREVIOUS	int		not NULL,
	MEMBERS_TODAY		int		not NULL,
	MEMBERS_OVERALL		int		not NULL,
	MEMBERS_CURRENT		int		not NULL
)
go
create clustered index iDAY_RANK
	on Team_Rank(DAY_RANK)
	with fillfactor = 100
go
alter table Team_Rank
	add constraint pk_Team_Rank
	primary key nonclustered (TEAM_ID)
	with fillfactor = 100
go
grant select on Team_Rank to public
go
print 'Finished.'
go

print 'Creating table OGR_Team_Rank'
go
if object_id('OGR_Team_Rank') is not NULL
begin
	exec ('if not exists (select * from OGR_Team_Rank) begin drop table OGR_Team_Rank end')
end
go
create table OGR_Team_Rank
(
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
	MEMBERS_LISTED		int		not NULL
)
go
create clustered index iDAY_RANK
	on OGR_Team_Rank(DAY_RANK)
	with fillfactor = 100
go
alter table OGR_Team_Rank
	add constraint pk_OGR_Team_Rank
	primary key nonclustered (TEAM_ID)
	with fillfactor = 100
go
grant select on OGR_Team_Rank to public
go
print 'Finished.'
go

print 'Creating table OGR_Email_Rank'
go
if object_id('OGR_Email_Rank') is not NULL
begin
	exec ('if not exists (select * from OGR_Email_Rank) begin drop table OGR_Email_Rank end')
end
go
create table OGR_Email_Rank
(
	ID			int		not NULL,
	FIRST_DATE		smalldatetime	not NULL,
	LAST_DATE		smalldatetime	not NULL,
	WORK_TODAY		numeric(20, 0)	not NULL,
	WORK_TOTAL		numeric(20, 0)	not NULL,
	DAY_RANK		int		not NULL,
	DAY_RANK_PREVIOUS	int		not NULL,
	OVERALL_RANK		int		not NULL,
	OVERALL_RANK_PREVIOUS	int		not NULL
)
go
create clustered index iDAY_RANK
	on OGR_Email_Rank(DAY_RANK)
	with fillfactor = 100
go
alter table OGR_Email_Rank
	add constraint pk_OGR_Email_Rank
	primary key nonclustered (ID)
	with fillfactor = 100
go
grant select on OGR_Email_Rank to public
go
print 'Finished.'
go
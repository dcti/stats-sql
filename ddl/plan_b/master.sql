print 'Creating table planb_Contribution'
go
if object_id('planb_Contribution') is not NULL
begin
	if (select count(*) from planb_Contribution) = 0
	begin
		drop table planb_Contribution
	end
end
go
create table planb_Master
(
	CONTEST_ID		tinyint		not NULL,
	PART_ID			int		not NULL,
	DATE			smalldatetime	NULL,
	BLOCKS			numeric(8, 0)	not NULL
)
go
exec sp_bindefault def0, 'planb_Master.CONTEST'
exec sp_bindefault def0, 'planb_Master.ID'
exec sp_bindefault def0, 'planb_Master.BLOCKS'
go

print 'Creating table planb_ParticipantTeam
go
if object_id('planb_ParticipantTeam') is not NULL
begin
	if (select count(*) from planb_ParticipantTeam) = 0
	begin
		drop table planb_ParticipantTeam
	end
end
go
create table planb_ParticipantTeam
(
	PART_ID			int		not NULL,
	TEAM_ID			int		not NULL,
	START_DATE		smalldatetime	not NULL,
	END_DATE		smalldatetime	NULL
)
go
exec sp_bindefault def0, 'planb_ParticipantTeam.PART_ID'
exec sp_bindefault def0, 'planb_ParticipantTeam.TEAM_ID'
go
select ID, TEAM, min(DATE) 'START_DATE', min(DATE) 'END_DATE'
	into #temp1
	from CSC_master
	group by ID, TEAM

create unique clustered index

while @@rowcount > 0
begin
	update 

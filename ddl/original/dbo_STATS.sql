-- $Id: dbo_STATS.sql,v 1.2 1999/12/10 17:05:47 bwilson Exp $
--
-- Description
--
-- Revision history:
--
-- 19991125 - Created from sp_help output

print 'Creating table STATS_os'
go
if object_id('STATS_os') is not NULL
begin
	if (select rows from sysindexes where id = object_id('STATS_os') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table STATS_os
	end
end
go
create table STATS_os
(
	os			int		not NULL,
	name			char(32)	not NULL,
	image			char(64)	NULL,
	category		char(32)	NULL
)
go
create unique clustered index os on STATS_os(os)
go


print 'Creating table STATS_country'
go
if object_id('STATS_country') is not NULL
begin
	if (select rows from sysindexes where id = object_id('STATS_country') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table STATS_country
	end
end
go
create table STATS_country
(
	country			char(64)	not NULL,
	code			char(2)		not NULL
)
go
create index country on STATS_country(country)
create index code on STATS_country(code)
go

print 'Creating table STATS_team'
go
if object_id('STATS_team') is not NULL
begin
	if (select rows from sysindexes where id = object_id('STATS_team') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table STATS_team
	end
end
go
create table STATS_team
(
	team			numeric(10, 0)	not NULL	identity,
	listmode		smallint	not NULL,
	password		char(8)		NULL,
	name			char(64)	NULL,
	url			char(128)	NULL,
	contactname		char(64)	NULL,
	contactemail		char(64)	NULL,
	logo			char(128)	NULL,
	showmembers		char(3)		NULL,
	showpassword		char(16)	NULL,
	description		text		NULL
)
go
create clustered index name on STATS_team(name)
go
create index team on STATS_team(team)
go

-- Check tables above here for identity property

print 'Creating table STATS_teamold'
go
if object_id('STATS_teamold') is not NULL
begin
	if (select rows from sysindexes where id = object_id('STATS_teamold') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table STATS_teamold
	end
end
go
create table STATS_teamold
(
	team			numeric(10, 0)	not NULL	identity,
	listmode		smallint	not NULL,
	password		char(8)		NULL,
	name			char(64)	NULL,
	url			char(128)	NULL,
	contactname		char(64)	NULL,
	contactemail		char(64)	NULL,
	logo			char(128)	NULL,
	showmembers		char(3)		NULL,
	showpassword		char(16)	NULL,
	description		text		NULL
)
go
create index team on STATS_teamold(team)
create unique index name on STATS_teamold(name)
go

print 'Creating table STATS_participant'
go
if object_id('STATS_participant') is not NULL
begin
	if (select rows from sysindexes where id = object_id('STATS_participant') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table STATS_participant
	end
end
go
create table STATS_participant
(
	id			numeric(10, 0)	not NULL	identity,
	email			varchar(64)	not NULL,
	password		varchar(8)	not NULL,
	listmode		smallint	not NULL,
	nonprofit		int		not NULL,
	team			int		not NULL,
	retire_to		int		not NULL,
	friend_a		int		not NULL,
	friend_b		int		not NULL,
	friend_c		int		not NULL,
	friend_d		int		not NULL,
	friend_e		int		not NULL,
	dem_yob			int		not NULL,
	dem_heard		int		not NULL,
	dem_gender		char(1)		not NULL,
	dem_motivation		int		not NULL,
	dem_country		char(8)		not NULL,
	contact_name		char(50)	not NULL,
	contact_phone		char(20)	not NULL,
	motto			char(255)	not NULL
)
go
exec sp_bindefault defspace, 'STATS_Participant.EMAIL'
exec sp_bindefault defspace, 'STATS_Participant.PASSWORD'
exec sp_bindefault def0, 'STATS_Participant.LISTMODE'
exec sp_bindefault def0, 'STATS_Participant.NONPROFIT'
exec sp_bindefault def0, 'STATS_Participant.TEAM'
exec sp_bindefault def0, 'STATS_Participant.RETIRE_TO'
exec sp_bindefault def0, 'STATS_Participant.FRIEND_A'
exec sp_bindefault def0, 'STATS_Participant.FRIEND_B'
exec sp_bindefault def0, 'STATS_Participant.FRIEND_C'
exec sp_bindefault def0, 'STATS_Participant.FRIEND_D'
exec sp_bindefault def0, 'STATS_Participant.FRIEND_E'
exec sp_bindefault def0, 'STATS_Participant.DEM_YOB'
exec sp_bindefault def0, 'STATS_Participant.DEM_HEARD'
exec sp_bindefault defspace, 'STATS_Participant.DEM_GENDER'
exec sp_bindefault def0, 'STATS_Participant.DEM_MOTIVATION'
exec sp_bindefault defspace, 'STATS_Participant.DEM_COUNTRY'
exec sp_bindefault defspace, 'STATS_Participant.CONTACT_NAME'
exec sp_bindefault defspace, 'STATS_Participant.CONTACT_PHONE'
exec sp_bindefault defspace, 'STATS_Participant.MOTTO'
go
create unique clustered index iParticipantEMAIL on STATS_Participant(EMAIL) with fillfactor = 75
go
alter table STATS_Participant add constraint pk_Participant primary key nonclustered (id) with fillfactor = 75
create index iParticipantTEAM on STATS_participant(TEAM) with fillfactor = 75
create index iParticipantRETIRE_TO on STATS_participant(RETIRE_TO) with fillfactor = 75
go


print 'Creating table STATS_participantold'
go
if object_id('STATS_participantold') is not NULL
begin
	if (select rows from sysindexes where id = object_id('STATS_participantold') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table STATS_participantold
	end
end
go
create table STATS_participantold
(
	id			numeric(10, 0)	not NULL	identity,
	email			char(64)	not NULL,
	password		char(8)		NULL,
	listmode		smallint	not NULL	default 0,
	nonprofit		int		not NULL	default 0,
	team			int		not NULL	default 0,
	retire_to		int		not NULL	default 0,
	friend_a		int		not NULL	default 0,
	friend_b		int		not NULL	default 0,
	friend_c		int		not NULL	default 0,
	friend_d		int		not NULL	default 0,
	friend_e		int		not NULL	default 0,
	dem_yob			int		NULL,
	dem_heard		int		NULL,
	dem_gender		char(1)		NULL,
	dem_motivation		int		NULL,
	dem_country		char(8)		NULL,
	contact_name		char(50)	NULL,
	contact_phone		char(20)	NULL,
	motto			char(255)	NULL
)
go
create index team on STATS_participantold(team)
create index email on STATS_participantold(email)
create index retire_to on STATS_participantold(retire_to)
create index id on STATS_participantold(id)
go


print 'Creating table STATS_cpu'
go
if object_id('STATS_cpu') is not NULL
begin
	if (select rows from sysindexes where id = object_id('STATS_cpu') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table STATS_cpu
	end
end
go
create table STATS_cpu
(
	cpu			int		not NULL,
	name			char(32)	not NULL,
	image			char(64)	NULL,
	category		char(32)	NULL,
)
go
create unique clustered index cpu on STATS_cpu(cpu)
go


print 'Creating table STATS_dailies'
go
if object_id('STATS_dailies') is not NULL
begin
	if (select rows from sysindexes where id = object_id('STATS_dailies') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table STATS_dailies
	end
end
go
create table STATS_dailies
(
	date			smalldatetime	not NULL,
	blocks			numeric(10, 0)	not NULL,
	participants		int		not NULL,
	top_oparticipant	int		not NULL,
	top_opblocks		numeric(10, 0)	not NULL,
	top_yparticipant	int		not NULL,
	top_ypblocks		numeric(10, 0)	not NULL,
	teams			int		not NULL,
	top_oteam		int		not NULL,
	top_otblocks		numeric(10, 0)	not NULL,
	top_yteam		int		not NULL,
	top_ytblocks		numeric(10, 0)	not NULL
)
go
create index date on STATS_dailies(date)
create index top_oparticipant on STATS_dailies(top_oparticipant)
create index top_yparticipant on STATS_dailies(top_yparticipant)
create index top_oteam on STATS_dailies(top_oteam)
create index top_yteam on STATS_dailies(top_yteam)
go

print 'Creating table STATS_nonprofit'
go
if object_id('STATS_nonprofit') is not NULL
begin
	if (select rows from sysindexes where id = object_id('STATS_nonprofit') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table STATS_nonprofit
	end
end
go
create table STATS_nonprofit
(
	nonprofit		int		not NULL,
	name			char(64)	not NULL,
	url			char(64)	not NULL,
	comments		text		not NULL	
)
go


print 'Finished.'

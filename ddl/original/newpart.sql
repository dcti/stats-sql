print 'Creating table Participant_Main'
go
if object_id('STATS_participant') is not NULL
begin
	drop table Participant_Main
end
go
create table Participant_Main
(
	ID			numeric(10, 0)	identity,
	EMAIL			varchar(64)	not NULL,
	CONTACT_NAME		varchar(50)	not NULL,
	LISTMODE		tinyint		not NULL,
	TEAM			int		not NULL,
	NONPROFIT		tinyint		not NULL,
	RETIRE_TO		int		not NULL,
)
go
exec sp_bindefault defspace, 'Participant_Main.EMAIL'
exec sp_bindefault defspace, 'Participant_Main.CONTACT_NAME'
exec sp_bindefault def0, 'Participant_Main.LISTMODE'
exec sp_bindefault def0, 'Participant_Main.NONPROFIT'
exec sp_bindefault def0, 'Participant_Main.TEAM'
exec sp_bindefault def0, 'Participant_Main.RETIRE_TO'
go
set identity_insert Participant_Main on
go
insert Participant_Main (ID, EMAIL, CONTACT_NAME, LISTMODE, NONPROFIT, TEAM, RETIRE_TO)
	select id, email, contact_name, listmode, nonprofit, team, retire_to
	from STATS_Participant
	where retire_to <> 0
	order by email
insert Participant_Main (ID, EMAIL, CONTACT_NAME, LISTMODE, NONPROFIT, TEAM, RETIRE_TO)
	select id, email, contact_name, listmode, nonprofit, team, id
	from STATS_Participant
	where retire_to = 0
	order by email
go
set identity_insert Participant_Main off
go
create unique clustered index iParticipant_MainEMAIL on Participant_Main(EMAIL) with fillfactor = 75
go
alter table Participant_Main add constraint pk_Participant_Main primary key nonclustered (ID) with fillfactor = 99
go
create index TEAM on Participant_Main(TEAM) with fillfactor = 75
create index RETIRE_TO on Participant_Main(RETIRE_TO) with fillfactor = 75
go



print 'Creating table Participant_Dem'
go
if object_id('STATS_participant') is not NULL
begin
	drop table Participant_Dem
end
go
create table Participant_Dem
(
	ID			int		not NULL,
	CONTACT_PHONE		varchar(20)	not NULL,
	PASSWORD		varchar(8)	not NULL,
	YOB			smallint	not NULL,
	HEARD			tinyint		not NULL,
	GENDER			char(1)		not NULL,
	MOTIVATION		tinyint		not NULL,
	COUNTRY			varchar(8)	not NULL,
	MOTTO			varchar(255)	not NULL
)
go
exec sp_bindefault defspace, 'Participant_Dem.PASSWORD'
exec sp_bindefault def0, 'Participant_Dem.YOB'
exec sp_bindefault def0, 'Participant_Dem.HEARD'
exec sp_bindefault defspace, 'Participant_Dem.GENDER'
exec sp_bindefault def0, 'Participant_Dem.MOTIVATION'
exec sp_bindefault defspace, 'Participant_Dem.COUNTRY'
exec sp_bindefault defspace, 'Participant_Dem.CONTACT_PHONE'
exec sp_bindefault defspace, 'Participant_Dem.MOTTO'
go
insert Participant_Dem
	select id, contact_phone, password, dem_yob, dem_heard, dem_gender, dem_motivation, dem_country, motto
	from STATS_Participant
go
alter table Participant_Dem add constraint pk_Participant_Dem primary key clustered (ID) with fillfactor = 99
go


print 'Creating table Participant_Friends'
go
if object_id('STATS_Participant') is not NULL
begin
	drop table Participant_Friends
end
go
create table Participant_Friends
(
	NAMING_ID		int		not NULL,
	NAMED_ID		int		not NULL
)
go
exec sp_bindefault def0, 'Participant_Friends.NAMING_ID'
exec sp_bindefault def0, 'Participant_Friends.NAMED_ID'
go
insert Participant_Friends
	select id, friend_a
	from STATS_Participant
	where friend_a <> 0
insert Participant_Friends
	select sp.id, sp.friend_b
	from STATS_Participant sp
	where sp.friend_b <> 0
		and not exists(select * from Participant_Friends where NAMING_ID = sp.id and NAMED_ID = sp.friend_b)
insert Participant_Friends
	select id, friend_c
	from STATS_Participant sp
	where friend_c <> 0
		and not exists(select * from Participant_Friends where NAMING_ID = sp.id and NAMED_ID = sp.friend_c)
insert Participant_Friends
	select id, friend_d
	from STATS_Participant sp
	where friend_d <> 0
		and not exists(select * from Participant_Friends where NAMING_ID = sp.id and NAMED_ID = sp.friend_d)
insert Participant_Friends
	select id, friend_e
	from STATS_Participant sp
	where friend_e <> 0
		and not exists(select * from Participant_Friends where NAMING_ID = sp.id and NAMED_ID = sp.friend_e)
go
alter table Participant_Friends add constraint pk_Participant_Friends primary key clustered (NAMING_ID, NAMED_ID)
go
create index iParticipant_FriendsNAMED_ID on Participant_Friends(NAMED_ID)
go

print 'Creating view vSTATS_Participant'
go
drop view vSTATS_Participant
go
create view vSTATS_Participant
as
select pm.ID as 'id',
	pm.EMAIL as 'email',
	pd.PASSWORD as 'password',
	pm.LISTMODE as 'listmode',
	pm.NONPROFIT as 'nonprofit',
	pm.TEAM as 'team',
	pm.RETIRE_TO as 'retire_to',
	pd.YOB as 'dem_yob',
	pd.HEARD as 'dem_heard',
	pd.GENDER as 'dem_gender',
	pd.MOTIVATION as 'dem_motivation',
	pd.COUNTRY as 'dem_country',
	pm.CONTACT_NAME as 'contact_name',
	pd.CONTACT_PHONE as 'contact_phone',
	pd.MOTTO as 'motto'
	from Participant_Main pm, Participant_Dem pd
	where pm.ID = pd.ID
go
print 'Finished.'
go


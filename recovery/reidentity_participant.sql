# $Id: reidentity_participant.sql,v 1.2 2000/01/27 09:11:55 decibel Exp $

# If all goes well, this is a hands-off recovery routine to repair the
# runaway identity value problem wxperienced during server abend.
# 
# Run as sa, of course.
#
# sqsh -Usa -P- -i reidentity_participant.sql
#

use stats
go

create table STATS_participantnew
(
id			numeric(10, 0)	identity	not NULL,
email			varchar(64)	not NULL,
password		varchar(8)	not NULL,
listmode		smallint	not NULL,
nonprofit		smallint	not NULL,
team			int		not NULL,
retire_to		int		not NULL,
friend_a		int		not NULL,
friend_b		int		not NULL,
friend_c		int		not NULL,
friend_d		int		not NULL,
friend_e		int		not NULL,
dem_yob			int		not NULL,
dem_heard		int		not NULL,
dem_gender		varchar(1)	not NULL,
dem_motivation		int		not NULL,
dem_country		varchar(8)	not NULL,
contact_name		varchar(50)	not NULL,
contact_phone		varchar(20)	not NULL,
motto			varchar(255)	not NULL
)
go
exec sp_bindefault defspace, 'STATS_Participantnew.EMAIL'
exec sp_bindefault defspace, 'STATS_Participantnew.PASSWORD'
exec sp_bindefault def0, 'STATS_Participantnew.LISTMODE'
exec sp_bindefault def0, 'STATS_Participantnew.NONPROFIT'
exec sp_bindefault def0, 'STATS_Participantnew.TEAM'
exec sp_bindefault def0, 'STATS_Participantnew.RETIRE_TO'
exec sp_bindefault def0, 'STATS_Participantnew.FRIEND_A'
exec sp_bindefault def0, 'STATS_Participantnew.FRIEND_B'
exec sp_bindefault def0, 'STATS_Participantnew.FRIEND_C'
exec sp_bindefault def0, 'STATS_Participantnew.FRIEND_D'
exec sp_bindefault def0, 'STATS_Participantnew.FRIEND_E'
exec sp_bindefault def0, 'STATS_Participantnew.DEM_YOB'
exec sp_bindefault def0, 'STATS_Participantnew.DEM_HEARD'
exec sp_bindefault defspace, 'STATS_Participantnew.DEM_GENDER'
exec sp_bindefault def0, 'STATS_Participantnew.DEM_MOTIVATION'
exec sp_bindefault defspace, 'STATS_Participantnew.DEM_COUNTRY'
exec sp_bindefault defspace, 'STATS_Participantnew.CONTACT_NAME'
exec sp_bindefault defspace, 'STATS_Participantnew.CONTACT_PHONE'
exec sp_bindefault defspace, 'STATS_Participantnew.MOTTO'
go

set identity_insert STATS_participantnew on
go

insert into STATS_participantnew
 (id,email,password,listmode,nonprofit,team,retire_to,friend_a,friend_b,
  friend_c,friend_d,friend_e,dem_yob,dem_heard,dem_gender,dem_motivation,
  dem_country,contact_name,contact_phone,motto)
 select
  id,email,password,listmode,nonprofit,team,retire_to,friend_a,friend_b,
  friend_c,friend_d,friend_e,dem_yob,dem_heard,dem_gender,dem_motivation,
  dem_country,contact_name,contact_phone,motto
from STATS_participant
where id < 500000
go

set identity_insert STATS_participantnew off
go

insert STATS_participantnew
 (email, password, listmode, nonprofit, team, retire_to, friend_a, friend_b,
  friend_c, friend_d, friend_e, dem_yob, dem_heard, dem_gender, dem_motivation,
  dem_country, contact_name, contact_phone, motto)
 select email, password, listmode, nonprofit, team, retire_to, friend_a, friend_b,
  friend_c, friend_d, friend_e, dem_yob, dem_heard, dem_gender, dem_motivation,
  dem_country, contact_name, contact_phone, motto
 from STATS_Participant
 where id >= 500000
go


print "Creating index iParticipantEMAIL"
go
create unique clustered index iParticipantEMAIL on STATS_participantnew(email) with fillfactor = 75
go
print "Creating other indexes"
alter table STATS_Participantnew add constraint pk_Participant primary key nonclustered (id) with fillfactor = 75
create index iParticipantTEAM on STATS_participantnew(TEAM) with fillfactor = 75
create index iParticipantRETIRE_TO on STATS_participantnew(RETIRE_TO) with fillfactor = 75
go

grant select,insert,update on STATS_participantnew to public
go

grant all on STATS_participantnew to wheel
go

print "STATS_participantnew has been created and populated; please run the phase 2 script to rename it and modify the records in the two _masters"
go


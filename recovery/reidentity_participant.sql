# $Id: reidentity_participant.sql,v 1.1 1999/07/28 19:21:50 nugget Exp $

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
( id        numeric (10,0) IDENTITY NOT NULL,
  email     char (64) NOT NULL,
  password  char (8) NULL ,
  listmode  smallint default 0,
  nonprofit int default 0,
  team      int default 0,
  retire_to int default 0,
  friend_a  int default 0,
  friend_b  int default 0,
  friend_c  int default 0,
  friend_d  int default 0,
  friend_e  int default 0,
  dem_yob   int NULL,
  dem_heard int NULL,
  dem_gender char (1) NULL,
  dem_motivation int NULL,
  dem_country char(8) NULL,
  contact_name char (50) NULL,
  contact_phone char (20) NULL,
  motto char (128) NULL
)
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

create index team on STATS_participantnew(team)
go

create index email on STATS_participantnew(email)
go

create index retire_to on STATS_participantnew(retire_to)
go

create index id on STATS_participantnew(id)
go

grant select,insert,update on STATS_participantnew to public
go

grant all on STATS_participantnew to wheel
go

drop table STATS_participantold
go

sp_rename STATS_participant, STATS_participantold
go

sp_rename STATS_participantnew, STATS_participant
go


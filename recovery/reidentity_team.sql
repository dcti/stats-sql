# $Id: reidentity_team.sql,v 1.1 1999/07/28 19:23:24 nugget Exp $

use stats
go

CREATE TABLE stats.dbo.STATS_teamnew (
	team numeric (10,0) IDENTITY NOT NULL,
	listmode smallint default 0,
	password char (8) NULL,
	name char (64) NULL ,
	url char (128) NULL ,
	contactname char (64) NULL,
	contactemail char (64) NULL,
	logo char (128) NULL,
	showmembers char (3) NULL,
	showpassword char (16) NULL,
	description text NULL
)
go

set identity_insert STATS_teamnew on
go

insert into STATS_teamnew (team, listmode, password, name, url, contactname,
                           contactemail,logo,showmembers,showpassword,
                           description)
select team,listmode,password,name,url,contactname,contactemail,logo,
       showmembers,showpassword,description
from STATS_team
where team < 100000
go

set identity_insert STATS_teamnew off
go

create index team on STATS_teamnew(team)
go

create unique index name on STATS_teamnew(name)
go

grant select,insert,update on STATS_teamnew to public
go

grant all on STATS_teamnew to wheel
go

drop table STATS_teamold
go

sp_rename STATS_team, STATS_teamold
go

sp_rename STATS_teamnew, STATS_team
go


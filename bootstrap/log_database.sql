# $Id: log_database.sql,v 1.3 1999/11/20 22:30:13 decibel Exp $
#
# This script will create the log database and tables. The
# log database devices must have already been created.

use master
go

# on devicename = size in megabytes
\echo Creating databases...
create database logs
on dev_logsa = 50
log on dev_logs_logsa = 20
go

use logs
go

\echo Creating types...
sp_addtype sid, "numeric(4,0)", "identity"
go

\echo Creating table \\'sources\\'...
create table sources
(source_id	sid,
section		char(10)	not null,
source		char(30)	not null,
text1           char(20)        null,
real1           char(20)        null,
numeric1        char(20)        null,
text2		char(20)	null,
real2		char(20)	null,
numeric2	char(20)	null,
primary key nonclustered (source_id) )
go

\echo Creating indexes on \\'sources\\'...
create clustered index section on sources(section, source)
go

create index source on sources(source)
go

\echo Setting rights on \\'sources\\'...
revoke all
on sources
to public
go

grant insert,select
on sources
to public
go

\echo Creating table \\'entries\\'...
create table entries
(timestamp	datetime	default getdate() not null,
source_id	sid		references sources(source_id),
source_version	numeric(5,5)	not null,
text1		varchar(255)	null,
real1		real		null,
numeric1	numeric(10,10)	null,
text2           varchar(255)    null,
real2           real            null,
numeric2        numeric(10,10)  null)
go

create index timestamp on entries(timestamp)
go

create index source on entries(source_id, timestamp)
go

\echo Setting rights on \\'entries\\'...
revoke all
on entries
to public
go

grant insert,select
on entries
to public
go


-- $Id: dbo_tables.sql,v 1.1 1999/12/10 04:04:36 decibel Exp $
--
-- Description
--
-- Revision history:
--
-- 19991125 - Built from structure captured through sp_help

print 'Creating table RC5_64_platform'
go
if object_id('RC5_64_platform') is not NULL
begin
	if (select rows from sysindexes where id = object_id('RC5_64_platform') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table RC5_64_platform
	end
end
go
create table RC5_64_platform
(
	cpu			int		not NULL,
	os			int		not NULL,
	ver			int		not NULL,
	date			smalldatetime	not NULL,
	blocks			numeric(9, 0)	not NULL
)
go
create clustered index osdate on RC5_64_platform(os, date) with allow_dup_row
go
create index cpudate on RC5_64_platform(cpu, date)
create index everything on RC5_64_platform(cpu, os, ver, date)
go

print 'Creating table RC5_64_master'
go
if object_id('RC5_64_master') is not NULL
begin
	if (select rows from sysindexes where id = object_id('RC5_64_master') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table RC5_64_master
	end
end
go
create table RC5_64_master
(
	id			numeric(7, 0)	not NULL,
	team			int		not NULL	default 0,
	date			smalldatetime	not NULL,
	blocks			numeric(7, 0)	not NULL
)
go
create index id on RC5_64_master(id)
create index team on RC5_64_master(team)
create index date on RC5_64_master(date)
go

print 'Creating table CSC_master'
go
if object_id('CSC_master') is not NULL
begin
	if (select rows from sysindexes where id = object_id('CSC_master') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table CSC_master
	end
end
go
create table CSC_master
(
	id			numeric(7, 0)	not NULL,
	team			int		not NULL	default 0,
	date			smalldatetime	not NULL,
	blocks			numeric(7, 0)	not NULL
)
go
create clustered index team on CSC_master(team) with allow_dup_row
go
create index id on CSC_master(id)
go

print 'Creating table CSC_dailies'
go
if object_id('CSC_dailies') is not NULL
begin
	if (select rows from sysindexes where id = object_id('CSC_dailies') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table CSC_dailies
	end
end
go
create table CSC_dailies
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
create index date on CSC_dailies(date)
create index top_oparticipant on CSC_dailies(top_oparticipant)
create index top_yparticipant on CSC_dailies(top_yparticipant)
create index top_oteam on CSC_dailies(top_oteam)
create index top_yteam on CSC_dailies(top_yteam)
go

print 'Creating table CSC_platform'
go
if object_id('CSC_platform') is not NULL
begin
	if (select rows from sysindexes where id = object_id('CSC_platform') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table CSC_platform
	end
end
go
create table CSC_platform
(
	cpu			int		not NULL,
	os			int		not NULL,
	ver			int		not NULL,
	date			smalldatetime	not NULL,
	blocks			numeric(7, 0)	not NULL
)
go
create clustered index osdate on CSC_platform(os, date) with allow_dup_row
go
create index cpudate on CSC_platform(cpu, date)
create index everything on CSC_platform(cpu, os, ver, date)
go

print 'Creating table OLD_master'
go
if object_id('OLD_master') is not NULL
begin
	if (select rows from sysindexes where id = object_id('OLD_master') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table OLD_master
	end
end
go
create table OLD_master
(
	id			numeric(7, 0)	not NULL,
	team			int		NULL,
	date			smalldatetime	not NULL,
	blocks			numeric(7, 0)	not NULL
)
go
print 'Finished.'

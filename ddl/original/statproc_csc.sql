-- $Id: statproc_csc.sql,v 1.1 1999/12/10 04:04:36 decibel Exp $
--
-- Revision history:
--
-- 11/25/1999	Created from output of sp_help

setuser statproc
go
print 'Creating table csc_daytable_master'
go
if object_id('csc_daytable_master') is not NULL
begin
	if (select rows from sysindexes where id = object_id('csc_daytable_master') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table csc_daytable_master
	end
end
go
create table csc_daytable_master
(
	timestamp		datetime	not NULL,
	email			char(64)	NULL,
	size			int		NULL	
)
go

print 'Creating table csc_daytable_platform'
go
if object_id('csc_daytable_platform') is not NULL
begin
	if (select rows from sysindexes where id = object_id('csc_daytable_platform') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table csc_daytable_platform
	end
end
go
create table csc_daytable_platform
(
	timestamp		datetime	not NULL,
	cpu			smallint	NULL,
	os			smallint	NULL,
	ver			smallint	NULL,
	size			int		NULL
)
go

print 'Creating table csc_CACHE_em_RANK'
go
if object_id('csc_CACHE_em_RANK') is not NULL
begin
	if (select rows from sysindexes where id = object_id('csc_CACHE_em_RANK') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table csc_CACHE_em_RANK
	end
end
go
create table csc_CACHE_em_RANK
(
	idx			numeric(10, 0)	not NULL	identity,
	id			numeric(10, 0)	NULL,
	email			varchar(64)	NULL,
	first			smalldatetime	NULL,
	last			smalldatetime	NULL,
	blocks			numeric(10, 0)	NULL,
	days_working		int		NULL,
	overall_rate		numeric(14, 4)	NULL,
	rank			int		NULL,
	change			int		NULL,
	listmode		int		NULL
)
go
create index id on csc_CACHE_em_RANK(id)
create index email on csc_CACHE_em_RANK(email)
go

print 'Creating table csc_CACHE_em_YRANK'
go
if object_id('csc_CACHE_em_YRANK') is not NULL
begin
	if (select rows from sysindexes where id = object_id('csc_CACHE_em_YRANK') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table csc_CACHE_em_YRANK
	end
end
go
create table csc_CACHE_em_YRANK
(
	idx			numeric(10, 0)	not NULL	identity,
	id			numeric(10, 0)	NULL,
	email			varchar(64)	NULL,
	first			smalldatetime	NULL,
	last			smalldatetime	NULL,
	blocks			numeric(10, 0)	NULL,
	days_working		int		NULL,
	overall_rate		numeric(14, 4)	NULL,
	rank			int		NULL,
	change			int		NULL,
	listmode		int		NULL
)
go
create index id on csc_CACHE_em_YRANK(id)
create index email on csc_CACHE_em_YRANK(id)
go


print 'Creating table csc_CACHE_tm_MEMBERS'
go
if object_id('csc_CACHE_tm_MEMBERS') is not NULL
begin
	if (select rows from sysindexes where id = object_id('csc_CACHE_tm_MEMBERS') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table csc_CACHE_tm_MEMBERS
	end
end
go
create table csc_CACHE_tm_MEMBERS
(
	id			numeric(10, 0)	not NULL,
	team			int		not NULL,
	first			smalldatetime	not NULL,
	last			smalldatetime	not NULL,
	blocks			numeric(10, 0)	not NULL	
)
go
create index main on csc_CACHE_tm_MEMBERS(team. blocks)
go

print 'Creating table csc_CACHE_tm_RANK'
go
if object_id('csc_CACHE_tm_RANK') is not NULL
begin
	if (select rows from sysindexes where id = object_id('csc_CACHE_tm_RANK') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table csc_CACHE_tm_RANK
	end
end
go
create table csc_CACHE_tm_RANK
(
	Idx			numeric(10, 0)	not NULL	identity,
	Team			numeric(10, 0)	NULL,
	Name			varchar(64)	NULL,
	First			smalldatetime	NULL,
	Last			smalldatetime	NULL,
	Blocks			numeric(10, 0)	NULL,
	Days_Working		int		NULL,
	Overall_Rate		numeric(14, 4)	NULL,
	Rank			int		NULL,
	Change			int		NULL,
	ListMode		int		NULL,
	CurrentMembers		int		NULL,
	ActiveMembers		int		NULL,
	TotalMembers		int		NULL
)
go
create index team on csc_CACHE_tm_RANK(Team)
go

print 'Creating table csc_CACHE_tm_YRANK'
go
if object_id('csc_CACHE_tm_YRANK') is not NULL
begin
	if (select rows from sysindexes where id = object_id('csc_CACHE_tm_YRANK') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table csc_CACHE_tm_YRANK
	end
end
go
create table csc_CACHE_tm_YRANK
(
	Idx			numeric(10, 0)	not NULL	identity,
	Team			numeric(10, 0)	NULL,
	Name			varchar(64)	NULL,
	First			smalldatetime	NULL,
	Last			smalldatetime	NULL,
	Blocks			numeric(10, 0)	NULL,
	Days_Working		int		NULL,
	Overall_Rate		numeric(14, 4)	NULL,
	Rank			int		NULL,
	Change			int		NULL,
	ListMode		int		NULL,
	CurrentMembers		int		NULL,
	ActiveMembers		int		NULL,
	TotalMembers		int		NULL
)
go
create index team on csc_CACHE_tm_YRANK(Team)
go

print 'Creating table csc_import'
go
if object_id('csc_import') is not NULL
begin
	if (select rows from sysindexes where id = object_id('csc_import') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table csc_import
	end
end
go
create table csc_import
(
	timestamp		datetime	not NULL,
	ip			char(15)	NULL,
	email			char(64)	NULL,
	blockid			char(24)	not NULL,
	size			int		NULL,
	os			int		NULL,
	cpu			int		NULL,
	ver			int		NULL	
)
go
print 'Creating table cimport'
go
if object_id('cimport') is not NULL
begin
	if (select rows from sysindexes where id = object_id('cimport') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table cimport
	end
end
go
create table cimport
(
	timestamp		datetime	not NULL,
	ip			char(15)	NULL,
	email			char(64)	NULL,
	blockid			char(24)	not NULL,
	size			int		NULL,
	os			int		NULL,
	cpu			int		NULL,
	ver			int		NULL	
)
go
create index if_new_table on cimport()
go


print 'Finished.'

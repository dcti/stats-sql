print 'Creating table Projects'
go
if object_id('Projects') is not NULL
begin
	drop table Projects
end
go
create table Projects
(
	PROJECT_ID		tinyint		not NULL,
	PROJECT_TYPE		varchar(10)	not NULL,
	NAME			varchar(40)	not NULL,
	STATUS			char(1)		not NULL,
/*
**	F = Future, O = Open, S = Suspended, V = Victory, D = Defeat, T = Timeout
**	C = Completed, no victory or defeat
*/
	START_DATE		smalldatetime	NULL,
	END_DATE		smalldatetime	NULL,
	DUE_DATE		smalldatetime	NULL,
	LAST_STATS_DATE		smalldatetime	NULL,
	PRIZE			money		not NULL,
	DESCRIPTION		varchar(255)	not NULL,
	DIST_UNIT_NAME		varchar(20)	not NULL,
	DIST_UNIT_QTY		numeric(20, 0)	not NULL,
	WORK_UNIT_NAME		varchar(20)	not NULL,
	WORK_UNIT_QTY		numeric(20, 0)	not NULL,
	SPONSOR_URL		varchar(255)	not NULL,
	SPONSOR_NAME		varchar(255)	not NULL,
	LOGO_URL		varchar(255)	not NULL
)
go
insert Projects
	values (3, 'RC5', 'RC5-56', 'V', NULL, NULL, NULL, NULL, 10000, 'RC5-56 contest',
			'blocks', power(2.0, 28), 'keys', power(2.0, 56),
			'http://www.rsa.com',
			'RSA Data Systems, Inc.',
			'http://stats.distributed.net/rc5-56/logo.gif')
go
insert Projects
	values (5, 'RC5', 'RC5-64', 'O', NULL, NULL, NULL, NULL, 10000, 'RC5-64 contest',
			'blocks', power(2.0, 36), 'keys', power(2.0, 64),
			'http://www.rsa.com',
			'RSA Data Systems, Inc.',
			'http://stats.distributed.net/rc5-64/logo.gif')
go
insert Projects
	values (6, 'CSC', 'CSC', 'V', NULL, NULL, NULL, NULL, 10000, 'CSC contest',
			'blocks', power(2.0, 28), 'keys', power(2.0, 56),
			'http://www.csc.com',
			'CS Communications, Inc.',
			'http://stats.distributed.net/csc/logo.gif')
go
insert Projects
	values (24, 'OGR', 'OGR-24', 'S', NULL, NULL, NULL, NULL, 0, 'Optimal Golumb Ruler with 24 marks',
			'stubs', 178000, 'nodes', 0,
			'', '',
			'http://stats.distributed.net/ogr-24/logo.gif')
go
create unique clustered index iNAME
	on Projects(NAME)
	with fillfactor = 75
go
alter table Projects
	add constraint pkProjects
	primary key nonclustered (PROJECT_ID)
	with fillfactor = 75
go
create index iPROJECT_TYPE
	on Projects(PROJECT_TYPE)
	with fillfactor = 75
go
print 'Finished.'
go

print 'Creating table RequestedEvents'
go
if object_id('RequestedEvents') is not NULL
begin
	if (select rows from sysindexes where id = object_id('RequestedEvents') and indid < 2) > 0
	begin
		print 'Not deleting - data exists'
	end
	else
	begin
		drop table RequestedEvents
	end
end
go
create table RequestedEvents
(
	SEQN		int		identity
		constraint pkRequestedEvents primary key nonclustered,
	REQUEST_DATE	datetime	not NULL,
	STATUS		tinyint		not NULL,
	PROJECT_ID	tinyint		not NULL,
	EVENT_TYPE	varchar(5)	not NULL,
	ID		int		not NULL,
	OLD_VALUE	int		not NULL,
	NEW_VALUE	int		not NULL
)
go

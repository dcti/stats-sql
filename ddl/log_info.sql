create table Log_Info (
PROJECT_ID	tinyint		NOT NULL,
LOG_TIMESTAMP	datetime	NOT NULL,
WORK_UNITS	numeric(20,0)	NOT NULL,
LINES		int		NOT NULL,
ERROR		bit		NOT NULL
)
go

alter table Log_Info
	add constraint LOG_TIME
	check (datepart(minute,LOG_TIMESTAMP)=0
		and datepart(second,LOG_TIMESTAMP)=0
		and datepart(millisecond,LOG_TIMESTAMP)=0
		)
go

create unique clustered index project_logtime
	on Log_Info(PROJECT_ID, LOG_TIMESTAMP)
go

grant select on log_info to public
go
grant insert on log_info to processing
go

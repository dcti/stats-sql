create table CSC_dailies
(
	date			date	not NULL,
	blocks			numeric(10,0)	not NULL,
	participants		int		not NULL,
	top_oparticipant	int		not NULL,
	top_opblocks		numeric(10,0)	not NULL,
	top_yparticipant	int		not NULL,
	top_ypblocks		numeric(10,0)	not NULL,
	teams			int		not NULL,
	top_oteam		int		not NULL,
	top_otblocks		numeric(10,0)	not NULL,
	top_yteam		int		not NULL,
	top_ytblocks		numeric(10,0)	not NULL
)
;
create table CSC_master
(
	id			numeric(7,0)	primary key,
	team			int		not NULL,
	date			date	not NULL,
	blocks			numeric(7,0)	not NULL
)
;
create table CSC_platform
(
	cpu			int		not NULL,
	os			int		not NULL,
	ver			int		not NULL,
	date			date	not NULL,
	blocks			numeric(7,0)	not NULL,
    primary key(cpu,os,ver,date)
)
;
create table Daily_Summary
(
	DATE			date	not NULL,
	PROJECT_ID		int2		not NULL,
	WORK_UNITS		numeric(20,0)	not NULL,
	PARTICIPANTS		int		not NULL,
	PARTICIPANTS_NEW	int		not NULL,
	TOP_OPARTICIPANT	int		not NULL,
	TOP_OPWORK		numeric(20,0)	not NULL,
	TOP_YPARTICIPANT	int		not NULL,
	TOP_YPWORK		numeric(20,0)	not NULL,
	TEAMS			int		not NULL,
	TEAMS_NEW		int		not NULL,
	TOP_OTEAM		int		not NULL,
	TOP_OTWORK		numeric(20,0)	not NULL,
	TOP_YTEAM		int		not NULL,
	TOP_YTWORK		numeric(20,0)	not NULL,
    primary key(date,project_id)
)
;
create table Email_Contrib
(
	ID			int		not NULL,
	TEAM_ID			int		not NULL,
	DATE			date	not NULL,
	PROJECT_ID		int2		not NULL,
	WORK_UNITS		numeric(20,0)	not NULL,
    primary key (project_id,id,date)
)
;
create table Email_Contrib_Last_Update
(
	PROJECT_ID		smallint	primary key,
	last_date		date	NULL
)
;
create table Email_Contrib_Today
(
	PROJECT_ID		int2		not NULL,
	ID			int		not NULL,
	TEAM_ID			int		not NULL,
	WORK_UNITS		numeric(20,0)	not NULL,
	CREDIT_ID		int		not NULL,
    primary key(project_id,id)
)
;
create table Email_Rank
(
	PROJECT_ID		int2		not NULL,
	ID			int		not NULL,
	FIRST_DATE		date	not NULL,
	LAST_DATE		date	not NULL,
	WORK_TODAY		numeric(20,0)	not NULL,
	WORK_TOTAL		numeric(20,0)	not NULL,
	DAY_RANK		int		not NULL,
	DAY_RANK_PREVIOUS	int		not NULL,
	OVERALL_RANK		int		not NULL,
	OVERALL_RANK_PREVIOUS	int		not NULL,
    primary key(project_id,id)
)
;
create table Email_Rank_Last_Update
(
	PROJECT_ID		smallint	primary key,
	last_date		date	NULL
)
;
create table Log_Info
(
	PROJECT_ID		int2		not NULL,
	LOG_TIMESTAMP		timestamp	not NULL,
	WORK_UNITS		numeric(20,0)	not NULL,
	LINES			int		not NULL,
	ERROR			bit		not NULL,
    primary key(project_id,log_timestamp)
)
;
create table Platform_Contrib
(
	PROJECT_ID		int2		not NULL,
	DATE			date	not NULL,
	CPU			smallint	not NULL,
	OS			smallint	not NULL,
	VER			smallint	not NULL,
	WORK_UNITS		numeric(20,0)	not NULL,
    primary key(project_id,cpu,os,ver,date)
)
;
create table Platform_Contrib_Last_Update
(
	PROJECT_ID		smallint	primary key,
	last_date		date	NULL
)
;
create table Platform_Contrib_Today
(
	PROJECT_ID		int2		not NULL,
	CPU			smallint	not NULL,
	OS			smallint	not NULL,
	VER			smallint	not NULL,
	WORK_UNITS		numeric(20,0)	not NULL
)
;
create table Platform_Summary
(
	PROJECT_ID		int2		not NULL,
	CPU			smallint	not NULL,
	OS			smallint	not NULL,
	VER			smallint	not NULL,
	FIRST_DATE		date	NULL,
	LAST_DATE		date	NULL,
	WORK_TODAY		numeric(38,0)	NULL,
	WORK_TOTAL		numeric(22,0)	NULL,
    primary key(project_id,cpu,os,ver)
)
;
create table Project_Status
(
	STATUS			char(1)		primary key,
	DESCRIPTION		varchar(115)	not NULL
)
;
create table Project_statsrun
(
	PROJECT_ID		int2		primary key,
	LAST_LOG		char(11)	not NULL,
	LOGS_FOR_DAY		int2		not NULL,
	WORK_FOR_DAY		numeric(20,0)	not NULL,
	LAST_HOURLY_DATE	date	NULL,
	LAST_MASTER_DATE	date	NULL,
	LAST_EMAIL_DATE		date	NULL,
	LAST_TEAM_DATE		date	NULL,
	LAST_SUMMARY_DATE	date	NULL
)
;
create table Projects
(
	PROJECT_ID		int2		primary key,
	PROJECT_TYPE		varchar(10)	not NULL,
	NAME			varchar(40)	constraint Projects__NAME unique not NULL,
	STATUS			char(1)		not NULL,
	START_DATE		date	NULL,
	END_DATE		date	NULL,
	DUE_DATE		date	NULL,
	PRIZE			numeric(38,2)		not NULL,
	DESCRIPTION		varchar(255)	not NULL,
	DIST_UNIT_QTY		numeric(38,0)	not NULL,
	DIST_UNIT_NAME		varchar(20)	not NULL,
	WORK_UNIT_QTY		numeric(38,0)	not NULL,
	WORK_UNIT_DISP_MULTIPLIER numeric(38,0)	not NULL,
	WORK_UNIT_DISP_DIVISOR	numeric(38,0)	not NULL,
	WORK_UNIT_IMPORT_MULTIPLIER numeric(38,0)	not NULL,
	UNSCALED_WORK_UNIT_NAME	varchar(20)	not NULL,
	SCALED_WORK_UNIT_NAME	varchar(20)	not NULL,
	LOGFILE_PREFIX		varchar(10)	not NULL,
	SPONSOR_URL		varchar(255)	not NULL,
	SPONSOR_NAME		varchar(255)	not NULL,
	LOGO_URL		varchar(255)	not NULL,
	deprecated_fields	char(1)		not NULL,
	WORK_UNIT_NAME		varchar(20)	not NULL,
	DIST_UNIT_SCALE		numeric(38,0)	not NULL,
	WORK_UNIT_SCALE		numeric(38,0)	not NULL
)
;
create table STATS_Participant
(
	id			numeric(10,0)	primary key,
	email			varchar(64)	constraint STATS_Participant__EMAIL unique not NULL,
	password		char(8)		not NULL,
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
	dem_heard		smallint	not NULL,
	dem_gender		char(1)		not NULL,
	dem_motivation		smallint	not NULL,
	dem_country		varchar(8)	not NULL,
	contact_name		varchar(50)	not NULL,
	contact_phone		varchar(20)	not NULL,
	motto			varchar(255)	not NULL,
	retire_date		date	NULL
)
;
create table STATS_Participant_Blocked
(
	ID			int		primary key
)
;
create table STATS_Participant_Friend
(
	id			int		not NULL,
	friend			int		not NULL,
    primary key(id,friend)
)
;
create table STATS_Participant_Listmode
(
	listmode		smallint	primary key,
	description		varchar(100)	constraint STATS_Participant_Listmode__description unique not NULL
)
;
create table STATS_Team_Blocked
(
	TEAM_ID			int		primary key
)
;
create table STATS_country
(
	country			char(64)	constraint STATS_country__country UNIQUE not NULL,
	code			char(2)		primary key
)
;
create table STATS_cpu
(
	cpu			int		primary key,
	name			char(32)	not NULL,
	image			char(64)	NULL,
	category		char(32)	NULL
)
;
create table STATS_dem_heard
(
	heard			smallint	primary key,
	description		varchar(100)	constraint STATS_dem_heard__description unique not NULL
)
;
create table STATS_dem_motivation
(
	motivation		smallint	primary key,
	description		varchar(100)	constraint STATS_dem_motivation__description unique not NULL
)
;
create table STATS_nonprofit
(
	nonprofit		int		primary key,
	name			char(64)	not NULL,
	url			char(64)	not NULL,
	comments		text		not NULL
)
;
create table STATS_os
(
	os			int		primary key,
	name			char(32)	not NULL,
	image			char(64)	NULL,
	category		char(32)	NULL
)
;
create table STATS_team
(
	team			numeric(10,0)	primary key,
	listmode		smallint	not NULL,
	password		char(8)		NULL,
	name			char(64)	constraint STATS_Team__name unique NOT NULL,
	url			char(128)	NULL,
	contactname		char(64)	NULL,
	contactemail		char(64)	NULL,
	logo			char(128)	NULL,
	showmembers		char(3)		NULL,
	showpassword		char(16)	NULL,
	description		text		NULL
)
;
create table Team_Joins
(
	id			int		not NULL,
	team_id			int		not NULL,
	join_date		date	not NULL,
	last_date		date	NULL,
	leave_team_id		int		not NULL,
    primary key(id,join_date,team_id)
)
;
create table Team_Members
(
	PROJECT_ID		int2		not NULL,
	ID			int		not NULL,
	TEAM_ID			int		not NULL,
	FIRST_DATE		date	not NULL,
	LAST_DATE		date	not NULL,
	WORK_TODAY		numeric(20,0)	not NULL,
	WORK_TOTAL		numeric(20,0)	not NULL,
	DAY_RANK		int		not NULL,
	DAY_RANK_PREVIOUS	int		not NULL,
	OVERALL_RANK		int		not NULL,
	OVERALL_RANK_PREVIOUS	int		not NULL,
    primary key(project_id,team_id,id)
)
;
create table Team_Members_Last_Update
(
	PROJECT_ID		smallint	primary key,
	last_date		date	NULL
)
;
create table Team_Rank
(
	PROJECT_ID		int2		not NULL,
	TEAM_ID			int		not NULL,
	FIRST_DATE		date	not NULL,
	LAST_DATE		date	not NULL,
	WORK_TODAY		numeric(20,0)	not NULL,
	WORK_TOTAL		numeric(20,0)	not NULL,
	DAY_RANK		int		not NULL,
	DAY_RANK_PREVIOUS	int		not NULL,
	OVERALL_RANK		int		not NULL,
	OVERALL_RANK_PREVIOUS	int		not NULL,
	MEMBERS_TODAY		int		not NULL,
	MEMBERS_OVERALL		int		not NULL,
	MEMBERS_CURRENT		int		not NULL,
    primary key(project_id,team_id)
)
;
create table Team_Rank_Last_Update
(
	PROJECT_ID		smallint	primary key,
	last_date		date	NULL
)
;
create table import_bcp
(
	TIME_STAMP		date	not NULL,
	EMAIL			varchar(64)	not NULL,
	PROJECT_ID		int2		not NULL,
	WORK_UNITS		numeric(20,0)	not NULL,
	OS			int		not NULL,
	CPU			int		not NULL,
	VER			int		not NULL
)
;
create table Email_Rank_Backup
(
	BACKUP_DATE		date	not NULL,
	project_id		int2		not NULL,
	id			int		not NULL,
	first_date		date	not NULL,
	last_date		date	not NULL,
	work_today		numeric(20,0)	not NULL,
	work_total		numeric(20,0)	not NULL,
	day_rank		int		not NULL,
	day_rank_previous	int		not NULL,
	overall_rank		int		not NULL,
	overall_rank_previous	int		not NULL
)
;
create table Team_Members_Backup
(
	BACKUP_DATE		date	not NULL,
	project_id		int2		not NULL,
	id			int		not NULL,
	team_id			int		not NULL,
	first_date		date	not NULL,
	last_date		date	not NULL,
	work_today		numeric(20,0)	not NULL,
	work_total		numeric(20,0)	not NULL,
	day_rank		int		not NULL,
	day_rank_previous	int		not NULL,
	overall_rank		int		not NULL,
	overall_rank_previous	int		not NULL
)
;
create table Team_Rank_Backup
(
	BACKUP_DATE		date	not NULL,
	project_id		int2		not NULL,
	team_id			int		not NULL,
	first_date		date	not NULL,
	last_date		date	not NULL,
	work_today		numeric(20,0)	not NULL,
	work_total		numeric(20,0)	not NULL,
	day_rank		int		not NULL,
	day_rank_previous	int		not NULL,
	overall_rank		int		not NULL,
	overall_rank_previous	int		not NULL,
	members_today		int		not NULL,
	members_overall		int		not NULL,
	members_current		int		not NULL
)
;
create table csc_CACHE_em_RANK
(
	idx			numeric(10,0)	not null,
	id			numeric(10,0)	NULL,
	email			varchar(64)	NULL,
	first			date	NULL,
	last			date	NULL,
	blocks			numeric(10,0)	NULL,
	days_working		int		NULL,
	overall_rate		numeric(14,4)	NULL,
	rank			int		NULL,
	change			int		NULL,
	listmode		int		NULL
)
;
create table csc_CACHE_em_YRANK
(
	idx			numeric(10,0)	not null,
	id			numeric(10,0)	NULL,
	email			varchar(64)	NULL,
	first			date	NULL,
	last			date	NULL,
	blocks			numeric(10,0)	NULL,
	days_working		int		NULL,
	overall_rate		numeric(14,4)	NULL,
	rank			int		NULL,
	change			int		NULL,
	listmode		int		NULL
)
;
create table csc_CACHE_tm_MEMBERS
(
	id			numeric(10,0)	not NULL,
	team			int		not NULL,
	first			date	not NULL,
	last			date	not NULL,
	blocks			numeric(10,0)	not NULL
)
;
create table csc_CACHE_tm_RANK
(
	Idx			numeric(10,0)	not null,
	Team			numeric(10,0)	NULL,
	Name			varchar(64)	NULL,
	First			date	NULL,
	Last			date	NULL,
	Blocks			numeric(10,0)	NULL,
	Days_Working		int		NULL,
	Overall_Rate		numeric(14,4)	NULL,
	Rank			int		NULL,
	Change			int		NULL,
	ListMode		int		NULL,
	CurrentMembers		int		NULL,
	ActiveMembers		int		NULL,
	TotalMembers		int		NULL
)
;
create table csc_CACHE_tm_YRANK
(
	Idx			numeric(10,0)	not null,
	Team			numeric(10,0)	NULL,
	Name			varchar(64)	NULL,
	First			date	NULL,
	Last			date	NULL,
	Blocks			numeric(10,0)	NULL,
	Days_Working		int		NULL,
	Overall_Rate		numeric(14,4)	NULL,
	Rank			int		NULL,
	Change			int		NULL,
	ListMode		int		NULL,
	CurrentMembers		int		NULL,
	ActiveMembers		int		NULL,
	TotalMembers		int		NULL
)
;
create table csc_daytable_master
(
	timestamp		timestamp	not NULL,
	email			char(64)	NULL,
	size			int		NULL
)
;
create table csc_daytable_platform
(
	timestamp		timestamp	not NULL,
	cpu			smallint	NULL,
	os			smallint	NULL,
	ver			smallint	NULL,
	size			int		NULL
)
;

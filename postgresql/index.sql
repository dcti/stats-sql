create unique  index CSC_master__id_date on CSC_master (
 id
, date
)
;
 
create index CSC_master__team_date on CSC_master(
 team
, date
)
;
 
create  index CSC_platform__os_date on CSC_platform(
 os
, date
) 
;
 
create index CSC_platform__cpu_date on csc_platform(
 cpu
, date
) 
;
 
create index Email_Contrib_Today__TEAM_ID on Email_Contrib_Today (
 PROJECT_ID
, TEAM_ID
)
;
 
 
create index Email_Rank__DAY_RANK on Email_Rank (
 PROJECT_ID
, DAY_RANK
)
;
 
create index Email_Rank__OVERALL_RANK on Email_Rank (
 PROJECT_ID
, OVERALL_RANK
)
;
 
 
create index Platform_Contrib__ProjectDate on Platform_Contrib (
 PROJECT_ID
, DATE
)
;
 
 
create index Projects__PROJECT_TYPE on Projects (
 PROJECT_TYPE
)
;
 

create index STATS_Participant__ParticipantTEAM on STATS_Participant (
 team
)
;
 
create unique index STATS_Participant__ID_LISTMODE on STATS_Participant (
 id
, listmode
)
;
 
create unique index STATS_Participant__EMAILid on STATS_Participant (
 email
, id
)
;
 
create unique index STATS_Participant__ParticipantRETIRE_ID on STATS_Participant (
 retire_to
, id
)
;
 
create unique index STATS_Participant__ID_RETIRE_LISTMODE on STATS_Participant (
 id
, retire_to
, listmode
)
;
 
create index STATS_Participant__LISTMODE on STATS_Participant (
 listmode
)
;
 
create index STATS_Participant__DEM_HEARD on STATS_Participant (
 dem_heard
)
;
 
create index STATS_Participant__DEM_MOTIVATION on STATS_Participant (
 dem_motivation
)
;
 
create index STATS_Participant__DEM_COUNTRY on STATS_Participant (
 dem_country
)
;
 
create index STATS_Participant_Friend__Friend on STATS_Participant_Friend (
 friend
)
;
 


 



create unique index STATS_team__TEAM_LISTMODE on STATS_team (
 team
, listmode
)
;
 

create index Team_Joins__JOIN on Team_Joins (
 join_date
)
;
 
create index Team_Joins__JOIN_last on Team_Joins (
 join_date
, last_date
)
;
 

create index Team_Joins__DAY_RANK on Team_Rank (
 DAY_RANK
)
;
 
create index Team_Joins__OVERALL_RANK on Team_Rank (
 OVERALL_RANK
)
;
 

create  index rank on csc_CACHE_em_RANK (
 rank
)
;
 
create unique index csc_CACHE_em_RANK__id on csc_CACHE_em_RANK (
 id
)
;
 
create  index csc_CACHE_em_YRANK__rank on csc_CACHE_em_YRANK (
 rank
)
;
 
create unique index csc_CACHE_em_YRANK__id on csc_CACHE_em_YRANK (
 id
)
;
 
create index csc_CACHE_tm_MEMBERS__team_blocks on csc_CACHE_tm_MEMBERS (
 team
, blocks
)
;
 
create index csc_CACHE_tm_RANK__team on csc_CACHE_tm_RANK (
 Team
)
;
 
create index csc_CACHE_tm_YRANK__team on csc_CACHE_tm_YRANK (
 Team
)
;
 

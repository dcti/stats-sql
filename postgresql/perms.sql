\set ON_ERROR_STOP 1

 create group processing;
 create group backup;
 create group www;
 create group wheel;
 create group helpdesk;
 create group coder;
 grant Select on csc_CACHE_tm_MEMBERS to public;
 grant Select on STATS_Team_Blocked to public;
 grant Insert on STATS_Team_Blocked to group processing;
 grant Delete on STATS_Team_Blocked to group processing;
 grant Select on csc_CACHE_tm_RANK to public;
 grant Select on csc_CACHE_tm_YRANK to public;
 grant Select on Email_Contrib to public;
 grant Insert on Email_Contrib to group processing;
 grant Update on Email_Contrib to group processing;
 grant Select on csc_daytable_master to public;
 grant Select on csc_daytable_platform to public;
 grant Select on Platform_Summary to public;
 grant Insert on Platform_Summary to group processing;
 grant Delete on Platform_Summary to group processing;
 grant Update on Platform_Summary to group processing;
 grant Select on Projects to public;
 grant Select on STATS_Participant_Friend to public;
 grant Select on Email_Contrib_Last_Update to public;
 grant Update on Email_Contrib_Last_Update to group processing;
 grant Select on STATS_dem_heard to group backup;
 grant Select on STATS_dem_motivation to group backup;
 grant Select on Log_Info to public;
 grant Insert on Log_Info to group processing;
 grant Select on Email_Rank_Last_Update to public;
 grant Update on Email_Rank_Last_Update to group processing;
 grant Select on Team_Rank_Last_Update to public;
 grant Update on Team_Rank_Last_Update to group processing;
 grant Select on Team_Members_Last_Update to public;
 grant Update on Team_Members_Last_Update to group processing;
 grant Select on CSC_dailies to public;
 grant Select on Project_Status to public;
 grant Select on CSC_master to public;
 grant Select on CSC_platform to public;
 grant Select on Platform_Contrib_Last_Update to public;
 grant Update on Platform_Contrib_Last_Update to group processing;
 grant Select on Daily_Summary to public;
 grant Insert on Daily_Summary to group processing;
 grant Update on Daily_Summary to group processing;
 grant Select on Email_Contrib_Today to public;
 grant Insert on Email_Contrib_Today to group processing;
 grant Insert on Email_Contrib_Today to group wheel;
 grant Delete on Email_Contrib_Today to group processing;
 grant Delete on Email_Contrib_Today to group wheel;
 grant Update on Email_Contrib_Today to group processing;
 grant Update on Email_Contrib_Today to group wheel;
 grant Select on Email_Rank to public;
 grant Insert on Email_Rank to group processing;
 grant Insert on Email_Rank to group wheel;
 grant Delete on Email_Rank to group processing;
 grant Delete on Email_Rank to group wheel;
 grant Update on Email_Rank to group processing;
 grant Update on Email_Rank to group wheel;
 grant Select on Platform_Contrib to public;
 grant Insert on Platform_Contrib to group processing;
 grant Select on Platform_Contrib_Today to public;
 grant Insert on Platform_Contrib_Today to group processing;
 grant Insert on Platform_Contrib_Today to group wheel;
 grant Delete on Platform_Contrib_Today to group processing;
 grant Delete on Platform_Contrib_Today to group wheel;
 grant Update on Platform_Contrib_Today to group processing;
 grant Update on Platform_Contrib_Today to group wheel;
 grant Select on STATS_country to public;
 grant Select on STATS_cpu to public;
 grant Select on Project_statsrun to group backup;
 grant Select on Project_statsrun to group processing;
 grant Select on Project_statsrun to group wheel;
 grant Insert on Project_statsrun to group processing;
 grant Insert on Project_statsrun to group wheel;
 grant Update on Project_statsrun to group processing;
 grant Update on Project_statsrun to group wheel;
 grant Select on STATS_nonprofit to public;
 grant Select on STATS_os to public;
 grant Select on Team_Joins to public;
 grant Select on STATS_Participant to public;
 grant Insert on STATS_Participant to group processing;
 grant Update on STATS_Participant to group coder;
 grant Update on STATS_Participant to group helpdesk;
 grant Update on STATS_Participant to group www;
 grant Update on STATS_Participant to group wheel;
 grant Select on Team_Members to public;
 grant Insert on Team_Members to group processing;
 grant Insert on Team_Members to group wheel;
 grant Delete on Team_Members to group processing;
 grant Delete on Team_Members to group wheel;
 grant Update on Team_Members to group processing;
 grant Update on Team_Members to group wheel;
 grant Select on Team_Rank to public;
 grant Insert on Team_Rank to group processing;
 grant Insert on Team_Rank to group wheel;
 grant Delete on Team_Rank to group processing;
 grant Delete on Team_Rank to group wheel;
 grant Update on Team_Rank to group processing;
 grant Update on Team_Rank to group wheel;
 grant Select on STATS_team to public;
 grant Insert on STATS_team to group www;
 grant Update on STATS_team to group coder;
 grant Update on STATS_team to group helpdesk;
 grant Update on STATS_team to group www;
 grant Update on STATS_team to group wheel;
 grant Select on import_bcp to group backup;
 grant Select on import_bcp to group processing;
 grant Select on import_bcp to group wheel;
 grant Insert on import_bcp to group processing;
 grant Delete on import_bcp to group processing;
 grant Update on import_bcp to group processing;
 grant Select on csc_CACHE_em_RANK to public;
 grant Select on csc_CACHE_em_YRANK to public;
 grant Select on STATS_Participant_Blocked to public;
 grant Insert on STATS_Participant_Blocked to group processing;
 grant Delete on STATS_Participant_Blocked to group processing;

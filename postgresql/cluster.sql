-- $Id: cluster.sql,v 1.7 2003/04/14 21:19:03 decibel Exp $

\set ON_ERROR_STOP 1

select now() as start into temp start_time;
\t
select '$File:$ start time: ' || start from start_time;
\t

CLUSTER CSC_master_pkey ON CSC_master;
CLUSTER csc_platform_pkey ON CSC_platform;
CLUSTER Daily_Summary_pkey ON Daily_Summary;
CLUSTER Project_Last_Date_pkey ON Email_Contrib_Last_Update;
CLUSTER Email_Contrib_Today_pkey ON Email_Contrib_Today;
CLUSTER Project_Last_Date_pkey ON Email_Rank_Last_Update;
CLUSTER project_logtime ON Log_Info;
CLUSTER Project_Last_Date_pkey ON Platform_Contrib_Last_Update;
CLUSTER Platform_Summary_pkey ON Platform_Summary;
CLUSTER project_status_pkey ON Project_Status;
CLUSTER Project_statsrun_pkey ON Project_statsrun;
CLUSTER Projects_pkey ON Projects;
CLUSTER stats_participant_blocked_pkey ON STATS_Participant_Blocked;
CLUSTER stats_participant_friend_pkey ON STATS_Participant_Friend;
CLUSTER stats_participant_listmode_pkey ON STATS_Participant_LISTMODE;
CLUSTER stats_team_blocked_pkey ON STATS_Team_Blocked;
CLUSTER stats_cpu_pkey ON STATS_cpu;
CLUSTER stats_dem_pkey ON STATS_dem_heard;
CLUSTER stats_dem_motivation_pkey ON STATS_dem_motivation;
CLUSTER stats_os_pkey ON STATS_os;
CLUSTER Team_Joins_pkey ON Team_Joins;
CLUSTER team_members_pkey ON Team_Members;
CLUSTER Team_Rank_pkey ON Team_Rank;
CLUSTER rank ON csc_CACHE_em_RANK;
CLUSTER rank ON csc_CACHE_em_YRANK;
CLUSTER rank ON csc_CACHE_tm_RANK;
CLUSTER rank ON csc_CACHE_tm_YRANK;

\t
select '$File:$ stop time: ' || now() || ', duration: ' || age(now(),start) from start_time;

COPY CSC_dailies FROM '/home/decibel/blower/CSC_dailies.bcp' WITH DELIMITER '\t';
COPY CSC_master FROM '/home/decibel/blower/CSC_master.bcp' WITH DELIMITER '\t';
COPY CSC_platform FROM '/home/decibel/blower/CSC_platform.bcp' WITH DELIMITER '\t';

COPY Daily_Summary (DATE, PROJECT_ID, WORK_UNITS, PARTICIPANTS, PARTICIPANTS_NEW, TOP_OPARTICIPANT, TOP_OPWORK, TOP_YPARTICIPANT, TOP_YPWORK, TEAMS, TEAMS_NEW, TOP_OTEAM, TOP_OTWORK, TOP_YTEAM, TOP_YTWORK) FROM '/home/decibel/blower/Daily_Summary.bcp' WITH DELIMITER '\t';

COPY Email_Contrib (ID, TEAM_ID, DATE, PROJECT_ID, WORK_UNITS) FROM '/home/decibel/blower/Email_Contrib.bcp' WITH DELIMITER '\t';

COPY Email_Contrib_Today (PROJECT_ID, ID, TEAM_ID, WORK_UNITS, CREDIT_ID) FROM '/home/decibel/blower/Email_Contrib_Today.bcp' WITH DELIMITER '\t';

COPY Email_Contrib_Last_Update FROM '/home/decibel/blower/Email_Contrib_Last_Update.bcp' WITH DELIMITER '\t' NULL '';

COPY Email_Rank (PROJECT_ID, ID, FIRST_DATE, LAST_DATE, WORK_TODAY, WORK_TOTAL, DAY_RANK, DAY_RANK_PREVIOUS, OVERALL_RANK, OVERALL_RANK_PREVIOUS) FROM '/home/decibel/blower/Email_Rank.bcp' WITH DELIMITER '\t';

COPY Email_Rank_Last_Update FROM '/home/decibel/blower/Email_Rank_Last_Update.bcp' WITH DELIMITER '\t' NULL '';

COPY Platform_Contrib (PROJECT_ID, DATE, CPU, OS, VER, WORK_UNITS) FROM '/home/decibel/blower/Platform_Contrib.bcp' WITH DELIMITER '\t';

COPY Platform_Contrib_Today (project_id, cpu, os, ver, vork_units) FROM '/home/decibel/blower/Platform_Contrib_Today.bcp' WITH DELIMITER '\t';

COPY Platform_Contrib_Last_Update FROM '/home/decibel/blower/Platform_Contrib_Last_Update.bcp' WITH DELIMITER '\t' NULL '';

COPY Platform_Summary (PROJECT_ID, CPU, OS, VER, FIRST_DATE, LAST_DATE, WORK_TODAY, WORK_TOTAL) FROM '/home/decibel/blower/Platform_Summary.bcp' WITH DELIMITER '\t';

COPY Project_Status FROM '/home/decibel/blower/Project_Status.bcp' WITH DELIMITER '\t';

COPY Project_statsrun FROM '/home/decibel/blower/Project_statsrun.bcp' WITH DELIMITER '\t' NULL '';

COPY Projects (PROJECT_ID, PROJECT_TYPE, NAME, STATUS, START_DATE, END_DATE, DUE_DATE, PRIZE, DESCRIPTION, DIST_UNIT_QTY, DIST_UNIT_NAME, WORK_UNIT_QTY, WORK_UNIT_DISP_MULTIPLIERnumeric(38,0), WORK_UNIT_DISP_DIVISOR, WORK_UNIT_IMPORT_MULTIPLIERnumeric(38,0), UNSCALED_WORK_UNIT_NAME, SCALED_WORK_UNIT_NAME, LOGFILE_PREFIX, SPONSOR_URL, SPONSOR_NAME, LOGO_URL) FROM '/home/decibel/blower/Projects.bcp' WITH DELIMITER '\t' NULL '';

COPY Log_Info (PROJECT_ID, LOG_TIMESTAMP, WORK_UNITS, LINES, ERROR) FROM '/home/decibel/blower/Log_Info.bcp.clean' WITH DELIMITER '\t' NULL '';

COPY STATS_Participant_Blocked FROM '/home/decibel/blower/STATS_Participant_Blocked.bcp' WITH DELIMITER '\t';

COPY STATS_Participant_Friend FROM '/home/decibel/blower/STATS_Participant_Friend.bcp' WITH DELIMITER '\t';

COPY STATS_Team_Blocked FROM '/home/decibel/blower/STATS_Team_Blocked.bcp' WITH DELIMITER '\t';

COPY STATS_country(country,code) FROM '/home/decibel/blower/STATS_country.bcp' WITH DELIMITER '\t';

COPY STATS_cpu FROM '/home/decibel/blower/STATS_cpu.bcp' WITH DELIMITER '\t' NULL '';

COPY STATS_dem_heard FROM '/home/decibel/blower/STATS_dem_heard.bcp' WITH DELIMITER '\t';

COPY STATS_dem_motivation FROM '/home/decibel/blower/STATS_dem_motivation.bcp' WITH DELIMITER '\t';

COPY STATS_nonprofit FROM '/home/decibel/blower/STATS_nonprofit.bcp' WITH DELIMITER '\t';

COPY STATS_os FROM '/home/decibel/blower/STATS_os.bcp' WITH DELIMITER '\t' NULL '';

COPY Team_Joins FROM '/home/decibel/blower/Team_Joins.bcp' WITH DELIMITER '\t' NULL '';

COPY Team_Members (PROJECT_ID, ID, TEAM_ID, FIRST_DATE, LAST_DATE, WORK_TODAY, WORK_TOTAL, DAY_RANK, DAY_RANK_PREVIOUS, OVERALL_RANK, OVERALL_RANK_PREVIOUS) FROM '/home/decibel/blower/Team_Members.bcp' WITH DELIMITER '\t';

COPY Team_Members_Last_Update FROM '/home/decibel/blower/Team_Members_Last_Update.bcp' WITH DELIMITER '\t' NULL '';

COPY Team_Rank (PROJECT_ID, TEAM_ID, FIRST_DATE, LAST_DATE, WORK_TODAY, WORK_TOTAL, DAY_RANK, DAY_RANK_PREVIOUS, OVERALL_RANK, OVERALL_RANK_PREVIOUS, MEMBERS_TODAY, MEMBERS_OVERALL, MEMBERS_CURRENT) FROM '/home/decibel/blower/Team_Rank.bcp' WITH DELIMITER '\t';

COPY Team_Rank_Last_Update FROM '/home/decibel/blower/Team_Rank_Last_Update.bcp' WITH DELIMITER '\t' NULL '';

COPY csc_CACHE_em_RANK FROM '/home/decibel/blower/statproc.csc_CACHE_em_RANK.bcp' WITH DELIMITER '\t' NULL '';

COPY csc_CACHE_em_YRANK FROM '/home/decibel/blower/statproc.csc_CACHE_em_YRANK.bcp' WITH DELIMITER '\t' NULL '';

COPY csc_CACHE_tm_MEMBERS FROM '/home/decibel/blower/statproc.csc_CACHE_tm_MEMBERS.bcp' WITH DELIMITER '\t';

COPY csc_CACHE_tm_RANK FROM '/home/decibel/blower/statproc.csc_CACHE_tm_RANK.bcp' WITH DELIMITER '\t' NULL '';

COPY csc_CACHE_tm_YRANK FROM '/home/decibel/blower/statproc.csc_CACHE_tm_YRANK.bcp' WITH DELIMITER '\t' NULL '';

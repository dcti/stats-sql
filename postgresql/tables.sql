-- $Id: tables.sql,v 1.5 2003/04/05 00:14:13 decibel Exp $
-- Create all table, but without indexes or primary keys

CREATE TABLE csc_dailies (
    date date NOT NULL,
    blocks int NOT NULL,
    participants integer NOT NULL,
    top_oparticipant integer NOT NULL,
    top_opblocks int NOT NULL,
    top_yparticipant integer NOT NULL,
    top_ypblocks int NOT NULL,
    teams integer NOT NULL,
    top_oteam integer NOT NULL,
    top_otblocks int NOT NULL,
    top_yteam integer NOT NULL,
    top_ytblocks int NOT NULL
) WITHOUT OIDS;



CREATE TABLE csc_master (
    id int NOT NULL,
    team integer NOT NULL,
    date date NOT NULL,
    blocks numeric(7,0) NOT NULL
) WITHOUT OIDS;



CREATE TABLE csc_platform (
    cpu integer NOT NULL,
    os integer NOT NULL,
    ver integer NOT NULL,
    date date NOT NULL,
    blocks numeric(7,0) NOT NULL
) WITHOUT OIDS;



CREATE TABLE daily_summary (
    date date NOT NULL,
    project_id smallint NOT NULL,
    work_units numeric(20,0) NOT NULL,
    participants integer NOT NULL,
    participants_new integer NOT NULL,
    top_oparticipant integer NOT NULL,
    top_opwork numeric(20,0) NOT NULL,
    top_yparticipant integer NOT NULL,
    top_ypwork numeric(20,0) NOT NULL,
    teams integer NOT NULL,
    teams_new integer NOT NULL,
    top_oteam integer NOT NULL,
    top_otwork numeric(20,0) NOT NULL,
    top_yteam integer NOT NULL,
    top_ytwork numeric(20,0) NOT NULL
) WITHOUT OIDS;



CREATE TABLE email_contrib (
    id integer NOT NULL,
    team_id integer NOT NULL,
    date date NOT NULL,
    project_id smallint NOT NULL,
    work_units numeric(20,0) NOT NULL
) WITHOUT OIDS;



CREATE TABLE email_contrib_last_update (
    project_id smallint NOT NULL,
    last_date date
) WITHOUT OIDS;



CREATE TABLE email_contrib_today (
    project_id smallint NOT NULL,
    id integer NOT NULL,
    team_id integer NOT NULL,
    work_units numeric(20,0) NOT NULL,
    credit_id integer NOT NULL
) WITHOUT OIDS;



CREATE TABLE email_rank (
    project_id smallint NOT NULL,
    id integer NOT NULL,
    first_date date NOT NULL,
    last_date date NOT NULL,
    work_today numeric(20,0) NOT NULL,
    work_total numeric(20,0) NOT NULL,
    day_rank integer NOT NULL,
    day_rank_previous integer NOT NULL,
    overall_rank integer NOT NULL,
    overall_rank_previous integer NOT NULL
) WITHOUT OIDS;



CREATE TABLE email_rank_last_update (
    project_id smallint NOT NULL,
    last_date date
) WITHOUT OIDS;



CREATE TABLE log_info (
    project_id smallint NOT NULL,
    log_timestamp timestamp without time zone NOT NULL,
    work_units numeric(20,0) NOT NULL,
    lines integer NOT NULL,
    error bit(1) NOT NULL
) WITHOUT OIDS;



CREATE TABLE platform_contrib (
    project_id smallint NOT NULL,
    date date NOT NULL,
    cpu smallint NOT NULL,
    os smallint NOT NULL,
    ver smallint NOT NULL,
    work_units numeric(20,0) NOT NULL
) WITHOUT OIDS;



CREATE TABLE platform_contrib_last_update (
    project_id smallint NOT NULL,
    last_date date
) WITHOUT OIDS;



CREATE TABLE platform_contrib_today (
    project_id smallint NOT NULL,
    cpu smallint NOT NULL,
    os smallint NOT NULL,
    ver smallint NOT NULL,
    work_units numeric(20,0) NOT NULL
) WITHOUT OIDS;



CREATE TABLE platform_summary (
    project_id smallint NOT NULL,
    cpu smallint NOT NULL,
    os smallint NOT NULL,
    ver smallint NOT NULL,
    first_date date NOT NULL,
    last_date date NOT NULL,
    work_today numeric(38,0) NOT NULL,
    work_total numeric(22,0) NOT NULL
) WITHOUT OIDS;



CREATE TABLE project_status (
    status character(1) NOT NULL,
    description character varying(115) NOT NULL
) WITHOUT OIDS;



CREATE TABLE project_statsrun (
    project_id smallint NOT NULL,
    last_log character(11) NOT NULL,
    logs_for_day smallint NOT NULL,
    work_for_day numeric(20,0) NOT NULL,
    last_hourly_date date,
    last_master_date date,
    last_email_date date,
    last_team_date date,
    last_summary_date date
) WITHOUT OIDS;



CREATE TABLE projects (
    project_id smallint NOT NULL,
    project_type character varying(10) NOT NULL,
    name character varying(40) NOT NULL,
    status character(1) NOT NULL,
    start_date date,
    end_date date,
    due_date date,
    prize numeric(38,2) NOT NULL,
    description character varying(255) NOT NULL,
    dist_unit_qty numeric(38,0) NOT NULL,
    dist_unit_name character varying(20) NOT NULL,
    work_unit_qty numeric(38,0) NOT NULL,
    work_unit_disp_multiplier numeric(38,0) NOT NULL,
    work_unit_disp_divisor numeric(38,0) NOT NULL,
    work_unit_import_multiplier numeric(38,0) NOT NULL,
    unscaled_work_unit_name character varying(20) NOT NULL,
    scaled_work_unit_name character varying(20) NOT NULL,
    logfile_prefix character varying(10) NOT NULL,
    sponsor_url character varying(255) NOT NULL,
    sponsor_name character varying(255) NOT NULL,
    logo_url character varying(255) NOT NULL,
    deprecated_fields character(1) NOT NULL,
    work_unit_name character varying(20) NOT NULL,
    dist_unit_scale numeric(38,0) NOT NULL,
    work_unit_scale numeric(38,0) NOT NULL
) WITHOUT OIDS;



CREATE TABLE stats_participant (
    id int NOT NULL,
    email character varying(64) NOT NULL,
    "password" character(8) NOT NULL,
    listmode smallint NOT NULL,
    nonprofit smallint NOT NULL,
    team integer NOT NULL,
    retire_to integer NOT NULL,
    friend_a integer NOT NULL,
    friend_b integer NOT NULL,
    friend_c integer NOT NULL,
    friend_d integer NOT NULL,
    friend_e integer NOT NULL,
    dem_yob integer NOT NULL,
    dem_heard smallint NOT NULL,
    dem_gender character(1) NOT NULL,
    dem_motivation smallint NOT NULL,
    dem_country character varying(8) NOT NULL,
    contact_name character varying(50) NOT NULL,
    contact_phone character varying(20) NOT NULL,
    motto character varying(255) NOT NULL,
    retire_date date
) WITHOUT OIDS;



CREATE TABLE stats_participant_blocked (
    id integer NOT NULL
) WITHOUT OIDS;



CREATE TABLE stats_participant_friend (
    id integer NOT NULL,
    friend integer NOT NULL
) WITHOUT OIDS;



CREATE TABLE stats_participant_listmode (
    listmode smallint NOT NULL,
    description character varying(100) NOT NULL
) WITHOUT OIDS;



CREATE TABLE stats_team_blocked (
    team_id integer NOT NULL
) WITHOUT OIDS;



CREATE TABLE stats_country (
    country character(64) NOT NULL,
    code character(2) NOT NULL
) WITHOUT OIDS;



CREATE TABLE stats_cpu (
    cpu integer NOT NULL,
    name character(32) NOT NULL,
    image character(64),
    category character(32)
) WITHOUT OIDS;



CREATE TABLE stats_dem_heard (
    heard smallint NOT NULL,
    description character varying(100) NOT NULL
) WITHOUT OIDS;



CREATE TABLE stats_dem_motivation (
    motivation smallint NOT NULL,
    description character varying(100) NOT NULL
) WITHOUT OIDS;



CREATE TABLE stats_nonprofit (
    nonprofit integer NOT NULL,
    name character(64) NOT NULL,
    url character(64) NOT NULL,
    comments text NOT NULL
) WITHOUT OIDS;



CREATE TABLE stats_os (
    os integer NOT NULL,
    name character(32) NOT NULL,
    image character(64),
    category character(32)
) WITHOUT OIDS;



CREATE TABLE stats_team (
    team int NOT NULL,
    listmode smallint NOT NULL,
    "password" character(8),
    name character(64) NOT NULL,
    url character(128),
    contactname character(64),
    contactemail character(64),
    logo character(128),
    showmembers character(3),
    showpassword character(16),
    description text
) WITHOUT OIDS;



CREATE TABLE team_joins (
    id integer NOT NULL,
    team_id integer NOT NULL,
    join_date date NOT NULL,
    last_date date,
    leave_team_id integer NOT NULL
) WITHOUT OIDS;



CREATE TABLE team_members (
    project_id smallint NOT NULL,
    id integer NOT NULL,
    team_id integer NOT NULL,
    first_date date NOT NULL,
    last_date date NOT NULL,
    work_today numeric(20,0) NOT NULL,
    work_total numeric(20,0) NOT NULL,
    day_rank integer NOT NULL,
    day_rank_previous integer NOT NULL,
    overall_rank integer NOT NULL,
    overall_rank_previous integer NOT NULL
) WITHOUT OIDS;



CREATE TABLE team_members_last_update (
    project_id smallint NOT NULL,
    last_date date
) WITHOUT OIDS;



CREATE TABLE team_rank (
    project_id smallint NOT NULL,
    team_id integer NOT NULL,
    first_date date NOT NULL,
    last_date date NOT NULL,
    work_today numeric(20,0) NOT NULL,
    work_total numeric(20,0) NOT NULL,
    day_rank integer NOT NULL,
    day_rank_previous integer NOT NULL,
    overall_rank integer NOT NULL,
    overall_rank_previous integer NOT NULL,
    members_today integer NOT NULL,
    members_overall integer NOT NULL,
    members_current integer NOT NULL
) WITHOUT OIDS;



CREATE TABLE team_rank_last_update (
    project_id smallint NOT NULL,
    last_date date
) WITHOUT OIDS;



CREATE TABLE import_bcp (
    time_stamp date NOT NULL,
    email character varying(64) NOT NULL,
    project_id smallint NOT NULL,
    work_units numeric(20,0) NOT NULL,
    os integer NOT NULL,
    cpu integer NOT NULL,
    ver integer NOT NULL
) WITHOUT OIDS;



CREATE TABLE email_rank_backup (
    backup_date date NOT NULL,
    project_id smallint NOT NULL,
    id integer NOT NULL,
    first_date date NOT NULL,
    last_date date NOT NULL,
    work_today numeric(20,0) NOT NULL,
    work_total numeric(20,0) NOT NULL,
    day_rank integer NOT NULL,
    day_rank_previous integer NOT NULL,
    overall_rank integer NOT NULL,
    overall_rank_previous integer NOT NULL
) WITHOUT OIDS;



CREATE TABLE team_members_backup (
    backup_date date NOT NULL,
    project_id smallint NOT NULL,
    id integer NOT NULL,
    team_id integer NOT NULL,
    first_date date NOT NULL,
    last_date date NOT NULL,
    work_today numeric(20,0) NOT NULL,
    work_total numeric(20,0) NOT NULL,
    day_rank integer NOT NULL,
    day_rank_previous integer NOT NULL,
    overall_rank integer NOT NULL,
    overall_rank_previous integer NOT NULL
) WITHOUT OIDS;



CREATE TABLE team_rank_backup (
    backup_date date NOT NULL,
    project_id smallint NOT NULL,
    team_id integer NOT NULL,
    first_date date NOT NULL,
    last_date date NOT NULL,
    work_today numeric(20,0) NOT NULL,
    work_total numeric(20,0) NOT NULL,
    day_rank integer NOT NULL,
    day_rank_previous integer NOT NULL,
    overall_rank integer NOT NULL,
    overall_rank_previous integer NOT NULL,
    members_today integer NOT NULL,
    members_overall integer NOT NULL,
    members_current integer NOT NULL
) WITHOUT OIDS;



CREATE TABLE csc_cache_em_rank (
    idx int NOT NULL,
    id int,
    email character varying(64),
    first date,
    last date,
    blocks int,
    days_working integer,
    overall_rate numeric(14,4),
    rank integer,
    change integer,
    listmode integer
) WITHOUT OIDS;



CREATE TABLE csc_cache_em_yrank (
    idx int NOT NULL,
    id int,
    email character varying(64),
    first date,
    last date,
    blocks int,
    days_working integer,
    overall_rate numeric(14,4),
    rank integer,
    change integer,
    listmode integer
) WITHOUT OIDS;



CREATE TABLE csc_cache_tm_members (
    id int NOT NULL,
    team integer NOT NULL,
    first date NOT NULL,
    last date NOT NULL,
    blocks int NOT NULL
) WITHOUT OIDS;



CREATE TABLE csc_cache_tm_rank (
    idx int NOT NULL,
    team int,
    name character varying(64),
    first date,
    last date,
    blocks int,
    days_working integer,
    overall_rate numeric(14,4),
    rank integer,
    change integer,
    listmode integer,
    currentmembers integer,
    activemembers integer,
    totalmembers integer
) WITHOUT OIDS;



CREATE TABLE csc_cache_tm_yrank (
    idx int NOT NULL,
    team int,
    name character varying(64),
    first date,
    last date,
    blocks int,
    days_working integer,
    overall_rate numeric(14,4),
    rank integer,
    change integer,
    listmode integer,
    currentmembers integer,
    activemembers integer,
    totalmembers integer
) WITHOUT OIDS;



CREATE TABLE csc_daytable_master (
    "timestamp" timestamp without time zone NOT NULL,
    email character(64),
    size integer
) WITHOUT OIDS;



CREATE TABLE csc_daytable_platform (
    "timestamp" timestamp without time zone NOT NULL,
    cpu smallint,
    os smallint,
    ver smallint,
    size integer
) WITHOUT OIDS;

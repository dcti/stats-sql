-- $Id: schema_dump.sql,v 1.3 2003/04/05 00:30:04 decibel Exp $
-- dump of stats database via pg_dump -s
-- using this as template for table and index creation (table.sql and index.sql)

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
    "password" character(8) NOT NULL DEFAULT '',
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



CREATE UNIQUE INDEX csc_master__id_date ON csc_master USING btree (id, date);



CREATE INDEX csc_master__team_date ON csc_master USING btree (team, date);



CREATE INDEX csc_platform__os_date ON csc_platform USING btree (os, date);



CREATE INDEX csc_platform__cpu_date ON csc_platform USING btree (cpu, date);



CREATE INDEX email_contrib_today__team_id ON email_contrib_today USING btree (project_id, team_id);



CREATE INDEX email_rank__day_rank ON email_rank USING btree (project_id, day_rank);



CREATE INDEX email_rank__overall_rank ON email_rank USING btree (project_id, overall_rank);



CREATE INDEX platform_contrib__projectdate ON platform_contrib USING btree (project_id, date);



CREATE INDEX projects__project_type ON projects USING btree (project_type);



CREATE INDEX stats_participant__participantteam ON stats_participant USING btree (team);



CREATE UNIQUE INDEX stats_participant__id_listmode ON stats_participant USING btree (id, listmode);



CREATE UNIQUE INDEX stats_participant__emailid ON stats_participant USING btree (email, id);



CREATE UNIQUE INDEX stats_participant__participantretire_id ON stats_participant USING btree (retire_to, id);



CREATE UNIQUE INDEX stats_participant__id_retire_listmode ON stats_participant USING btree (id, retire_to, listmode);



CREATE INDEX stats_participant__listmode ON stats_participant USING btree (listmode);



CREATE INDEX stats_participant__dem_heard ON stats_participant USING btree (dem_heard);



CREATE INDEX stats_participant__dem_motivation ON stats_participant USING btree (dem_motivation);



CREATE INDEX stats_participant__dem_country ON stats_participant USING btree (dem_country);



CREATE INDEX stats_participant_friend__friend ON stats_participant_friend USING btree (friend);



CREATE UNIQUE INDEX stats_team__team_listmode ON stats_team USING btree (team, listmode);



CREATE INDEX team_joins__join ON team_joins USING btree (join_date);



CREATE INDEX team_joins__join_last ON team_joins USING btree (join_date, last_date);



CREATE INDEX team_joins__day_rank ON team_rank USING btree (day_rank);



CREATE INDEX team_joins__overall_rank ON team_rank USING btree (overall_rank);



CREATE INDEX rank ON csc_cache_em_rank USING btree (rank);



CREATE UNIQUE INDEX csc_cache_em_rank__id ON csc_cache_em_rank USING btree (id);



CREATE INDEX csc_cache_em_yrank__rank ON csc_cache_em_yrank USING btree (rank);



CREATE UNIQUE INDEX csc_cache_em_yrank__id ON csc_cache_em_yrank USING btree (id);



CREATE INDEX csc_cache_tm_members__team_blocks ON csc_cache_tm_members USING btree (team, blocks);



CREATE INDEX csc_cache_tm_rank__team ON csc_cache_tm_rank USING btree (team);



CREATE INDEX csc_cache_tm_yrank__team ON csc_cache_tm_yrank USING btree (team);



ALTER TABLE ONLY csc_master
    ADD CONSTRAINT csc_master_pkey PRIMARY KEY (id, date);



ALTER TABLE ONLY csc_platform
    ADD CONSTRAINT csc_platform_pkey PRIMARY KEY (cpu, os, ver, date);



ALTER TABLE ONLY daily_summary
    ADD CONSTRAINT daily_summary_pkey PRIMARY KEY (date, project_id);



ALTER TABLE ONLY email_contrib
    ADD CONSTRAINT email_contrib_pkey PRIMARY KEY (project_id, id, date);



ALTER TABLE ONLY email_contrib_last_update
    ADD CONSTRAINT email_contrib_last_update_pkey PRIMARY KEY (project_id);



ALTER TABLE ONLY email_contrib_today
    ADD CONSTRAINT email_contrib_today_pkey PRIMARY KEY (project_id, id);



ALTER TABLE ONLY email_rank
    ADD CONSTRAINT email_rank_pkey PRIMARY KEY (project_id, id);



ALTER TABLE ONLY email_rank_last_update
    ADD CONSTRAINT email_rank_last_update_pkey PRIMARY KEY (project_id);



ALTER TABLE ONLY log_info
    ADD CONSTRAINT log_info_pkey PRIMARY KEY (project_id, log_timestamp);



ALTER TABLE ONLY platform_contrib
    ADD CONSTRAINT platform_contrib_pkey PRIMARY KEY (project_id, cpu, os, ver, date);



ALTER TABLE ONLY platform_contrib_last_update
    ADD CONSTRAINT platform_contrib_last_update_pkey PRIMARY KEY (project_id);



ALTER TABLE ONLY platform_summary
    ADD CONSTRAINT platform_summary_pkey PRIMARY KEY (project_id, cpu, os, ver);



ALTER TABLE ONLY project_status
    ADD CONSTRAINT project_status_pkey PRIMARY KEY (status);



ALTER TABLE ONLY project_statsrun
    ADD CONSTRAINT project_statsrun_pkey PRIMARY KEY (project_id);



ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (project_id);



ALTER TABLE ONLY projects
    ADD CONSTRAINT projects__name UNIQUE (name);



ALTER TABLE ONLY stats_participant
    ADD CONSTRAINT stats_participant_pkey PRIMARY KEY (id);



ALTER TABLE ONLY stats_participant
    ADD CONSTRAINT stats_participant__email UNIQUE (email);



ALTER TABLE ONLY stats_participant_blocked
    ADD CONSTRAINT stats_participant_blocked_pkey PRIMARY KEY (id);



ALTER TABLE ONLY stats_participant_friend
    ADD CONSTRAINT stats_participant_friend_pkey PRIMARY KEY (id, friend);



ALTER TABLE ONLY stats_participant_listmode
    ADD CONSTRAINT stats_participant_listmode_pkey PRIMARY KEY (listmode);



ALTER TABLE ONLY stats_participant_listmode
    ADD CONSTRAINT stats_participant_listmode__description UNIQUE (description);



ALTER TABLE ONLY stats_team_blocked
    ADD CONSTRAINT stats_team_blocked_pkey PRIMARY KEY (team_id);



ALTER TABLE ONLY stats_country
    ADD CONSTRAINT stats_country_pkey PRIMARY KEY (code);



ALTER TABLE ONLY stats_country
    ADD CONSTRAINT stats_country__country UNIQUE (country);



ALTER TABLE ONLY stats_cpu
    ADD CONSTRAINT stats_cpu_pkey PRIMARY KEY (cpu);



ALTER TABLE ONLY stats_dem_heard
    ADD CONSTRAINT stats_dem_heard_pkey PRIMARY KEY (heard);



ALTER TABLE ONLY stats_dem_heard
    ADD CONSTRAINT stats_dem_heard__description UNIQUE (description);



ALTER TABLE ONLY stats_dem_motivation
    ADD CONSTRAINT stats_dem_motivation_pkey PRIMARY KEY (motivation);



ALTER TABLE ONLY stats_dem_motivation
    ADD CONSTRAINT stats_dem_motivation__description UNIQUE (description);



ALTER TABLE ONLY stats_nonprofit
    ADD CONSTRAINT stats_nonprofit_pkey PRIMARY KEY (nonprofit);



ALTER TABLE ONLY stats_os
    ADD CONSTRAINT stats_os_pkey PRIMARY KEY (os);



ALTER TABLE ONLY stats_team
    ADD CONSTRAINT stats_team_pkey PRIMARY KEY (team);



ALTER TABLE ONLY stats_team
    ADD CONSTRAINT stats_team__name UNIQUE (name);



ALTER TABLE ONLY team_joins
    ADD CONSTRAINT team_joins_pkey PRIMARY KEY (id, join_date, team_id);



ALTER TABLE ONLY team_members
    ADD CONSTRAINT team_members_pkey PRIMARY KEY (project_id, team_id, id);



ALTER TABLE ONLY team_members_last_update
    ADD CONSTRAINT team_members_last_update_pkey PRIMARY KEY (project_id);



ALTER TABLE ONLY team_rank
    ADD CONSTRAINT team_rank_pkey PRIMARY KEY (project_id, team_id);



ALTER TABLE ONLY team_rank_last_update
    ADD CONSTRAINT team_rank_last_update_pkey PRIMARY KEY (project_id);



-- $Id: index.sql,v 1.4 2003/04/14 19:26:44 decibel Exp $
-- All indices.  Also includes creating primary keys, as creating
-- the primary key implies creating an index

\set ON_ERROR_STOP 1

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



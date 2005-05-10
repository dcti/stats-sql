--
-- PostgreSQL database dump
--

SET SESSION AUTHORIZATION 'pgsql';

SET search_path = public, pg_catalog;

--
-- TOC entry 192 (OID 59259816)
-- Name: plpgsql_call_handler (); Type: FUNCTION; Schema: public; Owner: pgsql
--

CREATE FUNCTION plpgsql_call_handler () RETURNS language_handler
    AS '$libdir/plpgsql', 'plpgsql_call_handler'
    LANGUAGE c;


--
-- TOC entry 186 (OID 59259817)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: public; Owner: 
--

CREATE TRUSTED PROCEDURAL LANGUAGE plpgsql HANDLER plpgsql_call_handler;


--
-- TOC entry 8 (OID 699664229)
-- Name: daily_summary; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE daily_summary (
    date date NOT NULL,
    project_id integer NOT NULL,
    participants integer NOT NULL,
    participants_new integer NOT NULL,
    top_oparticipant integer ,
    top_yparticipant integer ,
    teams integer NOT NULL,
    teams_new integer NOT NULL,
    top_oteam integer ,
    top_yteam integer ,
    work_units bigint NOT NULL,
    top_opwork bigint ,
    top_otwork bigint ,
    top_ypwork bigint ,
    top_ytwork bigint 
) WITHOUT OIDS;


--
-- TOC entry 9 (OID 699664229)
-- Name: daily_summary; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE daily_summary FROM PUBLIC;
GRANT SELECT ON TABLE daily_summary TO PUBLIC;
GRANT INSERT,UPDATE ON TABLE daily_summary TO GROUP processing;


--
-- TOC entry 10 (OID 699664231)
-- Name: email_contrib; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE email_contrib (
    project_id integer NOT NULL,
    id integer NOT NULL,
    date date NOT NULL,
    team_id integer,
    work_units bigint NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 11 (OID 699664231)
-- Name: email_contrib; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE email_contrib FROM PUBLIC;
GRANT SELECT ON TABLE email_contrib TO PUBLIC;
GRANT INSERT,UPDATE ON TABLE email_contrib TO GROUP processing;


--
-- TOC entry 12 (OID 699664233)
-- Name: email_contrib_last_update; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE email_contrib_last_update (
    project_id integer NOT NULL,
    last_date date
) WITHOUT OIDS;


--
-- TOC entry 13 (OID 699664233)
-- Name: email_contrib_last_update; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE email_contrib_last_update FROM PUBLIC;
GRANT SELECT ON TABLE email_contrib_last_update TO PUBLIC;
GRANT INSERT,UPDATE ON TABLE email_contrib_last_update TO GROUP processing;


--
-- TOC entry 14 (OID 699664235)
-- Name: email_contrib_today; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE email_contrib_today (
    project_id integer NOT NULL,
    id integer NOT NULL,
    team_id integer,
    credit_id integer NOT NULL,
    work_units bigint NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 15 (OID 699664235)
-- Name: email_contrib_today; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE email_contrib_today FROM PUBLIC;
GRANT SELECT ON TABLE email_contrib_today TO PUBLIC;
GRANT INSERT,UPDATE,DELETE ON TABLE email_contrib_today TO GROUP processing;
GRANT INSERT,UPDATE,DELETE ON TABLE email_contrib_today TO GROUP wheel;


--
-- TOC entry 16 (OID 699664237)
-- Name: email_rank; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE email_rank (
    project_id integer NOT NULL,
    id integer NOT NULL,
    first_date date NOT NULL,
    last_date date NOT NULL,
    day_rank integer DEFAULT 0 NOT NULL,
    day_rank_previous integer DEFAULT 0 NOT NULL,
    overall_rank integer DEFAULT 0 NOT NULL,
    overall_rank_previous integer DEFAULT 0 NOT NULL,
    work_today bigint DEFAULT 0 NOT NULL,
    work_total bigint DEFAULT 0 NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 17 (OID 699664237)
-- Name: email_rank; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE email_rank FROM PUBLIC;
GRANT SELECT ON TABLE email_rank TO PUBLIC;
GRANT INSERT,UPDATE,DELETE ON TABLE email_rank TO GROUP processing;
GRANT INSERT,UPDATE,DELETE ON TABLE email_rank TO GROUP wheel;


--
-- TOC entry 18 (OID 699664245)
-- Name: email_rank_last_update; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE email_rank_last_update (
    project_id integer NOT NULL,
    last_date date
) WITHOUT OIDS;


--
-- TOC entry 19 (OID 699664245)
-- Name: email_rank_last_update; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE email_rank_last_update FROM PUBLIC;
GRANT SELECT ON TABLE email_rank_last_update TO PUBLIC;
GRANT INSERT,UPDATE ON TABLE email_rank_last_update TO GROUP processing;


--
-- TOC entry 20 (OID 699664247)
-- Name: log_info; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE log_info (
    error bit(1) NOT NULL,
    project_id integer NOT NULL,
    lines integer NOT NULL,
    log_timestamp timestamp without time zone NOT NULL,
    work_units bigint NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 21 (OID 699664247)
-- Name: log_info; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE log_info FROM PUBLIC;
GRANT SELECT ON TABLE log_info TO PUBLIC;
GRANT INSERT ON TABLE log_info TO GROUP processing;


--
-- TOC entry 22 (OID 699664249)
-- Name: platform_contrib; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE platform_contrib (
    cpu smallint NOT NULL,
    os smallint NOT NULL,
    ver smallint NOT NULL,
    project_id integer NOT NULL,
    date date NOT NULL,
    work_units bigint NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 23 (OID 699664249)
-- Name: platform_contrib; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE platform_contrib FROM PUBLIC;
GRANT SELECT ON TABLE platform_contrib TO PUBLIC;
GRANT INSERT ON TABLE platform_contrib TO GROUP processing;


--
-- TOC entry 24 (OID 699664251)
-- Name: platform_contrib_last_update; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE platform_contrib_last_update (
    project_id integer NOT NULL,
    last_date date
) WITHOUT OIDS;


--
-- TOC entry 25 (OID 699664251)
-- Name: platform_contrib_last_update; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE platform_contrib_last_update FROM PUBLIC;
GRANT SELECT ON TABLE platform_contrib_last_update TO PUBLIC;
GRANT INSERT,UPDATE ON TABLE platform_contrib_last_update TO GROUP processing;


--
-- TOC entry 26 (OID 699664253)
-- Name: platform_contrib_today; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE platform_contrib_today (
    cpu smallint NOT NULL,
    os smallint NOT NULL,
    ver smallint NOT NULL,
    project_id integer NOT NULL,
    work_units bigint NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 27 (OID 699664253)
-- Name: platform_contrib_today; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE platform_contrib_today FROM PUBLIC;
GRANT SELECT ON TABLE platform_contrib_today TO PUBLIC;
GRANT INSERT,UPDATE,DELETE ON TABLE platform_contrib_today TO GROUP processing;
GRANT INSERT,UPDATE,DELETE ON TABLE platform_contrib_today TO GROUP wheel;


--
-- TOC entry 28 (OID 699664255)
-- Name: platform_summary; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE platform_summary (
    cpu smallint NOT NULL,
    os smallint NOT NULL,
    ver smallint NOT NULL,
    project_id integer NOT NULL,
    first_date date NOT NULL,
    last_date date NOT NULL,
    work_today bigint NOT NULL,
    work_total numeric(24,0) NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 29 (OID 699664255)
-- Name: platform_summary; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE platform_summary FROM PUBLIC;
GRANT SELECT ON TABLE platform_summary TO PUBLIC;
GRANT INSERT,UPDATE,DELETE ON TABLE platform_summary TO GROUP processing;


--
-- TOC entry 30 (OID 699664257)
-- Name: project_status; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE project_status (
    created timestamptz NOT NULL
    , updated timestamptz NOT NULL
    , status character(1) NOT NULL
    , description character varying(115) NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 31 (OID 699664257)
-- Name: project_status; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE project_status FROM PUBLIC;
GRANT SELECT ON TABLE project_status TO PUBLIC;


--
-- TOC entry 32 (OID 699664259)
-- Name: project_statsrun; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE project_statsrun (
    project_id integer NOT NULL,
    last_log character(11) DEFAULT '' NOT NULL,
    logs_for_day smallint DEFAULT 0 NOT NULL,
    work_for_day bigint DEFAULT 0 NOT NULL,
    last_date date
) WITHOUT OIDS;


--
-- TOC entry 33 (OID 699664259)
-- Name: project_statsrun; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE project_statsrun FROM PUBLIC;
GRANT INSERT,SELECT,UPDATE ON TABLE project_statsrun TO GROUP processing;
GRANT SELECT ON TABLE project_statsrun TO GROUP backup;
GRANT INSERT,SELECT,UPDATE ON TABLE project_statsrun TO GROUP wheel;


--
-- TOC entry 34 (OID 699664264)
-- Name: projects; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE projects (
    status character(1) NOT NULL,
    project_id integer NOT NULL,
    start_date date,
    end_date date,
    due_date date,
    project_type character varying(10) NOT NULL,
    name character varying(40) NOT NULL,
    prize numeric(16,2) NOT NULL,
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
    logo_url character varying(255) NOT NULL
    , created timestamptz NOT NULL
    , updated timestamptz NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 35 (OID 699664264)
-- Name: projects; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE projects FROM PUBLIC;
GRANT SELECT ON TABLE projects TO PUBLIC;


--
-- TOC entry 36 (OID 699664266)
-- Name: stats_participant_blocked; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE stats_participant_blocked (
    id integer NOT NULL
    , block_date date NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 37 (OID 699664266)
-- Name: stats_participant_blocked; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE stats_participant_blocked FROM PUBLIC;
GRANT SELECT ON TABLE stats_participant_blocked TO PUBLIC;
GRANT INSERT,DELETE ON TABLE stats_participant_blocked TO GROUP processing;


--
-- TOC entry 38 (OID 699664268)
-- Name: stats_participant_friend; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE stats_participant_friend (
    id integer NOT NULL,
    friend integer NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 39 (OID 699664268)
-- Name: stats_participant_friend; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE stats_participant_friend FROM PUBLIC;
GRANT SELECT ON TABLE stats_participant_friend TO PUBLIC;
GRANT INSERT,DELETE ON TABLE stats_participant_friend TO GROUP www;


--
-- TOC entry 40 (OID 699664270)
-- Name: stats_participant_listmode; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE stats_participant_listmode (
    listmode smallint NOT NULL,
    description character varying(100) NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 41 (OID 699664270)
-- Name: stats_participant_listmode; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE stats_participant_listmode FROM PUBLIC;
GRANT SELECT ON TABLE stats_participant_listmode TO PUBLIC;


--
-- TOC entry 42 (OID 699664272)
-- Name: stats_team_blocked; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE stats_team_blocked (
    team_id integer NOT NULL
    , block_date date NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 43 (OID 699664272)
-- Name: stats_team_blocked; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE stats_team_blocked FROM PUBLIC;
GRANT SELECT ON TABLE stats_team_blocked TO PUBLIC;
GRANT INSERT,DELETE ON TABLE stats_team_blocked TO GROUP processing;


--
-- TOC entry 44 (OID 699664274)
-- Name: stats_country; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE stats_country (
    created timestamptz NOT NULL
    , updated timestamptz NOT NULL
    , code character(2) NOT NULL
    , country character varying(64) NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 45 (OID 699664274)
-- Name: stats_country; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE stats_country FROM PUBLIC;
GRANT SELECT ON TABLE stats_country TO PUBLIC;


--
-- TOC entry 46 (OID 699664276)
-- Name: stats_cpu; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE stats_cpu (
    cpu integer NOT NULL
    , created timestamptz NOT NULL
    , updated timestamptz NOT NULL
    , name character varying(32) NOT NULL
    , image character varying(64)
    , category character varying(32)
) WITHOUT OIDS;


--
-- TOC entry 47 (OID 699664276)
-- Name: stats_cpu; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE stats_cpu FROM PUBLIC;
GRANT SELECT ON TABLE stats_cpu TO PUBLIC;


--
-- TOC entry 48 (OID 699664278)
-- Name: stats_dem_heard; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE stats_dem_heard (
    heard smallint NOT NULL
    , created timestamptz NOT NULL
    , updated timestamptz NOT NULL
    , description character varying(100) NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 49 (OID 699664278)
-- Name: stats_dem_heard; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE stats_dem_heard FROM PUBLIC;
GRANT SELECT ON TABLE stats_dem_heard TO GROUP backup;


--
-- TOC entry 50 (OID 699664280)
-- Name: stats_dem_motivation; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE stats_dem_motivation (
    motivation smallint NOT NULL
    , created timestamptz NOT NULL
    , updated timestamptz NOT NULL
    , description character varying(100) NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 51 (OID 699664280)
-- Name: stats_dem_motivation; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE stats_dem_motivation FROM PUBLIC;
GRANT SELECT ON TABLE stats_dem_motivation TO GROUP backup;


--
-- TOC entry 52 (OID 699664282)
-- Name: stats_nonprofit; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE stats_nonprofit (
    nonprofit integer NOT NULL
    , created timestamptz NOT NULL
    , updated timestamptz NOT NULL
    , name character varying(64) NOT NULL
    , url character varying(64) NOT NULL
    , comments text NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 53 (OID 699664282)
-- Name: stats_nonprofit; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE stats_nonprofit FROM PUBLIC;
GRANT SELECT ON TABLE stats_nonprofit TO PUBLIC;


--
-- TOC entry 54 (OID 699664287)
-- Name: stats_os; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE stats_os (
    os integer NOT NULL
    , created timestamptz NOT NULL
    , updated timestamptz NOT NULL
    , name character varying(32) NOT NULL
    , image character varying(64)
    , category character varying(32)
) WITHOUT OIDS;


--
-- TOC entry 55 (OID 699664287)
-- Name: stats_os; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE stats_os FROM PUBLIC;
GRANT SELECT ON TABLE stats_os TO PUBLIC;


--
-- TOC entry 56 (OID 699664289)
-- Name: team_joins; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE team_joins (
    id integer NOT NULL,
    team_id integer NOT NULL,
    join_date date NOT NULL,
    last_date date,
    leave_team_id integer DEFAULT 0 NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 57 (OID 699664289)
-- Name: team_joins; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE team_joins FROM PUBLIC;
GRANT SELECT ON TABLE team_joins TO PUBLIC;
GRANT INSERT,UPDATE,DELETE ON TABLE team_joins TO GROUP www;


--
-- TOC entry 58 (OID 699664292)
-- Name: team_members; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE team_members (
    project_id integer NOT NULL,
    id integer NOT NULL,
    team_id integer NOT NULL,
    first_date date NOT NULL,
    last_date date NOT NULL,
    day_rank integer DEFAULT 0 NOT NULL,
    day_rank_previous integer DEFAULT 0 NOT NULL,
    overall_rank integer DEFAULT 0 NOT NULL,
    overall_rank_previous integer DEFAULT 0 NOT NULL,
    work_today bigint DEFAULT 0 NOT NULL,
    work_total bigint DEFAULT 0 NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 59 (OID 699664292)
-- Name: team_members; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE team_members FROM PUBLIC;
GRANT SELECT ON TABLE team_members TO PUBLIC;
GRANT INSERT,UPDATE,DELETE ON TABLE team_members TO GROUP processing;
GRANT INSERT,UPDATE,DELETE ON TABLE team_members TO GROUP wheel;


--
-- TOC entry 60 (OID 699664300)
-- Name: team_members_last_update; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE team_members_last_update (
    project_id integer NOT NULL,
    last_date date
) WITHOUT OIDS;


--
-- TOC entry 61 (OID 699664300)
-- Name: team_members_last_update; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE team_members_last_update FROM PUBLIC;
GRANT SELECT ON TABLE team_members_last_update TO PUBLIC;
GRANT INSERT,UPDATE ON TABLE team_members_last_update TO GROUP processing;


--
-- TOC entry 62 (OID 699664302)
-- Name: team_rank; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE team_rank (
    project_id integer NOT NULL,
    team_id integer NOT NULL,
    first_date date NOT NULL,
    last_date date NOT NULL,
    day_rank integer DEFAULT 0 NOT NULL,
    day_rank_previous integer DEFAULT 0 NOT NULL,
    overall_rank integer DEFAULT 0 NOT NULL,
    overall_rank_previous integer DEFAULT 0 NOT NULL,
    members_today integer DEFAULT 0 NOT NULL,
    members_overall integer DEFAULT 0 NOT NULL,
    members_current integer DEFAULT 0 NOT NULL,
    work_today bigint DEFAULT 0 NOT NULL,
    work_total bigint DEFAULT 0 NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 63 (OID 699664302)
-- Name: team_rank; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE team_rank FROM PUBLIC;
GRANT SELECT ON TABLE team_rank TO PUBLIC;
GRANT INSERT,UPDATE,DELETE ON TABLE team_rank TO GROUP processing;
GRANT INSERT,UPDATE,DELETE ON TABLE team_rank TO GROUP wheel;


--
-- TOC entry 64 (OID 699664313)
-- Name: team_rank_last_update; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE team_rank_last_update (
    project_id integer NOT NULL,
    last_date date
) WITHOUT OIDS;


--
-- TOC entry 65 (OID 699664313)
-- Name: team_rank_last_update; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE team_rank_last_update FROM PUBLIC;
GRANT SELECT ON TABLE team_rank_last_update TO PUBLIC;
GRANT INSERT,UPDATE ON TABLE team_rank_last_update TO GROUP processing;


SET SESSION AUTHORIZATION 'statproc';

--
-- TOC entry 66 (OID 699664315)
-- Name: import_bcp; Type: TABLE; Schema: public; Owner: statproc
--

CREATE TABLE import_bcp (
    time_stamp date NOT NULL,
    email character varying(64) NOT NULL,
    project_id integer NOT NULL,
    work_units bigint NOT NULL,
    os integer NOT NULL,
    cpu integer NOT NULL,
    ver integer NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 67 (OID 699664315)
-- Name: import_bcp; Type: ACL; Schema: public; Owner: statproc
--

REVOKE ALL ON TABLE import_bcp FROM PUBLIC;
GRANT ALL ON TABLE import_bcp TO pgsql;
GRANT INSERT,SELECT,UPDATE,DELETE ON TABLE import_bcp TO GROUP processing;
GRANT SELECT ON TABLE import_bcp TO GROUP backup;
GRANT SELECT ON TABLE import_bcp TO GROUP wheel;
REVOKE ALL ON TABLE import_bcp FROM statproc;


SET SESSION AUTHORIZATION 'pgsql';

--
-- TOC entry 68 (OID 699664317)
-- Name: email_rank_backup; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE email_rank_backup (
    backup_date date NOT NULL,
    project_id integer NOT NULL,
    id integer NOT NULL,
    first_date date NOT NULL,
    last_date date NOT NULL,
    day_rank integer NOT NULL,
    day_rank_previous integer NOT NULL,
    overall_rank integer NOT NULL,
    overall_rank_previous integer NOT NULL,
    work_today bigint NOT NULL,
    work_total bigint NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 69 (OID 699664317)
-- Name: email_rank_backup; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE email_rank_backup FROM PUBLIC;
GRANT INSERT,SELECT,DELETE ON TABLE email_rank_backup TO GROUP processing;


--
-- TOC entry 70 (OID 699664319)
-- Name: team_members_backup; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE team_members_backup (
    backup_date date NOT NULL,
    project_id integer NOT NULL,
    id integer NOT NULL,
    team_id integer NOT NULL,
    first_date date NOT NULL,
    last_date date NOT NULL,
    day_rank integer NOT NULL,
    day_rank_previous integer NOT NULL,
    overall_rank integer NOT NULL,
    overall_rank_previous integer NOT NULL,
    work_today bigint NOT NULL,
    work_total bigint NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 71 (OID 699664319)
-- Name: team_members_backup; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE team_members_backup FROM PUBLIC;
GRANT INSERT,SELECT,DELETE ON TABLE team_members_backup TO GROUP processing;


--
-- TOC entry 72 (OID 699664321)
-- Name: team_rank_backup; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE team_rank_backup (
    backup_date date NOT NULL,
    project_id integer NOT NULL,
    team_id integer NOT NULL,
    first_date date NOT NULL,
    last_date date NOT NULL,
    day_rank integer NOT NULL,
    day_rank_previous integer NOT NULL,
    overall_rank integer NOT NULL,
    overall_rank_previous integer NOT NULL,
    members_today integer NOT NULL,
    members_overall integer NOT NULL,
    members_current integer NOT NULL,
    work_today bigint NOT NULL,
    work_total bigint NOT NULL
) WITHOUT OIDS;


--
-- TOC entry 73 (OID 699664321)
-- Name: team_rank_backup; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE team_rank_backup FROM PUBLIC;
GRANT INSERT,SELECT,DELETE ON TABLE team_rank_backup TO GROUP processing;


--
-- TOC entry 187 (OID 699664337)
-- Name: stats_get_max_rank_participant (); Type: FUNCTION; Schema: public; Owner: pgsql
--

CREATE FUNCTION stats_get_max_rank_participant () RETURNS integer
    AS '
    DECLARE
        max_rank int;
    BEGIN
        SELECT max(id) INTO max_rank
            FROM stats_participant
            WHERE retire_to = 0 OR retire_to IS NULL
        ;

        RETURN max_rank;
    END;
    '
    LANGUAGE plpgsql STABLE;


--
-- TOC entry 188 (OID 699664338)
-- Name: stats_get_max_rank_team (); Type: FUNCTION; Schema: public; Owner: pgsql
--

CREATE FUNCTION stats_get_max_rank_team () RETURNS integer
    AS '
    DECLARE
        max_rank int;
    BEGIN
        SELECT count(*) INTO max_rank
            FROM stats_team
        ;

        RETURN max_rank;
    END;
    '
    LANGUAGE plpgsql STABLE;


--
-- TOC entry 189 (OID 699664339)
-- Name: stats_get_last_update (integer, character); Type: FUNCTION; Schema: public; Owner: pgsql
--

CREATE FUNCTION stats_get_last_update (integer, character) RETURNS date
    AS '
    DECLARE
        function_name CONSTANT varchar(50) := ''stats_get_last_update'';
        function_args CONSTANT varchar(50) := ''(project_id, table_code)'';

        project_id ALIAS FOR $1;
        table_code ALIAS FOR $2;

        last_update date;
        REC_update RECORD;

        table_name varchar(50);
        statement varchar(500);
    BEGIN
        IF project_id IS NULL THEN
            RAISE EXCEPTION ''NULL project_id passed to %%'', function_name, function_args;
        END IF;

        table_name :=
            CASE
                WHEN table_code = ''s'' THEN ''project_statsrun''
                WHEN table_code = ''e'' THEN ''email_rank_last_update''
                WHEN table_code = ''t'' THEN ''team_rank_last_update''
                WHEN table_code = ''m'' THEN ''team_members_last_update''
                WHEN table_code = ''ec'' THEN ''email_contrib_last_update''
                WHEN table_code = ''pc'' THEN ''platform_contrib_last_update''
                ELSE NULL
            END
        ;
        
        IF table_name IS NULL THEN
            RAISE EXCEPTION ''Invalid table code (%) passed to %%'', table_code, function_name, function_args;
        END IF;

        statement := ''SELECT last_date FROM '' || table_name ||
                        '' WHERE project_id = '' || project_id
        ;

        FOR REC_update IN EXECUTE statement LOOP
            last_update := REC_update.last_date;
        END LOOP;

        RETURN last_update;
    END;
    '
    LANGUAGE plpgsql STABLE;


--
-- TOC entry 190 (OID 699664340)
-- Name: stats_set_last_update (integer, character, date); Type: FUNCTION; Schema: public; Owner: pgsql
--

CREATE FUNCTION stats_set_last_update (integer, character, date) RETURNS void
    AS '
    DECLARE
        function_name CONSTANT varchar(50) := ''stats_set_last_update'';
        function_args CONSTANT varchar(50) := ''(project_id, table_code, date)'';

        project_id ALIAS FOR $1;
        table_code ALIAS FOR $2;
        update_date ALIAS FOR $3;

        update_date_string varchar(20);
        table_name varchar(50);
        statement varchar(500);
    BEGIN
        IF project_id IS NULL THEN
            RAISE EXCEPTION ''NULL project_id passed to %%'', function_name, function_args;
        END IF;

        table_name :=
            CASE
                WHEN table_code = ''e'' THEN ''email_rank_last_update''
                WHEN table_code = ''t'' THEN ''team_rank_last_update''
                WHEN table_code = ''m'' THEN ''team_members_last_update''
                WHEN table_code = ''ec'' THEN ''email_contrib_last_update''
                WHEN table_code = ''pc'' THEN ''platform_contrib_last_update''
                ELSE NULL
            END;
        
        IF table_name IS NULL THEN
            RAISE EXCEPTION ''Invalid table code (%) passed to %%'', table_code, function_name, function_args;
        END IF;

        IF update_date IS NULL THEN
            update_date_string := ''NULL'';
        ELSE
            update_date_string := '''''''' || update_date || ''''''::date'';
        END IF;

    -- First, insert if we need to
        statement := ''INSERT INTO '' || quote_ident(table_name)
                            || ''(project_id) SELECT '' || project_id
                            || '' WHERE NOT EXISTS (SELECT 1 FROM ''
                            || quote_ident(table_name)
                            || '' WHERE project_id = '' || project_id || '')''
        ;

        EXECUTE statement;

    -- Now do the update
        statement := ''UPDATE '' || quote_ident(table_name) || '' SET last_date = ''
                        || coalesce(quote_literal(update_date), ''NULL'')
                        || '' WHERE project_id = '' || project_id
        ;

        EXECUTE statement;

        RETURN;
    END;
    '
    LANGUAGE plpgsql;


--
-- TOC entry 193 (OID 699664341)
-- Name: min (timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: pgsql
--

CREATE FUNCTION min (timestamp without time zone, timestamp without time zone) RETURNS timestamp without time zone
    AS '
    SELECT CASE WHEN $1 < $2 THEN $1 ELSE $2 END
    '
    LANGUAGE sql IMMUTABLE STRICT;


--
-- TOC entry 194 (OID 699664342)
-- Name: min (numeric, numeric); Type: FUNCTION; Schema: public; Owner: pgsql
--

CREATE FUNCTION min (numeric, numeric) RETURNS numeric
    AS '
    SELECT CASE WHEN $1 < $2 THEN $1 ELSE $2 END
    '
    LANGUAGE sql IMMUTABLE STRICT;


--
-- TOC entry 195 (OID 699664343)
-- Name: max (timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: pgsql
--

CREATE FUNCTION max (timestamp without time zone, timestamp without time zone) RETURNS timestamp without time zone
    AS '
    SELECT CASE WHEN $1 > $2 THEN $1 ELSE $2 END
    '
    LANGUAGE sql IMMUTABLE STRICT;


--
-- TOC entry 196 (OID 699664344)
-- Name: max (numeric, numeric); Type: FUNCTION; Schema: public; Owner: pgsql
--

CREATE FUNCTION max (numeric, numeric) RETURNS numeric
    AS '
    SELECT CASE WHEN $1 > $2 THEN $1 ELSE $2 END
    '
    LANGUAGE sql IMMUTABLE STRICT;


--
-- TOC entry 197 (OID 699664345)
-- Name: iszero (numeric, numeric); Type: FUNCTION; Schema: public; Owner: pgsql
--

CREATE FUNCTION iszero (numeric, numeric) RETURNS numeric
    AS '
    SELECT CASE WHEN $1 = 0 THEN $2 ELSE $1 END
    '
    LANGUAGE sql IMMUTABLE STRICT;


--
-- TOC entry 199 (OID 699664346)
-- Name: raise_exception (character); Type: FUNCTION; Schema: public; Owner: pgsql
--

CREATE FUNCTION raise_exception (character) RETURNS void
    AS '
    BEGIN
        RAISE EXCEPTION ''%'', $1;
        RETURN;
    END;
    '
    LANGUAGE plpgsql STRICT;


--
-- TOC entry 102 (OID 700539258)
-- Name: stats_team; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE stats_team (
    team serial NOT NULL,
    listmode smallint DEFAULT 0 NOT NULL,
    "password" character(8),
    created timestamp without time zone,
    name character varying(64) NOT NULL,
    url character varying(128),
    contactname character varying(64),
    contactemail character varying(64),
    logo character varying(128),
    showmembers character varying(3),
    showpassword character varying(16),
    description text,
    CONSTRAINT "$1" CHECK ((btrim((name)::text) <> ''::text))
) WITHOUT OIDS;


--
-- TOC entry 103 (OID 700539258)
-- Name: stats_team; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE stats_team FROM PUBLIC;
GRANT SELECT ON TABLE stats_team TO PUBLIC;
GRANT INSERT,UPDATE ON TABLE stats_team TO GROUP www;
GRANT UPDATE ON TABLE stats_team TO GROUP wheel;
GRANT UPDATE ON TABLE stats_team TO GROUP helpdesk;
GRANT UPDATE ON TABLE stats_team TO GROUP coder;


--
-- TOC entry 108 (OID 700539258)
-- Name: stats_team_team_seq; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE stats_team_team_seq FROM PUBLIC;
GRANT SELECT ON TABLE stats_team_team_seq TO PUBLIC;
GRANT INSERT,UPDATE ON TABLE stats_team_team_seq TO GROUP www;


--
-- TOC entry 198 (OID 702324088)
-- Name: isempty (character varying, character varying); Type: FUNCTION; Schema: public; Owner: decibel
--

CREATE FUNCTION isempty (character varying, character varying) RETURNS character varying
    AS '
    SELECT CASE WHEN $1 = '''' THEN $2 ELSE $1 END
    '
    LANGUAGE sql IMMUTABLE STRICT;


--
-- TOC entry 200 (OID 702324098)
-- Name: stats_participant_display_name (smallint, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: decibel
--

CREATE FUNCTION stats_participant_display_name (smallint, integer, character varying, character varying) RETURNS character varying
    AS '
    SELECT CASE $1
                WHEN 0 THEN $3
                WHEN 8 THEN $3
                WHEN 9 THEN $3
                WHEN 1 THEN ''Participant #'' || trim(to_char($2,''9,999,999,999''))
                WHEN 2 THEN isempty(coalesce(trim($4),''''), ''Participant #'' || trim(to_char($2,''9,999,999,999'')))
                ELSE ''Listmode ('' || cast($1 AS varchar) || '') error for ID '' || $2
            END
    '
    LANGUAGE sql IMMUTABLE;


--
-- TOC entry 201 (OID 702324124)
-- Name: stats_participant_display_name_l (smallint, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: decibel
--

CREATE FUNCTION stats_participant_display_name_l (smallint, integer, character varying, character varying) RETURNS character varying
    AS '
    SELECT lower(stats_participant_display_name($1, $2, $3, $4))
    '
    LANGUAGE sql IMMUTABLE;


--
-- TOC entry 104 (OID 702324150)
-- Name: stats_participant; Type: TABLE; Schema: public; Owner: pgsql
--

CREATE TABLE stats_participant (
    id integer NOT NULL,
    listmode smallint DEFAULT 0 NOT NULL,
    nonprofit smallint DEFAULT 0 NOT NULL,
    retire_to integer,
    retire_date date,
    created timestamp without time zone,
    dem_yob integer DEFAULT 0 NOT NULL,
    dem_heard smallint DEFAULT 0 NOT NULL,
    dem_motivation smallint DEFAULT 0 NOT NULL,
    dem_gender character(1),
    email character varying(64) DEFAULT '' NOT NULL,
    "password" character(8) DEFAULT '' NOT NULL,
    contact_name character varying(50) DEFAULT '' NOT NULL,
    contact_phone character varying(20) DEFAULT '' NOT NULL,
    motto character varying(255) DEFAULT '' NOT NULL,
    dem_country character(2)
) WITHOUT OIDS;


--
-- TOC entry 105 (OID 702324150)
-- Name: stats_participant; Type: ACL; Schema: public; Owner: pgsql
--

REVOKE ALL ON TABLE stats_participant FROM PUBLIC;
GRANT SELECT ON TABLE stats_participant TO PUBLIC;
GRANT INSERT ON TABLE stats_participant TO GROUP processing;
GRANT UPDATE ON TABLE stats_participant TO GROUP www;
GRANT UPDATE ON TABLE stats_participant TO GROUP wheel;
GRANT UPDATE ON TABLE stats_participant TO GROUP helpdesk;
GRANT UPDATE ON TABLE stats_participant TO GROUP coder;


--
-- TOC entry 204 (OID 825192714)
-- Name: p_teamjoin (integer, integer); Type: FUNCTION; Schema: public; Owner: thejet
--

CREATE FUNCTION p_teamjoin (integer, integer) RETURNS void
    AS '
    DECLARE
        today date := CURRENT_DATE;
        yesterday date := CURRENT_DATE -1; 

        participant_id ALIAS FOR $1;
        new_team_id ALIAS FOR $2;
    BEGIN
	/* Error checking */
	IF participant_id = 0 THEN
            RAISE EXCEPTION ''0 is an invalid participant id'';
        END IF;

	IF new_team_id IS NULL THEN
            RAISE EXCEPTION ''No team specified'';
	END IF;

	IF new_team_id != 0 THEN
            IF NOT EXISTS(SELECT * FROM stats_team WHERE team = new_team_id) THEN
                RAISE EXCEPTION ''Invalid Team Specified'';
            END IF;
        END IF;

	/* If the participant already has a record for today, nuke it */
	DELETE FROM team_joins
            WHERE id = participant_id 
	        AND join_date = today;

	/* If the person was on the same team yesterday, update that record
		instead of adding a new one */
        IF EXISTS(SELECT team_id INTO tempvar FROM team_joins WHERE id = participant_id
                AND (last_date IS NULL OR last_date = yesterday) AND team_id = new_team_id) THEN
            UPDATE team_joins
                SET last_date = NULL,
                    leave_team_id = 0
                WHERE id = participant_id
                    AND ( last_date IS NULL OR last_date = yesterday );
        ELSE	
            /* Update the entry for the previous team, if there is one */
            UPDATE team_joins
                SET last_date = yesterday,
                    leave_team_id = new_team_id
                WHERE id = participant_id
                    AND ( last_date IS NULL OR last_date = yesterday );
		/* note that there should always be 1 or 0 records where LAST_DATE = null
		   for a given participant */
	
            /* Insert a new record, unless we''re joining ''team 0'' */
            IF new_team_id != 0 THEN
                    INSERT INTO team_joins (id, team_id, join_date)
                        VALUES (participant_id, new_team_id, today);
            END IF;
	END IF;

        RETURN;
    END;
    '
    LANGUAGE plpgsql;


--
-- TOC entry 205 (OID 825192714)
-- Name: p_teamjoin (integer, integer); Type: ACL; Schema: public; Owner: thejet
--

REVOKE ALL ON FUNCTION p_teamjoin (integer, integer) FROM PUBLIC;
GRANT ALL ON FUNCTION p_teamjoin (integer, integer) TO PUBLIC;


--
-- TOC entry 202 (OID 825395232)
-- Name: p_pretire (integer, integer); Type: FUNCTION; Schema: public; Owner: thejet
--

CREATE FUNCTION p_pretire (integer, integer) RETURNS record
    AS '
    DECLARE
        participant_id ALIAS FOR $1;
        new_participant_id ALIAS FOR $2;
      
        i integer;
        rv integer := 0;
        retires integer;
        srcemail varchar(64);
        destemail varchar(64);
        destteam integer;
    BEGIN
	/*
	**	Call using "SELECT p_pretire($id, $destid);"
	**	Return data is ReturnValue, RetiresFound, SourceEmail, DestEmail
	*/
        SELECT COUNT(*) INTO i
            FROM stats_participant
            WHERE retire_to IN (participant_id, new_participant_id);
        IF i > 10 THEN
            /* @rv = 1 */
            RAISE EXCEPTION ''You may only retire 10 accounts into any one account.
'';
        END IF;

	SELECT email INTO srcemail
            FROM stats_participant
            WHERE id = participant_id;
        IF NOT FOUND THEN
            /* @rv = 2 */
            RAISE EXCEPTION ''Invalid source participant id.
'';
        END IF;

        /** REMOVED Password check, done in PHP (@rv = 4) **/

	SELECT email INTO destemail
            FROM stats_participant
            WHERE id = new_participant_id;
        IF NOT FOUND THEN
            /* @rv = 3 */
            RAISE EXCEPTION ''Invalid destination participant id.
'';
        END IF;

        /** Collapsed this into one SQL statement, rather than two **/
        UPDATE stats_participant
            SET retire_to = new_participant_id,
                retire_date = CASE WHEN retire_to = 0 THEN CURRENT_DATE ELSE retire_date END
            WHERE id = participant_id OR retire_to = participant_id;

        /** Shouldn''t this be returning the total number of retires to the new participant id? **/
	SELECT COUNT(*) INTO retires
            FROM stats_participant
            WHERE retire_to = new_participant_id AND id <> new_participant_id;
            /** OLD WHERE clause
		where retire_to = @id
			and id <> @id **/

	SELECT rv AS ''ReturnValue'', retires AS ''RetiresFound'', srcemail AS ''SourceEmail'', destemail AS ''DestEmail''

    END;
    '
    LANGUAGE plpgsql;


--
-- TOC entry 203 (OID 825395232)
-- Name: p_pretire (integer, integer); Type: ACL; Schema: public; Owner: thejet
--

REVOKE ALL ON FUNCTION p_pretire (integer, integer) FROM PUBLIC;
GRANT ALL ON FUNCTION p_pretire (integer, integer) TO PUBLIC;


--
-- TOC entry 191 (OID 825472967)
-- Name: p_testexists (integer); Type: FUNCTION; Schema: public; Owner: thejet
--

CREATE FUNCTION p_testexists (integer) RETURNS integer
    AS '
    DECLARE
        part_id ALIAS FOR $1;
    BEGIN
      IF EXISTS(SELECT * FROM stats_participant WHERE id = part_id) THEN
        RETURN 1;
      ELSE
        RETURN 0;
      END IF;
    END;
    '
    LANGUAGE plpgsql STABLE;



--
-- TOC entry 120 (OID 700091896)
-- Name: email_rank__day_rank; Type: INDEX; Schema: public; Owner: pgsql
--

CREATE INDEX email_rank__day_rank ON email_rank USING btree (project_id, day_rank);


--
-- TOC entry 121 (OID 700091897)
-- Name: email_rank__overall_rank; Type: INDEX; Schema: public; Owner: pgsql
--

CREATE INDEX email_rank__overall_rank ON email_rank USING btree (project_id, overall_rank);


--
-- TOC entry 118 (OID 700091902)
-- Name: email_contrib_today__team_id; Type: INDEX; Schema: public; Owner: pgsql
--

CREATE INDEX email_contrib_today__team_id ON email_contrib_today USING btree (project_id, team_id);


--
-- TOC entry 132 (OID 700091903)
-- Name: projects__project_type; Type: INDEX; Schema: public; Owner: pgsql
--

CREATE INDEX projects__project_type ON projects USING btree (project_type);


--
-- TOC entry 125 (OID 700091904)
-- Name: platform_contrib__projectdate; Type: INDEX; Schema: public; Owner: pgsql
--

CREATE INDEX platform_contrib__projectdate ON platform_contrib USING btree (project_id, date);


--
-- TOC entry 135 (OID 700091905)
-- Name: stats_participant_friend__friend; Type: INDEX; Schema: public; Owner: pgsql
--

CREATE INDEX stats_participant_friend__friend ON stats_participant_friend USING btree (friend);


--
-- TOC entry 149 (OID 700091906)
-- Name: team_joins__join; Type: INDEX; Schema: public; Owner: pgsql
--

CREATE INDEX team_joins__join ON team_joins USING btree (join_date);


--
-- TOC entry 150 (OID 700091907)
-- Name: team_joins__join_last; Type: INDEX; Schema: public; Owner: pgsql
--

CREATE INDEX team_joins__join_last ON team_joins USING btree (join_date, last_date);


--
-- TOC entry 155 (OID 700091908)
-- Name: team_joins__day_rank; Type: INDEX; Schema: public; Owner: pgsql
--

CREATE INDEX team_joins__day_rank ON team_rank USING btree (day_rank);


--
-- TOC entry 156 (OID 700091909)
-- Name: team_joins__overall_rank; Type: INDEX; Schema: public; Owner: pgsql
--

CREATE INDEX team_joins__overall_rank ON team_rank USING btree (overall_rank);


--
-- TOC entry 172 (OID 700539276)
-- Name: stats_team__team_listmode; Type: INDEX; Schema: public; Owner: pgsql
--

CREATE UNIQUE INDEX stats_team__team_listmode ON stats_team USING btree (team, listmode);


CREATE UNIQUE INDEX stats_participant__id_listmode ON stats_participant USING btree (id, listmode);
CREATE UNIQUE INDEX stats_participant__emailid ON stats_participant USING btree (email, id);
CREATE UNIQUE INDEX stats_participant__participantretire_id ON stats_participant USING btree (retire_to, id);
CREATE UNIQUE INDEX stats_participant__id_retire_listmode ON stats_participant USING btree (id, retire_to, listmode);
CREATE INDEX stats_participant__listmode ON stats_participant USING btree (listmode);
CREATE INDEX stats_participant__dem_heard ON stats_participant USING btree (dem_heard);
CREATE INDEX stats_participant__dem_motivation ON stats_participant USING btree (dem_motivation);
CREATE INDEX stats_participant__dem_country ON stats_participant USING btree (dem_country);
CREATE INDEX stats_participant__search ON stats_participant USING btree (stats_participant_display_name_l(listmode, id, email, contact_name));
CREATE UNIQUE INDEX stats_participant__lemail ON stats_participant USING btree (lower(email));


ALTER TABLE stats_participant CLUSTER ON stats_participant__lemail;

ALTER TABLE ONLY stats_participant
    ADD CONSTRAINT stats_participant_pkey PRIMARY KEY (id);
ALTER TABLE ONLY stats_participant
    ADD CONSTRAINT stats_participant__email UNIQUE (email);

--
-- TOC entry 151 (OID 831861330)
-- Name: team_joins__team_id; Type: INDEX; Schema: public; Owner: pgsql
--

CREATE INDEX team_joins__team_id ON team_joins USING btree (team_id);


--
-- TOC entry 122 (OID 700091930)
-- Name: email_rank_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY email_rank
    ADD CONSTRAINT email_rank_pkey PRIMARY KEY (project_id, id);


--
-- TOC entry 126 (OID 700091932)
-- Name: platform_contrib_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY platform_contrib
    ADD CONSTRAINT platform_contrib_pkey PRIMARY KEY (project_id, cpu, os, ver, date);


--
-- TOC entry 115 (OID 700091938)
-- Name: daily_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY daily_summary
    ADD CONSTRAINT daily_summary_pkey PRIMARY KEY (date, project_id);


--
-- TOC entry 117 (OID 700091940)
-- Name: email_contrib_last_update_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY email_contrib_last_update
    ADD CONSTRAINT email_contrib_last_update_pkey PRIMARY KEY (project_id);


--
-- TOC entry 119 (OID 700091942)
-- Name: email_contrib_today_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY email_contrib_today
    ADD CONSTRAINT email_contrib_today_pkey PRIMARY KEY (project_id, id);


--
-- TOC entry 123 (OID 700091944)
-- Name: email_rank_last_update_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY email_rank_last_update
    ADD CONSTRAINT email_rank_last_update_pkey PRIMARY KEY (project_id);


--
-- TOC entry 124 (OID 700091946)
-- Name: log_info_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY log_info
    ADD CONSTRAINT log_info_pkey PRIMARY KEY (project_id, log_timestamp);


--
-- TOC entry 127 (OID 700091948)
-- Name: platform_contrib_last_update_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY platform_contrib_last_update
    ADD CONSTRAINT platform_contrib_last_update_pkey PRIMARY KEY (project_id);


--
-- TOC entry 128 (OID 700091950)
-- Name: platform_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY platform_summary
    ADD CONSTRAINT platform_summary_pkey PRIMARY KEY (project_id, cpu, os, ver);


--
-- TOC entry 129 (OID 700091952)
-- Name: project_status_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY project_status
    ADD CONSTRAINT project_status_pkey PRIMARY KEY (status);


--
-- TOC entry 130 (OID 700091954)
-- Name: project_statsrun_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY project_statsrun
    ADD CONSTRAINT project_statsrun_pkey PRIMARY KEY (project_id);


--
-- TOC entry 133 (OID 700091956)
-- Name: projects_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (project_id);


--
-- TOC entry 131 (OID 700091958)
-- Name: projects__name; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects__name UNIQUE (name);


--
-- TOC entry 134 (OID 700091960)
-- Name: stats_participant_blocked_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY stats_participant_blocked
    ADD CONSTRAINT stats_participant_blocked_pkey PRIMARY KEY (id);


--
-- TOC entry 136 (OID 700091962)
-- Name: stats_participant_friend_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY stats_participant_friend
    ADD CONSTRAINT stats_participant_friend_pkey PRIMARY KEY (id, friend);


--
-- TOC entry 138 (OID 700091964)
-- Name: stats_participant_listmode_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY stats_participant_listmode
    ADD CONSTRAINT stats_participant_listmode_pkey PRIMARY KEY (listmode);


--
-- TOC entry 137 (OID 700091966)
-- Name: stats_participant_listmode__description; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY stats_participant_listmode
    ADD CONSTRAINT stats_participant_listmode__description UNIQUE (description);


--
-- TOC entry 139 (OID 700091968)
-- Name: stats_team_blocked_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY stats_team_blocked
    ADD CONSTRAINT stats_team_blocked_pkey PRIMARY KEY (team_id);


--
-- TOC entry 141 (OID 700091970)
-- Name: stats_country_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY stats_country
    ADD CONSTRAINT stats_country_pkey PRIMARY KEY (code);


--
-- TOC entry 140 (OID 700091972)
-- Name: stats_country__country; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY stats_country
    ADD CONSTRAINT stats_country__country UNIQUE (country);


--
-- TOC entry 142 (OID 700091974)
-- Name: stats_cpu_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY stats_cpu
    ADD CONSTRAINT stats_cpu_pkey PRIMARY KEY (cpu);


--
-- TOC entry 144 (OID 700091976)
-- Name: stats_dem_heard_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY stats_dem_heard
    ADD CONSTRAINT stats_dem_heard_pkey PRIMARY KEY (heard);


--
-- TOC entry 143 (OID 700091978)
-- Name: stats_dem_heard__description; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY stats_dem_heard
    ADD CONSTRAINT stats_dem_heard__description UNIQUE (description);


--
-- TOC entry 146 (OID 700091980)
-- Name: stats_dem_motivation_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY stats_dem_motivation
    ADD CONSTRAINT stats_dem_motivation_pkey PRIMARY KEY (motivation);


--
-- TOC entry 145 (OID 700091982)
-- Name: stats_dem_motivation__description; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY stats_dem_motivation
    ADD CONSTRAINT stats_dem_motivation__description UNIQUE (description);


--
-- TOC entry 147 (OID 700091984)
-- Name: stats_nonprofit_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY stats_nonprofit
    ADD CONSTRAINT stats_nonprofit_pkey PRIMARY KEY (nonprofit);


--
-- TOC entry 148 (OID 700091986)
-- Name: stats_os_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY stats_os
    ADD CONSTRAINT stats_os_pkey PRIMARY KEY (os);


--
-- TOC entry 152 (OID 700091988)
-- Name: team_joins_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY team_joins
    ADD CONSTRAINT team_joins_pkey PRIMARY KEY (id, join_date, team_id);


--
-- TOC entry 153 (OID 700091990)
-- Name: team_members_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY team_members
    ADD CONSTRAINT team_members_pkey PRIMARY KEY (project_id, team_id, id);


--
-- TOC entry 154 (OID 700091992)
-- Name: team_members_last_update_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY team_members_last_update
    ADD CONSTRAINT team_members_last_update_pkey PRIMARY KEY (project_id);


--
-- TOC entry 157 (OID 700091994)
-- Name: team_rank_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY team_rank
    ADD CONSTRAINT team_rank_pkey PRIMARY KEY (project_id, team_id);


--
-- TOC entry 158 (OID 700091996)
-- Name: team_rank_last_update_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY team_rank_last_update
    ADD CONSTRAINT team_rank_last_update_pkey PRIMARY KEY (project_id);


--
-- TOC entry 116 (OID 700091998)
-- Name: email_contrib_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY email_contrib
    ADD CONSTRAINT email_contrib_pkey PRIMARY KEY (project_id, id, date);


--
-- TOC entry 185 (OID 702324174)
-- Name: stats_participant_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY stats_participant
    ADD CONSTRAINT stats_participant_pkey PRIMARY KEY (id);


--
-- TOC entry 177 (OID 702324176)
-- Name: stats_participant__email; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY stats_participant
    ADD CONSTRAINT stats_participant__email UNIQUE (email);


--
-- TOC entry 207 (OID 702324218)
-- Name: fk_team_joins__participant_id; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY team_joins
    ADD CONSTRAINT fk_team_joins__participant_id FOREIGN KEY (id) REFERENCES stats_participant(id) ON UPDATE NO ACTION ON DELETE NO ACTION;


--
-- TOC entry 173 (OID 703804848)
-- Name: stats_team_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY stats_team
    ADD CONSTRAINT stats_team_pkey PRIMARY KEY (team);


--
-- TOC entry 206 (OID 703804850)
-- Name: fk_team_joins_teamid; Type: CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY team_joins
    ADD CONSTRAINT fk_team_joins_teamid FOREIGN KEY (team_id) REFERENCES stats_team(team) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE ONLY stats_participant
    ADD CONSTRAINT fk_stats_participant__country FOREIGN KEY (dem_country) REFERENCES stats_country(code);
ALTER TABLE ONLY stats_participant
    ADD CONSTRAINT fk_stats_participant__listmode FOREIGN KEY (listmode) REFERENCES stats_participant_listmode(listmode) ON UPDATE CASCADE;
ALTER TABLE ONLY stats_participant
    ADD CONSTRAINT fk_stats_participant__country FOREIGN KEY (dem_country) REFERENCES stats_country(code) ON UPDATE NO ACTION ON DELETE NO ACTION;




CREATE TABLE version (
    component   text    NOT NULL CONSTRAINT version__component PRIMARY KEY
    , version   text    NOT NULL
) WITHOUT OIDs;
INSERT INTO version VALUES('schema','2.1');


CREATE FUNCTION T_created_updated() RETURNS TRIGGER AS '
BEGIN
   NEW.updated := CURRENT_TIMESTAMP;
   IF TG_OP = ''INSERT'' THEN
      NEW.created := CURRENT_TIMESTAMP;
   ELSE
      NEW.created := OLD.created;
   END IF;
   RETURN NEW;
END;
' LANGUAGE plpgsql;

CREATE FUNCTION T_created() RETURNS "trigger"
    AS '
BEGIN
    IF TG_OP = ''INSERT'' THEN
        NEW.created := now();
    ELSIF TG_OP = ''UPDATE'' THEN
        NEW.created := OLD.created;
    END IF;
    RETURN NEW;
END;
'
    LANGUAGE plpgsql;

CREATE TRIGGER created BEFORE INSERT OR UPDATE ON
    stats_participant FOR EACH ROW EXECUTE PROCEDURE T_created();

CREATE TRIGGER created_updated BEFORE INSERT OR UPDATE ON
		projects FOR EACH ROW EXECUTE PROCEDURE public.T_created_updated();
CREATE TRIGGER created_updated BEFORE INSERT OR UPDATE ON
		project_status FOR EACH ROW EXECUTE PROCEDURE public.T_created_updated();
CREATE TRIGGER created_updated BEFORE INSERT OR UPDATE ON
		stats_country FOR EACH ROW EXECUTE PROCEDURE public.T_created_updated();
CREATE TRIGGER created_updated BEFORE INSERT OR UPDATE ON
		stats_cpu FOR EACH ROW EXECUTE PROCEDURE public.T_created_updated();
CREATE TRIGGER created_updated BEFORE INSERT OR UPDATE ON
		stats_dem_heard FOR EACH ROW EXECUTE PROCEDURE public.T_created_updated();
CREATE TRIGGER created_updated BEFORE INSERT OR UPDATE ON
		stats_dem_motivation FOR EACH ROW EXECUTE PROCEDURE public.T_created_updated();
CREATE TRIGGER created_updated BEFORE INSERT OR UPDATE ON
		stats_nonprofit FOR EACH ROW EXECUTE PROCEDURE public.T_created_updated();
CREATE TRIGGER created_updated BEFORE INSERT OR UPDATE ON
		stats_os FOR EACH ROW EXECUTE PROCEDURE public.T_created_updated();

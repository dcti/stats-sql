-- $Id: functions.sql,v 1.6 2003/04/25 19:36:23 decibel Exp $

\set ON_ERROR_STOP 1

-- Max rank
CREATE OR REPLACE FUNCTION stats_get_max_rank_participant() RETURNS int
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
    ' LANGUAGE 'plpgsql'
    STABLE
;
CREATE OR REPLACE FUNCTION stats_get_max_rank_team() RETURNS int
    AS '
    DECLARE
        max_rank int;
    BEGIN
        SELECT count(*) INTO max_rank
            FROM stats_team
        ;

        RETURN max_rank;
    END;
    ' LANGUAGE 'plpgsql'
    STABLE
;

-- Last update
CREATE OR REPLACE FUNCTION stats_get_last_update(projects.project_id%TYPE, char) RETURNS date
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
    ' LANGUAGE 'plpgsql'
    STABLE
;
CREATE OR REPLACE FUNCTION stats_set_last_update(projects.project_id%TYPE, char, date) RETURNS void
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
    ' LANGUAGE 'plpgsql'
    VOLATILE
;

-- MIN
CREATE OR REPLACE FUNCTION min(timestamp, timestamp) RETURNS timestamp
    RETURNS NULL ON NULL INPUT
    AS '
    SELECT CASE WHEN $1 < $2 THEN $1 ELSE $2 END
    ' LANGUAGE SQL
    IMMUTABLE
;
CREATE OR REPLACE FUNCTION min(numeric, numeric) RETURNS numeric
    RETURNS NULL ON NULL INPUT
    AS '
    SELECT CASE WHEN $1 < $2 THEN $1 ELSE $2 END
    ' LANGUAGE SQL
    IMMUTABLE
;

-- MAX
CREATE OR REPLACE FUNCTION max(timestamp, timestamp) RETURNS timestamp
    RETURNS NULL ON NULL INPUT
    AS '
    SELECT CASE WHEN $1 > $2 THEN $1 ELSE $2 END
    ' LANGUAGE SQL
    IMMUTABLE
;
CREATE OR REPLACE FUNCTION max(numeric, numeric) RETURNS numeric
    RETURNS NULL ON NULL INPUT
    AS '
    SELECT CASE WHEN $1 > $2 THEN $1 ELSE $2 END
    ' LANGUAGE SQL
    IMMUTABLE
;

-- ISZERO
CREATE OR REPLACE FUNCTION iszero(numeric, numeric) RETURNS numeric
    RETURNS NULL ON NULL INPUT
    AS '
    SELECT CASE WHEN $1 = 0 THEN $2 ELSE $1 END
    ' LANGUAGE SQL
    IMMUTABLE
;

/*
 $Id: team_rank_2.sql,v 1.4.2.3 2003/09/08 23:26:56 decibel Exp $

 Repopulates Team_Members fOR a project.

 Arguments:
       ProjectID
*/
\set ON_ERROR_STOP 1

\echo ::Updating Team_Rank - Pass 2
\echo Creating summary table

SELECT team_id, min(first_date) AS first_date, max(last_date) AS last_date,
        sum(work_today) AS work_today, sum(sign(work_today)) AS members_today, count(*) AS members_overall
    INTO TEMP teamsummary
    FROM team_members tm
    WHERE project_id = :ProjectID
    GROUP BY project_id, team_id
;
ANALYZE VERBOSE teamsummary;

\echo Counting current team membership   
SELECT tm.team_id, count(*) AS members   
    INTO TEMP team_members_current   
    FROM team_joins tj, team_members tm   
    WHERE tj.join_date <= (SELECT max(last_date) FROM team_members WHERE project_id = :ProjectID)
        AND (tj.last_date >= (SELECT max(last_date) FROM team_members WHERE project_id = :ProjectID)
            OR tj.last_date IS NULL)
        AND tj.id = tm.id   
        AND tj.team_id = tm.team_id   
        AND tm.project_id = :ProjectID   
    GROUP BY tm.project_id, tm.team_id   
; 
ANALYZE VERBOSE team_members_current;


\echo 
\echo 
\echo Updating Team_Rank
BEGIN;
    UPDATE team_rank
        SET day_rank_previous = day_rank,
            overall_rank_previous = overall_rank,
            work_today = s.work_today,
            work_total = work_total + s.work_today,
            members_today = s.members_today,
            members_overall = s.members_overall
        FROM teamsummary s
        WHERE team_rank.project_id = :ProjectID
            AND team_rank.team_id = s.team_id
    ;
    UPDATE team_rank
        SET members_current = tmc.members
        FROM team_members_current tmc
        WHERE team_rank.project_id = :ProjectID
            AND team_rank.team_id = tmc.team_id
    ;
COMMIT;

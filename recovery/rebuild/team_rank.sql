/*
 $Id: team_rank.sql,v 1.12 2003/09/09 20:43:55 decibel Exp $

 Repopulates Team_Rank fOR a project.

 Arguments:
       ProjectID
*/
\set ON_ERROR_STOP 1

\echo ::Updateing Team_Rank - Pass 1
\echo Creating summary table

SELECT team_id, min(first_date) AS first_date, max(last_date) AS last_date,
        sum(work_yesterday) AS work_yesterday, sum(work_today) AS work_today, sum(work_total) AS work_total
    INTO TEMP teamsummary
    FROM worksummary_:ProjectID
    WHERE team_id >= 1
        AND team_id NOT IN (SELECT team_id FROM stats_team_blocked)
    GROUP BY team_id
;

BEGIN;
    \echo Deleting old data
    DELETE FROM team_rank
        WHERE project_id = :ProjectID
    ;
    \echo 
    \echo 
    \echo Inserting new data
    INSERT INTO team_rank (project_id, team_id, first_date, last_date, work_today, work_total,
            day_rank, day_rank_previous, overall_rank, overall_rank_previous,
            members_today, members_overall, members_current)
        SELECT :ProjectID, team_id, first_date, last_date, work_yesterday, work_total-work_today,
            0, 0, 0, 0,
            0, 0, 0
        FROM teamsummary
    ;
COMMIT;

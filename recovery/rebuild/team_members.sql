/*
# $Id: team_members.sql,v 1.10.2.1 2003/04/27 12:26:59 decibel Exp $
#
# Repopulates Team_Members fOR a project.
# Notes:
#    The script does *not* re-rank.
#    It assumes that the summary table has been created using make_summary.sql
#
# Arguments:
#       ProjectID
*/

\echo ::Updating Team_Members
\echo Deleting old data

BEGIN;
    DELETE FROM team_members
        WHERE project_id = :ProjectID
    ;

    \echo Inserting new data
    INSERT INTO team_members (project_id, id, team_id, first_date, last_date, work_today, work_total,
            day_rank, day_rank_previous, overall_rank, overall_rank_previous)
        SELECT :ProjectID, ws.id, ws.team_id, min(ws.first_date) AS first_date, max(ws.last_date) AS last_date,
                sum(ws.work_today), sum(ws.work_total), 0, 0, 0, 0
            FROM worksummary_:ProjectID ws
            WHERE ws.team_id > 0
                AND ws.team_id NOT IN (SELECT team_id
                            FROM stats_team_blocked
                        )
            GROUP BY id, team_id
    ;
COMMIT;

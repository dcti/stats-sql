/*
 $Id: work_summary.sql,v 1.18.2.1 2003/04/27 12:26:59 decibel Exp $

 Creates a summary table containing all work for a project

       ProjectID
*/

\echo 
\echo Note:
\echo Make sure that WorkSummary_:ProjectID does not exist!!!
\echo 

\echo First pass summary
-- Include PROJECT_ID here so that it can be used in the join in the next query. If we don't, the next
-- query will treat PROJECT_ID = :ProjectID AS an SARG AND everything else AS a JOIN, which means we can't
-- fully utilize our index.
SELECT id, team_id, date AS first_date, date AS last_date,
        work_units AS work_total, work_units AS work_today, work_units AS work_yesterday
    INTO TEMP worksummary
    FROM email_contrib
    WHERE 1=0
;
BEGIN;
    SET LOCAL enable_seqscan = off;
    INSERT INTO worksummary (id, team_id, first_date, last_date, work_total, work_today, work_yesterday)
        SELECT id, team_id, min(date), max(date), sum(work_units), 0, 0
        FROM email_contrib
        WHERE project_id = :ProjectID
        GROUP BY id, team_id
    ;
COMMIT;
ANALYZE worksummary;

\echo Update for work today
UPDATE worksummary
    SET work_today = ec.work_units
    FROM email_contrib ec
    WHERE ec.project_id = :ProjectID
        AND ec.id = worksummary.id
        AND ec.team_id = worksummary.team_id
        AND ec.date = (SELECT max(last_date) FROM worksummary)
;
UPDATE worksummary
    SET work_yesterday = ec.work_units
    FROM email_contrib ec
    WHERE ec.project_id = :ProjectID
        AND ec.id = worksummary.id
        AND ec.team_id = worksummary.team_id
        AND ec.date = (SELECT max(last_date) - interval '1 day' FROM worksummary)
;

\echo Update for retire_to
UPDATE worksummary
    SET id = sp.retire_to
    FROM stats_participant sp
    WHERE sp.id = worksummary.id
        AND sp.retire_to > 0
        AND (sp.retire_date <= (SELECT max(last_date) FROM worksummary)
            OR sp.retire_date IS NULL)
;

\echo second pass summary
SELECT ws.id, ws.team_id, min(first_date) AS first_date, max(last_date) AS last_date,
        sum(work_total) AS work_total, sum(work_today) AS work_today, sum(work_yesterday) AS work_yesterday
    INTO worksummary_:ProjectID
    FROM worksummary ws
    WHERE ws.id NOT IN (SELECT id FROM stats_participant_blocked)
    GROUP BY ws.id, ws.team_id
;

drop table worksummary;
ANALYZE VERBOSE worksummary_:ProjectID;

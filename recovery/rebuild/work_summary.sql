/*
 $Id: work_summary.sql,v 1.22 2004/11/08 16:39:25 decibel Exp $

 Creates a summary table containing all work for a project

       ProjectID
*/
\set ON_ERROR_STOP 1

\echo 
\echo Note:
\echo Make sure that WorkSummary_:ProjectID does not exist!!!
\echo 

CREATE TEMP TABLE worksummary (
    id              int     not null
    , team_id       int     
    , first_date    date    not null
    , last_date     date    not null
    , work_total    numeric(20,0)  not null
    , work_today    bigint  not null
    , work_yesterday    bigint  not null
) WITHOUT OIDS
;

\echo First pass summary
-- Include PROJECT_ID here so that it can be used in the join in the next query. If we don't, the next
-- query will treat PROJECT_ID = :ProjectID AS an SARG AND everything else AS a JOIN, which means we can't
-- fully utilize our index.
BEGIN;
    --SET LOCAL enable_seqscan = off;
    --explain analyze
    INSERT INTO worksummary (id, team_id, first_date, last_date, work_total, work_today, work_yesterday)
        SELECT id, team_id, min(date), max(date), sum(work_units), 0, 0
        FROM email_contrib
        WHERE project_id = :ProjectID
        GROUP BY id, team_id
    ;
COMMIT;
ANALYZE worksummary;
CREATE INDEX worksummary__last_date ON worksummary (last_date);

\echo Update for work today
--explain analyze
UPDATE worksummary
    SET work_today = ec.work_units
    FROM email_contrib ec
    WHERE ec.project_id = :ProjectID
        AND ec.id = worksummary.id
        AND ( ec.team_id = worksummary.team_id OR (ec.team_id IS NULL AND worksummary.team_id IS NULL) )
        AND ec.date = (SELECT max(last_date) FROM worksummary)
;
--explain analyze
UPDATE worksummary
    SET work_yesterday = ec.work_units
    FROM email_contrib ec
    WHERE ec.project_id = :ProjectID
        AND ec.id = worksummary.id
        AND ( ec.team_id = worksummary.team_id OR (ec.team_id IS NULL AND worksummary.team_id IS NULL) )
        AND ec.date = (SELECT max(last_date) - interval '1 day' FROM worksummary)
;

\echo Update for retire_to
--explain analyze
UPDATE worksummary
    SET id = sp.retire_to
    FROM stats_participant sp
    WHERE sp.id = worksummary.id
        AND sp.retire_to > 0
        AND (sp.retire_date <= (SELECT max(last_date) FROM worksummary)
            OR sp.retire_date IS NULL)
;

\echo second pass summary
--explain analyze
SELECT ws.id, ws.team_id, min(first_date) AS first_date, max(last_date) AS last_date,
        sum(work_total) AS work_total, sum(work_today) AS work_today, sum(work_yesterday) AS work_yesterday
    INTO worksummary_:ProjectID
    FROM worksummary ws
    WHERE ws.id NOT IN (SELECT id
                            FROM stats_participant_blocked
                            WHERE block_date <= (SELECT max(last_date) FROM worksummary)
                        )
    GROUP BY ws.id, ws.team_id
;

drop table worksummary;
ANALYZE VERBOSE worksummary_:ProjectID;


/*
# $Id: email_rank_2.sql,v 1.5.2.2 2003/04/30 06:38:01 decibel Exp $
#
# Phase 1 of repopulating Email_Rank fOR a project. After this script, you should
# re-rank, then run email_rank_2.sql.
# Notes:
#    The script does *not* re-rank.
#    It assumes that the summary table has been created using make_summary.sql
#
# Arguments:
#       ProjectID
*/
\set ON_ERROR_STOP 1

\echo Creating summary table
SELECT id, sum(work_today) AS work_today
    INTO TEMP emailsum 
    FROM worksummary_:ProjectID
    GROUP BY id
;

-- It's worth creating the index...
CREATE UNIQUE INDEX pk ON emailsum(id)
;

\echo Updating Email_Rank
UPDATE email_rank SET day_rank_previous = day_rank,
        overall_rank_previous = overall_rank,
        work_today = s.work_today,
        work_total = work_total + s.work_today
    FROM emailsum s
    WHERE email_rank.project_id = :ProjectID
        AND email_rank.id = s.id
;

\echo All done. Run the email ranking script one last time.

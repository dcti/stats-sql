/*
# $Id: email_rank.sql,v 1.7.2.1 2003/04/27 12:26:59 decibel Exp $
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

BEGIN;
    \echo Deleting old data
    DELETE FROM email_rank
        WHERE project_id = :ProjectID
    ;

    \echo Inserting new data
    INSERT INTO email_rank (project_id, id, first_date, last_date, work_today, work_total,
            day_rank, day_rank_previous, overall_rank, overall_rank_previous)
        SELECT :ProjectID, id, min(first_date) AS first_date, max(last_date) AS last_date, sum(work_yesterday), sum(work_total) - sum(work_today),
            0, 0, 0, 0
        FROM worksummary_:ProjectID
        GROUP BY id
    ;
COMMIT;

\echo All done. Run the email ranking script, then run email_rank_2.sql

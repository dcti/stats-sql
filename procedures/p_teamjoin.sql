-- $Id: p_teamjoin.sql,v 1.1 2003/10/22 03:22:46 thejet Exp $

\set ON_ERROR_STOP 1

\echo Creating procedure p_teamjoin
CREATE OR REPLACE FUNCTION p_teamjoin(integer, integer) RETURNS void
    AS '
    DECLARE
        today date := CURRENT_DATE;
        yesterday date := CURRENT_DATE -1; 
        participant_id ALIAS FOR $1;
        team_id ALIAS FOR $2;
    BEGIN
	/* Error checking */
	IF participant_id = 0 THEN
            RAISE EXCEPTION ''0 is an invalid participant id''
        END IF;

	IF team_id IS NULL THEN
            RAISE EXCEPTION ''No team specified''
	END IF;

	IF team_id != 0 THEN
            PERFORM SELECT team FROM stats_team WHERE team = team_id;
            IF NOT FOUND THEN
                RAISE EXCEPTION ''Invalid Team Specified''
            END IF;
        END IF;

        /* Start the transaction */
        BEGIN WORK;

	/* If the participant already has a record for today, nuke it */
	PERFORM DELETE team_joins
            WHERE id = participant_id 
	        AND join_date = today;

	/* If the person was on the same team yesterday, update that record
		instead of adding a new one */
        PERFORM SELECT * FROM team_joins WHERE id = participant_id
                    AND (last_date IS NULL OR last_date = yesterday);
        IF FOUND THEN
            PERFORM UPDATE team_joins
                SET last_date = NULL,
                    leave_team_id = 0
                WHERE id = participant_id
                    AND ( last_date IS NULL OR last_date = yesterday );
        ELSE	
            /* Update the entry for the previous team, if there is one */
            PERFORM UPDATE team_joins
                SET last_date = yesterday,
                    leave_team_id = team_id
                WHERE id = participant_id
                    AND ( last_date IS NULL OR last_date = yesterday );
		// note that there should always be 1 or 0 records where LAST_DATE = null
		// for a given participant
	
            /* Insert a new record, unless we''re joining ''team 0'' */
            IF team_id != 0 THEN
                    PERFORM INSERT team_joins (id, team_id, join_date)
                        VALUES (participant_id, team_id, today);
            END IF;
	END IF;

        COMMIT WORK;
    END;
    ' LANGUAGE 'plpgsql'
    VOLATILE
;

GRANT EXECUTE ON FUNCTION p_teamjoin(integer,integer) TO PUBLIC;


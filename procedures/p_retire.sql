-- $Id: p_retire.sql,v 1.5 2003/12/31 16:22:33 decibel Exp $

/*
 Participant Retire

 Arguments:
    old participant_id (integer)
    id to retire into (integer)
 
 Example:
 select * from p_pretire(4,5) as (id integer,email varchar(64), retire_to integer);

 Code:

 1. Check ID's are not the same
 2. Check that there are not >10 retire_to's set.
 3. Check the source ID is valid
 4. Check source participant is not retired.
 5. Check destination participant is valid.
 6. check destination participant is not retired. 
 7. Do retire - set new retire_to / retire_dates
 8. select list of retired accounts to return from function. for each one, run p_teamjoin to update team status
*/

CREATE OR REPLACE FUNCTION p_retire(integer, integer, boolean) RETURNS int
AS '
    DECLARE
        participant_id ALIAS FOR $1;
        new_participant_id ALIAS FOR $2;
        no_limit ALIAS FOR $3;

        i integer;
    BEGIN

    IF participant_id = new_participant_id THEN
            RAISE EXCEPTION ''Participant IDs must be different.'';
    END IF; 

    IF NOT no_limit THEN
        SELECT COUNT(*) INTO i
            FROM stats_participant
            WHERE retire_to IN (participant_id, new_participant_id);
        IF i > 10 THEN
            RAISE EXCEPTION ''You may only retire 10 accounts into any one account.'';
        END IF;
    END IF;

    SELECT retire_to INTO i
        FROM stats_participant
        WHERE id = participant_id
        FOR UPDATE
    ;
    IF NOT FOUND THEN
        RAISE EXCEPTION ''Invalid source participant id.'';
    END IF;

    IF i > 0 THEN
            RAISE EXCEPTION ''Cant retire a retired account.'';
    END IF;

    SELECT retire_to INTO i
        FROM stats_participant
        WHERE id = new_participant_id
        FOR UPDATE
    ;
    IF NOT FOUND THEN
        RAISE EXCEPTION ''Invalid destination participant id.'';
    END IF;

    IF i > 0 THEN
            RAISE EXCEPTION ''Cant retire into a retired account.'';
    END IF;

        -- Update both the newly retired participant, and everyone retired to that participant
        -- Only update retire_date for the newly retired participant
        UPDATE stats_participant
            SET retire_to = new_participant_id, 
                retire_date = CASE WHEN retire_date IS NULL THEN CURRENT_DATE ELSE retire_date END
            WHERE id = participant_id OR retire_to = participant_id
        ;

    RETURN;
     END;
' LANGUAGE 'plpgsql'
VOLATILE
;

CREATE OR REPLACE FUNCTION p_retire(integer, integer) RETURNS int
AS '
    BEGIN
    RETURN p_pretire($1, $2, false);
    END;
' LANGUAGE 'plpgsql'
VOLATILE
;

GRANT EXECUTE ON FUNCTION p_retire(integer, integer, boolean) TO PUBLIC;
GRANT EXECUTE ON FUNCTION p_retire(integer, integer) TO PUBLIC;


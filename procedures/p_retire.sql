-- $Id: p_retire.sql,v 1.2 2003/10/30 16:11:26 decibel Exp $

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

CREATE OR REPLACE FUNCTION p_pretire(integer,integer) RETURNS setof RECORD
    AS '
    DECLARE
        participant_id ALIAS FOR $1;
        new_participant_id ALIAS FOR $2;

        i integer;
    BEGIN

    IF participant_id = new_participant_id THEN
            RAISE EXCEPTION ''Participant IDs must be different.'';
    END IF; 

    SELECT COUNT(*) INTO i
        FROM stats_participant
        WHERE retire_to IN (participant_id, new_participant_id);
    IF i > 10 THEN
        RAISE EXCEPTION ''You may only retire 10 accounts into any one account.'';
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

        /** Collapsed this into one SQL statement, rather than two **/
        UPDATE stats_participant
            SET retire_to = new_participant_id, 
                retire_date = CASE WHEN retire_to = 0 THEN CURRENT_DATE ELSE retire_date END
            WHERE id = participant_id OR retire_to = participant_id;

    RETURN;
     END;
    ' LANGUAGE 'plpgsql'
    VOLATILE
;

GRANT EXECUTE ON FUNCTION p_pretire(integer, integer) TO PUBLIC;


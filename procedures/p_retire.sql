-- $Id: p_retire.sql,v 1.1 2003/10/22 16:27:34 thejet Exp $

/** @TODO: How do we return a specific user-defined recordset? **/
CREATE OR REPLACE FUNCTION p_pretire(integer,integer) RETURNS RECORD
    AS '
    DECLARE
        participant_id ALIAS FOR $1;
        new_participant_id ALIAS FOR $2;
      
        i integer;
        rv integer := 0;
        retires integer;
        srcemail varchar(64);
        destemail varchar(64);
        destteam integer;
    BEGIN
	/*
	**	Call using "SELECT p_pretire($id, $destid);"
	**	Return data is ReturnValue, RetiresFound, SourceEmail, DestEmail
	*/
        SELECT COUNT(*) INTO i
            FROM stats_participant
            WHERE retire_to IN (participant_id, new_participant_id);
        IF i > 10 THEN
            /* @rv = 1 */
            RAISE EXCEPTION ''You may only retire 10 accounts into any one account.\n'';
        END IF;

	SELECT email INTO srcemail
            FROM stats_participant
            WHERE id = participant_id;
        IF NOT FOUND THEN
            /* @rv = 2 */
            RAISE EXCEPTION ''Invalid source participant id.\n'';
        END IF;

        /** REMOVED Password check, done in PHP (@rv = 4) **/

	SELECT email INTO destemail
            FROM stats_participant
            WHERE id = new_participant_id;
        IF NOT FOUND THEN
            /* @rv = 3 */
            RAISE EXCEPTION ''Invalid destination participant id.\n'';
        END IF;

        /** Collapsed this into one SQL statement, rather than two **/
        UPDATE stats_participant
            SET retire_to = new_participant_id,
                retire_date = CASE WHEN retire_to = 0 THEN CURRENT_DATE ELSE retire_date END
            WHERE id = participant_id OR retire_to = participant_id;

        /** Shouldn''t this be returning the total number of retires to the new participant id? **/
	SELECT COUNT(*) INTO retires
            FROM stats_participant
            WHERE retire_to = new_participant_id AND id <> new_participant_id;
            /** OLD WHERE clause
		where retire_to = @id
			and id <> @id **/

	SELECT rv AS ''ReturnValue'', retires AS ''RetiresFound'', srcemail AS ''SourceEmail'', destemail AS ''DestEmail''

    END;
    ' LANGUAGE 'plpgsql'
    VOLATILE
;

GRANT EXECUTE ON FUNCTION p_pretire(integer, integer) TO PUBLIC;


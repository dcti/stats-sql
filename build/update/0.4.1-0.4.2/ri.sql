-- $Id: ri.sql,v 1.1 2006/11/02 16:56:18 decibel Exp $

BEGIN;
    SELECT raise_exception('Unexpected schema version ' || version || ', should be 0.4.1')
        FROM version
        WHERE component = 'schema'
            AND version != '0.4.1'
    ;

    DELETE FROM stats_participant_friend
        WHERE NOT EXISTS (
                SELECT * FROM stats_participant p
                    WHERE p.id = stats_participant_friend.id
            )
    ;
    ALTER TABLE stats_participant_friend
        ADD CONSTRAINT stats_participant_friend__fk_id
        FOREIGN KEY ( id ) REFERENCES stats_participant ( id );

    DELETE FROM stats_participant_friend
        WHERE NOT EXISTS (
                SELECT * FROM stats_participant p
                    WHERE p.id = stats_participant_friend.friend
            )
    ;
    ALTER TABLE stats_participant_friend
        ADD CONSTRAINT stats_participant_friend__fk_friend
        FOREIGN KEY ( friend ) REFERENCES stats_participant ( id );

    DELETE FROM stats_team_blocked
        WHERE NOT EXISTS (
                SELECT * FROM stats_team t WHERE t.team = stats_team_blocked.team_id
            )
    ;
    ALTER TABLE stats_team_blocked
        ADD CONSTRAINT stats_team_blocked__fk_team_id
        FOREIGN KEY ( team_id ) REFERENCES stats_team ( team );

    UPDATE version SET version = '0.4.2' WHERE component = 'schema';

COMMIT;

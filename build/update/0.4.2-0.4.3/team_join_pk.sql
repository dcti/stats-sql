BEGIN;
    ALTER TABLE team_joins DROP CONSTRAINT team_joins_pkey;
    ALTER TABLE team_joins ADD PRIMARY KEY( id, join_date );
    GRANT INSERT ON team_joins TO GROUP processing;

    UPDATE version SET version='0.4.3' WHERE component='schema';
COMMIT;

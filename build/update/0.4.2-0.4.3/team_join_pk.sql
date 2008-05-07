BEGIN;
    ALTER TABLE team_joins DROP team_joins_pkey;
    ALTER TABLE team_joins ADD PRIMARY KEY( id, join_date );

    UPDATE version SET version='0.4.3' WHERE component='schema';
COMMIT;

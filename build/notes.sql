-- $Id: notes.sql,v 1.2 2005/01/08 21:58:05 decibel Exp $

CREATE TABLE stats_participant_notes(
	participant_id		int NOT NULL	CONSTRAINT stats_participant_notes__participant_id REFERENCES stats_participant(id)
	, datetime			timestamptz NOT NULL DEFAULT current_timestamp
	, note_author		varchar(40) NOT NULL
	, note				text
	, CONSTRAINT stats_participant_notes__PK_participant_datetime PRIMARY KEY( participant_id, datetime )
) WITHOUT OIDs;

CREATE TABLE stats_team_notes(
	team_id				int NOT NULL	CONSTRAINT stats_team_notes__team_id REFERENCES stats_team(team)
	, datetime			timestamptz NOT NULL DEFAULT current_timestamp
	, note_author		varchar(40) NOT NULL
	, note				text
	, CONSTRAINT stats_team_notes__PK_team_datetime PRIMARY KEY( team_id, datetime )
) WITHOUT OIDs;

-- vi: noexpandtab sw=4 ts=4

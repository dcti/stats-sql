-- $Id: stats_participant.sql,v 1.6 2003/06/13 01:41:12 decibel Exp $

\set ON_ERROR_STOP 1

select now() as start into temp start_time;
\t
select '$RCSfile: stats_participant.sql,v $ start time: ' || start from start_time;
\t

SELECT * INTO TEMP Tfriend FROM stats_participant_friend WHERE 1=0;
INSERT INTO Tfriend SELECT id, friend_a FROM STATS_Participant WHERE friend_a >= 1;
INSERT INTO Tfriend SELECT id, friend_b FROM STATS_Participant WHERE friend_b >= 1;
INSERT INTO Tfriend SELECT id, friend_c FROM STATS_Participant WHERE friend_c >= 1;
INSERT INTO Tfriend SELECT id, friend_d FROM STATS_Participant WHERE friend_d >= 1;
INSERT INTO Tfriend SELECT id, friend_e FROM STATS_Participant WHERE friend_e >= 1;

INSERT INTO stats_participant_friend 
    SELECT DISTINCT *
        FROM Tfriend
;

ALTER TABLE stats_participant DROP COLUMN team;

ALTER TABLE stats_participant DROP COLUMN friend_a;
ALTER TABLE stats_participant DROP COLUMN friend_b;
ALTER TABLE stats_participant DROP COLUMN friend_c;
ALTER TABLE stats_participant DROP COLUMN friend_d;
ALTER TABLE stats_participant DROP COLUMN friend_e;

ALTER TABLE ONLY stats_participant
    ADD CONSTRAINT stats_participant_pkey PRIMARY KEY (id);

ALTER TABLE ONLY stats_participant
    ADD CONSTRAINT stats_participant__email UNIQUE (email);

 grant Select on STATS_Participant to public;
 grant Insert on STATS_Participant to group processing;
 grant Update on STATS_Participant to group coder;
 grant Update on STATS_Participant to group helpdesk;
 grant Update on STATS_Participant to group www;
 grant Update on STATS_Participant to group wheel;

-- This step is required to force reclaiming space from the dropped columns
UPDATE stats_participant SET id=id;

VACUUM FULL ANALYZE VERBOSE stats_participant;

\t
select '$RCSfile: stats_participant.sql,v $ stop time: ' || now() || ', duration: ' || age(now(),start) from start_time;

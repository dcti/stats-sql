-- $Id: stats_participant.sql,v 1.2 2003/04/14 21:19:03 decibel Exp $

\set ON_ERROR_STOP 1

select now() as start into temp start_time;
\t
select '$File:$ start time: ' || start from start_time;
\t


alter table stats_participant drop column team;

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

\t
select '$File:$ stop time: ' || now() || ', duration: ' || age(now(),start) from start_time;

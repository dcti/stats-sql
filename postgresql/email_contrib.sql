-- $Id: email_contrib.sql,v 1.2 2003/04/14 21:19:03 decibel Exp $

\set ON_ERROR_STOP 1

select now() as start into temp start_time;
\t
select '$File:$ start time: ' || start from start_time;
\t

COPY Email_Contrib (ID, TEAM_ID, DATE, PROJECT_ID, WORK_UNITS) FROM '/home/decibel/blower/Email_Contrib.bcp' WITH DELIMITER '\t';

ALTER TABLE ONLY email_contrib
    ADD CONSTRAINT email_contrib_pkey PRIMARY KEY (project_id, id, date);

 grant Select on Email_Contrib to public;
 grant Insert on Email_Contrib to group processing;
 grant Update on Email_Contrib to group processing;

\t
select '$File:$ stop time: ' || now() || ', duration: ' || age(now(),start) from start_time;

-- $Id: email_contrib.sql,v 1.1 2003/04/14 19:26:44 decibel Exp $

\set ON_ERROR_STOP 1

COPY Email_Contrib (ID, TEAM_ID, DATE, PROJECT_ID, WORK_UNITS) FROM '/home/decibel/blower/Email_Contrib.bcp' WITH DELIMITER '\t';

ALTER TABLE ONLY email_contrib
    ADD CONSTRAINT email_contrib_pkey PRIMARY KEY (project_id, id, date);

 grant Select on Email_Contrib to public;
 grant Insert on Email_Contrib to group processing;
 grant Update on Email_Contrib to group processing;

-- $Id: email_rank.sql,v 1.2 2003/04/14 20:34:53 decibel Exp $

--\set ON_ERROR_STOP 1

 grant Select on Email_Rank to public;
 grant Insert on Email_Rank to group processing;
 grant Insert on Email_Rank to group wheel;
 grant Delete on Email_Rank to group processing;
 grant Delete on Email_Rank to group wheel;
 grant Update on Email_Rank to group processing;
 grant Update on Email_Rank to group wheel;

COPY Email_Rank (PROJECT_ID, ID, FIRST_DATE, LAST_DATE, WORK_TODAY, WORK_TOTAL, DAY_RANK, DAY_RANK_PREVIOUS, OVERALL_RANK, OVERALL_RANK_PREVIOUS) FROM '/home/decibel/blower/Email_Rank.bcp' WITH DELIMITER '\t';

CREATE INDEX email_rank__day_rank ON email_rank USING btree (project_id, day_rank);
CREATE INDEX email_rank__overall_rank ON email_rank USING btree (project_id, overall_rank);

CLUSTER Email_Rank_pkey ON Email_Rank;

ALTER TABLE ONLY email_rank
    ADD CONSTRAINT email_rank_pkey PRIMARY KEY (project_id, id);


-- $Id: email_rank.sql,v 1.7 2003/04/14 21:48:45 decibel Exp $

\set ON_ERROR_STOP 1

select now() as start into temp start_time;
\t
select '$RCSfile: email_rank.sql,v $ start time: ' || start from start_time;
\t

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

ALTER TABLE ONLY email_rank
    ADD CONSTRAINT email_rank_pkey PRIMARY KEY (project_id, id);

CLUSTER Email_Rank_pkey ON Email_Rank;

vacuum full analyze verbose email_rank;

\t
select '$RCSfile: email_rank.sql,v $ stop time: ' || now() || ', duration: ' || age(now(),start) from start_time;

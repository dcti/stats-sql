-- $Id: platform_contrib.sql,v 1.5 2003/04/14 21:48:45 decibel Exp $

\set ON_ERROR_STOP 1

select now() as start into temp start_time;
\t
select '$RCSfile: platform_contrib.sql,v $ start time: ' || start from start_time;
\t

COPY Platform_Contrib (PROJECT_ID, DATE, CPU, OS, VER, WORK_UNITS) FROM '/home/decibel/blower/Platform_Contrib.bcp' WITH DELIMITER '\t';

 grant Select on Platform_Contrib to public;
 grant Insert on Platform_Contrib to group processing;

CREATE INDEX platform_contrib__projectdate ON platform_contrib USING btree (project_id, date);

ALTER TABLE ONLY platform_contrib
    ADD CONSTRAINT platform_contrib_pkey PRIMARY KEY (project_id, cpu, os, ver, date);

CLUSTER Platform_Contrib_pkey ON Platform_Contrib;

vacuum full analyze verbose platform_contrib;

\t
select '$RCSfile: platform_contrib.sql,v $ stop time: ' || now() || ', duration: ' || age(now(),start) from start_time;

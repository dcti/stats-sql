-- $Id: Email_Contrib.sql,v 1.2 2003/04/14 15:02:38 decibel Exp $

\set ON_ERROR_STOP 1

SELECT * INTO email_contrib
    FROM email_contrib2
    ORDER BY project_id, id, date
;
DROP TABLE email_contrib2;

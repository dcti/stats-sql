-- $Id: Email_Contrib.sql,v 1.1 2003/04/14 14:56:57 decibel Exp $

\set ON_ERROR_STOP 1

SELECT * INTO email_contrib
    FROM email_contrib2
    ORDER BY project_id, id, date
;

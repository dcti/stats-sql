-- $Id: perms.sql,v 1.1 2005/07/21 19:22:21 decibel Exp $

BEGIN;

    GRANT INSERT ON stats_cpu TO GROUP processing;
    GRANT INSERT ON stats_os TO GROUP processing;
    GRANT SELECT ON version TO public;

    UPDATE version SET version = '0.4.1' WHERE component = 'schema';

COMMIT;

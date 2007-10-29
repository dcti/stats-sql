-- $Id: trigger_functions.sql,v 1.1 2007/10/29 00:38:48 decibel Exp $

CREATE OR REPLACE FUNCTION tg_not_allowed () RETURNS trigger LANGUAGE plpgsql AS $tg_not_allowed$
DECLARE
BEGIN
    RAISE EXCEPTION $$% are not allowed on table %$$, initcap(TG_OP) || 's', TG_RELNAME;
END;
$tg_not_allowed$;

-- vi: expandtab sw=4 ts=4

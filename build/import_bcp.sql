-- $Id: import_bcp.sql,v 1.1 2005/11/18 05:18:02 decibel Exp $

SET search_path = public, pg_catalog;
SET SESSION AUTHORIZATION 'statproc';

CREATE TABLE public.import_bcp (
    time_stamp date NOT NULL,
    email character varying(64) NOT NULL,
    project_id integer NOT NULL,
    work_units bigint NOT NULL,
    os integer NOT NULL,
    cpu integer NOT NULL,
    ver integer NOT NULL
) WITHOUT OIDS;



REVOKE ALL ON TABLE import_bcp FROM PUBLIC;
GRANT ALL ON TABLE import_bcp TO pgsql;
GRANT INSERT,SELECT,UPDATE,DELETE ON TABLE import_bcp TO GROUP processing;
GRANT SELECT ON TABLE import_bcp TO GROUP backup;
GRANT SELECT ON TABLE import_bcp TO GROUP wheel;
REVOKE ALL ON TABLE import_bcp FROM statproc;

-- vi: expandtab sw=4 ts=4

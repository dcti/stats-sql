CREATE OR REPLACE FUNCTION ogr_stublen_c(varchar(22)) RETURNS int4
  AS '/usr/local/lib/pgsql/ogr_stublen_c', 'ogr_stublen_c'
  LANGUAGE C WITH (isStrict);

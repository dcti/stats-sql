CREATE OR REPLACE FUNCTION ogr_stublen_c(varchar(22)) RETURNS int4
  AS '/tmp/stublen', 'ogr_stublen_c'
  LANGUAGE C WITH (isStrict);

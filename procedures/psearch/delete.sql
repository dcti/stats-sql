-- $Id: delete.sql,v 1.3 2000/03/17 04:55:58 decibel Exp $

\set procedure=p_psearch_${2}

if ( "${1}" = "" )
begin
	print "Database not specified! Using 'stats' as default!"
	use stats
end
else
begin
	use ${1}
end
go

if (object_id("$procedure") is not null)
begin
	revoke exec on $procedure to public
	print "Dropping procedure ${procedure}"
	drop procedure $procedure
end
go

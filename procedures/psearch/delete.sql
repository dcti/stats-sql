-- $Id: delete.sql,v 1.4 2000/06/09 09:43:25 decibel Exp $

\set procedure=p_psearch_${2}

use ${1}
go

\echo "procedure = $procedure"

if (object_id("$procedure") is not null)
begin
	revoke exec on $procedure to public
	print "Dropping procedure ${procedure}"
	drop procedure $procedure
end
go

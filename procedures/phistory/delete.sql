-- $Id: delete.sql,v 1.1 2000/10/18 10:59:07 decibel Exp $

\set procedure=p_phistory_${2}

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

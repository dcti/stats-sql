-- $Id: delete.sql,v 1.1 2000/06/07 08:23:14 decibel Exp $

use ${1}
go

\set procedure=p_lastupdate_${2}

if (object_id("$procedure") is not null)
begin
	print "Dropping procedure $procedure"
	drop procedure $procedure
end
go

-- $Id: lastupdate_delete.sql,v 1.2 2000/03/17 04:55:58 decibel Exp $

use ${1}
go

\set procedure=p_lastupdate_${2}

if (object_id("$procedure") is not null)
begin
	print "Dropping procedure $procedure"
	drop procedure $procedure
end
go

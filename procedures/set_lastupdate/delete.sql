-- $Id: delete.sql,v 1.1 2002/12/16 19:51:27 decibel Exp $

use ${1}
go

\set procedure=p_set_lastupdate_${2}

if (object_id("$procedure") is not null)
begin
	print "Dropping procedure $procedure"
	drop procedure $procedure
end
go

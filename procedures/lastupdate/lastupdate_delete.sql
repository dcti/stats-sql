use stats
go

\set procedure=p_lastupdate_${1}

if (object_id("$procedure") is not null)
begin
	print "Dropping procedure $procedure"
	drop procedure $procedure
end
go

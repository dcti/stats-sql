-- $Id: test.sql,v 1.1 1999/12/18 19:18:36 decibel Exp $

\set table=${2}_platform

if (select "${1}") = ""
	print 'Database not specified!'
else
begin
	print "Using database ${1}"
#	use ${1}
end
go
	
if (select "${1}") <> ""
begin
	print "Checking to see if $table exists"
	if object_id("$table") is not NULL
	begin
print "table exists"
#		set rowcount 1
#		if exists (select * from $table)
#		begin
#			print 'Not deleting - data exists'
#		end
#		else
#		begin
#			print 'Table doesnt exist!'
#		end
	end
end
go

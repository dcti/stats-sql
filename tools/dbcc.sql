-- $Id: dbcc.sql,v 1.4 2000/08/30 12:34:09 decibel Exp $
-- Run several dbcc checks in a single file, to make logging easy.
--
-- Accepts:
--	Database to check

use ${1}
go

select convert(varchar(40), getdate()) + ": Begin checkcatalog on ${1}"
print "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
print ""
go -h -f
dbcc checkcatalog
go

print ""
print "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
select convert(varchar(40), getdate()) + ": Begin checkalloc on ${1}"
print "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
print ""
go -h -f
dbcc checkalloc
go

print ""
print "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
select convert(varchar(40), getdate()) + ": Begin checkdb on ${1}"
print "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
print ""
go -h -f
dbcc checkdb
go

print ""
print "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
select convert(varchar(40), getdate()) + ": Finished checks on ${1}"
go -h -f

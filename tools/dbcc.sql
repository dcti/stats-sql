-- $Id: dbcc.sql,v 1.3 2000/08/02 18:47:07 decibel Exp $
-- Run several dbcc checks in a single file, to make logging easy.
--
-- Accepts:
--	Database to check

use ${1}
go

dbcc checkcatalog
go
dbcc checkalloc
go
dbcc checkdb
go

-- $Id: dbcc.sql,v 1.1 2000/08/02 18:38:55 decibel Exp $
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

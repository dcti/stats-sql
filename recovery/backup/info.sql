-- $Id: info.sql,v 1.5 2002/10/04 16:36:17 decibel Exp $

select getdate()
go -f
sp_help "${1}"
go -f
sp__objspace "${1}"
go -f

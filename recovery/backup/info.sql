-- $Id: info.sql,v 1.4 2002/10/04 16:32:19 decibel Exp $

select getdate()
sp_help "${1}"
go -f
sp__objspace "${1}"
go -f

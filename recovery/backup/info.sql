-- $Id: info.sql,v 1.3 2000/11/09 10:13:06 decibel Exp $

sp_help "${1}"
go -f
sp__objspace "${1}"
go -f

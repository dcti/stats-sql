-- $Id: info.sql,v 1.2 2000/11/05 23:07:03 decibel Exp $

sp_help ${1}
go -f
sp__objspace ${1}
go -f

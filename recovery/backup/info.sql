-- $Id: info.sql,v 1.1 2000/11/05 13:44:06 decibel Exp $

sp_help ${1}
go
select count(*) as Total_Rows from ${1}
go

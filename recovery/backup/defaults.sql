#!/usr/local/bin/sqsh -i

-- $Id: defaults.sql,v 1.1 2001/12/26 07:02:32 decibel Exp $

SELECT "exec sp_bindefault """ + object_name(c.cdefault) + """, """ + o.name + "." + c.name + """"
	FROM syscolumns c, sysobjects o
	WHERE o.id=c.id
		and object_name(c.cdefault) is not null
go -h -f

print "go"
go -h -f

#!/usr/local/bin/sqsh -i
SELECT "exec sp_adduser '" + m.name + "', '" + u.name + "', '" + g.name + "'"
	FROM master..syslogins m, sysusers u, sysusers g
	WHERE m.suid = u.suid
		and g.uid = u.gid
		and u.uid < 16834
		and u.uid > 1
\go -h -f

\echo go

#!/usr/local/bin/sqsh -i
select 'exec sp_addgroup ' + name from sysusers where uid>16389
\go -h -f

\echo go

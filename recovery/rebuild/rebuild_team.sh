# $Id: rebuild_team.sh,v 1.2.2.1 2003/04/27 12:26:59 decibel Exp $

if [ x$1 == x ]; then
    echo Must specify project ID!
    exit 1;
fi
if [ x$2 == x ]; then
    database=stats
else
    database=$2
fi

psql  -d $database -v ProjectID=$1 -f team_members.sql  && psql  -d $database -v ProjectID=$1 -f team_rank.sql  && psql  -d $database -v ProjectID=$1 -f ../../../stats-proc/daily/tm_rank.sql  && psql  -d $database -v ProjectID=$1 -f team_rank_2.sql  && psql  -d $database -v ProjectID=$1 -f ../../../stats-proc/daily/tm_rank.sql 

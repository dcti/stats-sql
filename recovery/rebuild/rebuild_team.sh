# $Id: rebuild_team.sh,v 1.2 2002/10/07 06:53:56 decibel Exp $

sqsh $1 -i team_members.sql $2 && sqsh $1 -i team_rank.sql $2 && sqsh $1 -i ../../../stats-proc/daily/tm_rank.sql $2 && sqsh $1 -i team_rank_2.sql $2 && sqsh $1 -i ../../../stats-proc/daily/tm_rank.sql $2

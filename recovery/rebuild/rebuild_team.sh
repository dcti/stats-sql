# $Id: rebuild_team.sh,v 1.1 2002/04/14 04:56:51 decibel Exp $

sqsh $2 -i team_members.sql $1 && sqsh $2 -i team_rank.sql $1

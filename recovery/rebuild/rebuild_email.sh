# $Id: rebuild_email.sh,v 1.2 2002/04/14 05:07:48 decibel Exp $

sqsh $2 -i email_rank.sql $1 && sqsh $2 -i ../../../stats-proc/daily//em_rank.sql $1 && sqsh $2 -i email_rank_2.sql $1 && sqsh $2 -i ../../../stats-proc/daily/em_rank.sql $1

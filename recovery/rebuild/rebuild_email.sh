# $Id: rebuild_email.sh,v 1.3 2002/10/07 06:48:33 decibel Exp $

sqsh $1 -i email_rank.sql $2 && sqsh $1 -i ../../../stats-proc/daily/em_rank.sql $2 && sqsh $1 -i email_rank_2.sql $2 && sqsh $1 -i ../../../stats-proc/daily/em_rank.sql $2

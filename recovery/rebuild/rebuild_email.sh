# $Id: rebuild_email.sh,v 1.1 2002/04/14 04:56:51 decibel Exp $

sqsh $2 -i email_rank.sql $1 && sqsh $2 -i ../../../stats-proc/em_rank.sql $1 && sqsh $2 -i email_rank_2.sql $1 && sqsh $2 -i ../../../stats-proc/em_rank.sql $1

#!/usr/bin/sqsh -i
#
# $Id: email_rank.sql,v 1.1 2000/10/04 07:34:01 decibel Exp $
#
# Verifies Email_Rank against some copy of itself.
#
# Notes:
# You should manually change the name of the table you're checking
#
# Arguments:
#       PROJECT_ID

select a.ID, a.FIRST_DATE, a.LAST_DATE, a.WORK_TODAY, a.WORK_TOTAL,
		a.DAY_RANK, a.DAY_RANK_PREVIOUS, a.OVERALL_RANK, a.OVERALL_RANK_PREVIOUS,
		b.FIRST_DATE, b.LAST_DATE, b.WORK_TODAY, b.WORK_TOTAL,
		b.DAY_RANK, b.DAY_RANK_PREVIOUS, b.OVERALL_RANK, b.OVERALL_RANK_PREVIOUS
	into bad_Email_Rank_${1}
	from Email_Rank a, jcn_Email_Rank b
	where a.ID = b.ID and (
		a.FIRST_DATE <> b.FIRST_DATE
		or a.LAST_DATE <> b.LAST_DATE
		or a.WORK_TODAY <> b.WORK_TODAY
		or a.WORK_TOTAL <> b.WORK_TOTAL
		or a.DAY_RANK <> b.DAY_RANK
		or a.DAY_RANK_PREVIOUS <> b.DAY_RANK_PREVIOUS
		or a.OVERALL_RANK <> b.OVERALL_RANK
		or a.OVERALL_RANK_PREVIOUS <> b.DAY_RANK_PREVIOUS )

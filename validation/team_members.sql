#!/usr/bin/sqsh -i
#
# $Id: team_members.sql,v 1.1 2000/10/20 07:15:41 decibel Exp $
#
# Verifies Team_Members against some copy of itself.
#
# Notes:
# You should manually change the name of the table you're checking
#
# Arguments:
#       PROJECT_ID

select a.ID, a.TEAM_ID,
		a.FIRST_DATE as aFIRST_DATE, b.FIRST_DATE as bFIRST_DATE,
		a.LAST_DATE as aLAST_DATE, b.LAST_DATE as bLAST_DATE,
		a.WORK_TODAY as aWORK_TODAY, b.WORK_TODAY as bWORK_TODAY,
		a.WORK_TOTAL as aWORK_TOTAL, b.WORK_TOTAL as bWORK_TOTAL,
		a.DAY_RANK as aDAY_RANK, b.DAY_RANK as bDAY_RANK, 
		a.DAY_RANK_PREVIOUS as aDAY_RANK_PREVIOUS, b.DAY_RANK_PREVIOUS as bDAY_RANK_PREVIOUS,
		a.OVERALL_RANK as aOVERALL_RANK, b.OVERALL_RANK as bOVERALL_RANK,
		a.OVERALL_RANK_PREVIOUS as aOVERALL_RANK_PREVIOUS, b.OVERALL_RANK_PREVIOUS as bOVERALL_RANK_PREVIOUS
	into bad_Team_Members_${1}
	from Team_Members a, jcn_Team_Members b
	where a.PROJECT_ID = ${1}
		and b.PROJECT_ID = ${1}
		and a.PROJECT_ID = b.PROJECT_ID
		and a.ID = b.ID
		and a.TEAM_ID = b.TEAM_ID
		and (
			a.FIRST_DATE <> b.FIRST_DATE
			or a.LAST_DATE <> b.LAST_DATE
			or a.WORK_TODAY <> b.WORK_TODAY
			or a.WORK_TOTAL <> b.WORK_TOTAL
--			or a.DAY_RANK <> b.DAY_RANK
--			or a.DAY_RANK_PREVIOUS <> b.DAY_RANK_PREVIOUS
--			or a.OVERALL_RANK <> b.OVERALL_RANK
--			or a.OVERALL_RANK_PREVIOUS <> b.DAY_RANK_PREVIOUS
		)
go

insert into bad_Team_Members_${1} (ID, TEAM_ID, aFIRST_DATE, aLAST_DATE, aWORK_TODAY,
		aWORK_TOTAL, aDAY_RANK, aDAY_RANK_PREVIOUS,
		aOVERALL_RANK, aOVERALL_RANK_PREVIOUS,
		bFIRST_DATE, bLAST_DATE, bWORK_TODAY,
		bWORK_TOTAL, bDAY_RANK, bDAY_RANK_PREVIOUS,
		bOVERALL_RANK, bOVERALL_RANK_PREVIOUS)
select a.ID, a.TEAM_ID, a.FIRST_DATE as aFIRST_DATE, a.LAST_DATE as aLAST_DATE, a.WORK_TODAY as aWORK_TODAY,
		a.WORK_TOTAL as aWORK_TOTAL, a.DAY_RANK as aDAY_RANK, a.DAY_RANK_PREVIOUS as aDAY_RANK_PREVIOUS,
		a.OVERALL_RANK as aOVERALL_RANK, a.OVERALL_RANK_PREVIOUS as aOVERALL_RANK_PREVIOUS,
		'1/1/1900', '1/1/1900', 0,
		0, 0, 0,
		0, 0
	from Team_Members a
	where PROJECT_ID = ${1}
		and not exists (select * from Team_Members where ID = a.ID and TEAM_ID = a.TEAM_ID and PROJECT_ID = a.PROJECT_ID)
go

insert into bad_Team_Members_${1} (ID, TEAM_ID, aFIRST_DATE, aLAST_DATE, aWORK_TODAY,
		aWORK_TOTAL, aDAY_RANK, aDAY_RANK_PREVIOUS,
		aOVERALL_RANK, aOVERALL_RANK_PREVIOUS,
		bFIRST_DATE, bLAST_DATE, bWORK_TODAY,
		bWORK_TOTAL, bDAY_RANK, bDAY_RANK_PREVIOUS,
		bOVERALL_RANK, bOVERALL_RANK_PREVIOUS)
select a.ID, a.TEAM_ID, '1/1/1900', '1/1/1900', 0,
		0, 0, 0,
		0, 0,
		a.FIRST_DATE as aFIRST_DATE, a.LAST_DATE as aLAST_DATE, a.WORK_TODAY as aWORK_TODAY,
		a.WORK_TOTAL as aWORK_TOTAL, a.DAY_RANK as aDAY_RANK, a.DAY_RANK_PREVIOUS as aDAY_RANK_PREVIOUS,
		a.OVERALL_RANK as aOVERALL_RANK, a.OVERALL_RANK_PREVIOUS as aOVERALL_RANK_PREVIOUS
	from jcn_Team_Members a
	where PROJECT_ID = ${1}
		and not exists (select * from Team_Members where ID = a.ID and TEAM_ID = a.TEAM_ID and PROJECT_ID = a.PROJECT_ID)
go

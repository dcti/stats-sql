# $Id: reidentity_participant_phase2.sql,v 1.1 2000/01/27 09:11:56 decibel Exp $

# If all goes well, this is a hands-off recovery routine to repair the
# runaway identity value problem wxperienced during server abend.
# 
# Run as sa, of course.
#
# sqsh -Usa -P- -i reidentity_participant.sql
#

use stats
go

drop table STATS_participantold
go

sp_rename STATS_participant, STATS_participantold
go

sp_rename STATS_participantnew, STATS_Participant
go


# Create the cross-reference table
drop table stats_participant_old_new
go

print "Creating STATS_participant_old_new"
go
select o.id oldid, o.email, n.id newid
into STATS_participant_old_new
from stats_participant n, stats_participantold o
where n.email = o.email
 and n.id <> o.id  --[BW] Avoid updating the ones that were already OK
go

print "Creating index i_oldnewid"
go
create unique clustered index i_oldnewid on STATS_participant_old_new(oldid,newid)
go

# Update the master tables to reflect the new id's
print "Updating csc_master"
go
update csc_master
 set id = newid
 from STATS_participant_old_new n
 where csc_master.id >= 500000
  and csc_master.id = n.oldid
go

print "Updating RC5_64_master"
go
update RC5_64_master
 set id = newid
 from STATS_Participant_old_new n
 where RC5_64_master.id >= 500000
  and RC5_64_master.id = n.oldid
go


# $id$
#
# This script will list the device numbers in use.

use master
go

select distinct low/16777216 
    from sysdevices 
    order by low
go

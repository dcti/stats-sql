# $Id: list_devices.sql,v 1.2 1999/10/10 22:18:31 decibel Exp $
#
# This script will list the device numbers in use.

use master
go

select distinct low/16777216 
    from sysdevices 
    order by low
go

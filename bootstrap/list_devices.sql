#!/usr/bin/sqsh -i
# $Id: list_devices.sql,v 1.3 1999/11/20 22:30:13 decibel Exp $
#
# This script will list the device numbers in use.

use master
go

select distinct low/16777216 
    from sysdevices 
    order by low
go

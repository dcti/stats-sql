#!/usr/bin/sqsh -h -i
# $Id: list_devices.sql,v 1.4 1999/11/26 03:12:45 decibel Exp $
#
# This script will list the device numbers in use.

use master
go

select distinct low/16777216 
    from sysdevices 
    order by low
go

# $Id: log_devices.sql,v 1.4 1999/10/10 22:41:06 decibel Exp $
#
# This file will create the required devices for the logging database.
# It must be run with SA privledges. Note that before running, you
# should execute 'list_devices.sql' to make sure that the device
# numbers called out here are available.

use master
go

# name is the name for the database device
# physname is the physical device
# vdevno is the device number
# size is the size in 2K blocks

disk init 
  name = "dev_logsa", 
  physname = "/usr/local/sybase/data/dev_logsa.dat", 
  vdevno = 2, size = 51200
go

disk init
  name = "dev_logs_logsa",
  physname = "/usr/local/sybase/logs/dev_logs_logsa.dat",
  vdevno = 3, size = 25600
go

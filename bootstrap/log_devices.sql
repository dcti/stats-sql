
# $Id: log_devices.sql,v 1.1 1999/10/10 22:08:16 decibel Exp $
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
  physname = "/dev/sdb2", 
  vdevno = 2, size = 51200
go

disk init
  name = "dev_logs_logsa"
  physname = "/dev/sdb2",
  vdevno = 3, size = 5120
go

#Makefile
# $Id: Makefile,v 1.1 2003/12/12 22:45:41 thejet Exp $
# Contains the code to properly create the shared library
# for linking with PostgreSQL
INCLUDE=-I/usr/local/include/postgresql/server
INSTALLDIR=/usr/local/lib/pgsql

ogr_stublen_c.so: ogr_stublen_c.o
	gcc -shared -o ogr_stublen_c.so ogr_stublen_c.o

ogr_stublen_c.o: ogr_stublen_c.c
	gcc -fpic ${INCLUDE} -c ogr_stublen_c.c

all: ogr_stublen_c.so

install: ogr_stublen_c.so
	install -C -S -g pgsql -o pgsql -m 500 ogr_stublen_c.so ${INSTALLDIR}

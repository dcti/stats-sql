/* C-Source style ogr-stublength calculation */
/* $Id: ogr_stublen_c.c,v 1.2 2003/12/12 22:45:41 thejet Exp $ */
#include "postgres.h"
#include <string.h>
#include "fmgr.h"

PG_FUNCTION_INFO_V1(ogr_stublen_c);
Datum ogr_stublen_c(PG_FUNCTION_ARGS)
{
  const int32 BUFSIZE = 10;
  VarChar* input = PG_GETARG_VARCHAR_P_SLICE(0, 3, -1);
  int32 retVal = 0;
  int32 size = VARSIZE(input) - VARHDRSZ;

  char buf[BUFSIZE];
  char *curPtr = ((char*)input) + VARHDRSZ;
  int32 offset = 0;
  int32 curPos = 0;
  int32 onepass = 0;
  for( ; curPos < size; curPos++)
  {
    while(curPtr[offset] != '-' && curPos < size) { curPos++; offset++; }
    if(offset > BUFSIZE)
    {
      PG_RETURN_INT32(-1);
    }
    strncpy(buf, curPtr, offset);
    buf[offset] = '\0';
    retVal += atoi(buf);
    curPtr = curPtr + offset +1;
    offset = 0; 
    onepass = 1;
  }
  
  PG_RETURN_INT32(retVal);
}

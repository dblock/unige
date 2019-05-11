/*
  CProcessor.h

  Daniel Doubrovkine - doubrov5@cuimail.unige.ch / dblock@infomaniak.ch
  University of Geneva - 1998 - All Rights Reserved
  */

#ifndef C_PROCESSOR_H
#define C_PROCESSOR_H

#include <cstring/cstring.h>
#include <cfield/cfield.h>
#include <cfilter/cfilter.h>

extern CField CFUndefined;
extern CField CFAnything;
extern CField CFString;
extern CField CFInteger;
extern CField CFSpace;
extern CField CFTab;
extern CField CFReturn;
extern CField CFDelim;
extern CField CFChar;

class CProcessor {
private:
  int FCnt;
  CFilter * Filter;
  CString Parse(const CString&, int&);
  CString Express(const CString& Value, const CString& Expression, int& CurPos);
  CString ReadName(const CString& Expression, int& CurPos);
  CString SkipJunk(const CString& Expression, int& CurPos);
public:
  CProcessor(CFilter *);
  CString Process(const CString&);
  ~CProcessor(void);
};

#endif

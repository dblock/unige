/*
  CField - the field definition (the data container)
  
  Fields are organized in a non recursive tree and are filled and
  parsed by a CFilter

  Daniel Doubrovkine - doubrov5@cuimail.unige.ch / dblock@infomaniak.ch
  University of Geneva - 1998 - All Rights Reserved
  */

#ifndef C_FIELD_H
#define C_FIELD_H

#include <cvector/cvector.h>
#include <cstring/cstring.h>
#include <stdarg.h>
#include <slist/slist_v2.h>

typedef enum {CFEUndefined, CFEString, CFEInteger, CFEDelim, CFESpace,
	      CFETab, CFEReturn, CFEAnything, CFEChar} CFieldElementary;

class CField {
public:
  void Verbose(void);
  CString AsString(void);
  CField(void);
  CField(const CField&);
  CField(const CString&, CFieldElementary);
  CField(const CString&, CField *, ...);
  ~CField(void);
  int operator<(const CField&);
  int operator>(const CField&);
  int operator==(const CField&);
  CField& operator=(const CField&);
  friend ostream& operator<<(ostream& os, const CField& Field);
  CField& operator+=(CField&);
  friend class CFilter;
  int Tag;
  int Skipper;
  void Push(void *);
  void * Pop(void);
private:
  int Bound;
  CString Name;
  CFieldElementary Elementary;
  ilist<CField *> Composite;
  ilist<void *> DataStack;
  ilist<void *> Constraints;
};

#endif


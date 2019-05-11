/* 
   CFilter

   Daniel Doubrovkine - doubrov5@cuimail.unige.ch / dblock@infomaniak.ch
   University of Geneva - 1998 - All Rights Reserved
   */

#ifndef C_FILTER_H
#define C_FILTER_H

#include <cfield/cfield.h>
#include <chashtable/chashtable.h>
#include <cproc/cproc.h>

class CFilter {
public:
  CFilter(void);
  ~CFilter(void);
  int ProcessOption(const CString&);
  CField * Recursive(CField * Head);
  friend class CProcessor;
  CString GetValue(const CString&);
private:
  int Errors;
  void Bailing(CString, const CString&, int);

  CField * FieldExp;
  int Stage;
  int Verbose;
  CString ProcessString;
  
  ilist<CField *> NamedFields;
  ilist<CField *> UnNamedFields;
  CField * FindField(const CString&);
  CField * FindField(const CString&, ilist<CField*>&);
  void DefineFields(const CString&);
  void FillField(CField * Field, const CString& Input, int& CurPos);
  void FillFields(const CString&);
  void FillFields(void);

  void SkipSpaces(const CString&, int&);
  char ReadChar(ilist<void *>& Constraints, const CString& Format, int& CurPos);
  void SkipElement(const CString& Format, int& CurPos, const CField * Element);
  CString ReadString(int, const CString&, int&);
  int ReadInteger(int, const CString&, int&);
  //float ReadFloat(float Min, float Max, const CString&, int&);
  int ReadAssignment(const CString&, int&);
  CField * ReadField(const CString&, int&);
  CField * ReadBounds(CField * Target, const CString& Format, int& CurPos); 
  CField * ReadStaleField(const CString& Format, int& CurPos);
  CField * ReadNamedField(const CString& Format, int& CurPos);
};

#endif


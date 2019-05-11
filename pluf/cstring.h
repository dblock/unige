#ifndef CSTRING_H
#define CSTRING_H

#include <string.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <iostream.h>
#include <stdio.h>
#include <cvector/cvector.h>

const short BUF_MAX=200;

class CString;
typedef void (* GetTermFunction)(CString& Term);

class ICString {
  friend class CString;
private:
  char * str;
  int len;
  int refs;
public:
  int RefCount(void);
  ICString(void);
  ICString(const char *);  
  ICString(const CString&);
  ICString(ICString *);
  void Reg(void);
  void UnReg(void);  
  ~ICString(void);
  ICString * ICSCopy(void);
  char * asString(void);
};

class CString {
  friend istream& operator>>(istream&,CString&);
  friend ostream& operator<<(ostream&,const CString&);  
private:
  void StrError(char *);
  char workbuf[24];
public:
  ICString * ICS;
  int operator==(const CString& s) const;
  int operator==(const char * s) const;
  int operator!=(const CString& s) const;
  int operator!=(const char * s) const;
  CString();
  CString(const char *);
  CString(const CString&);
  ~CString();
  int StrLength(void) const;
  void Free(void);
  char * asString(void) const;
  CString ExtractLine(void);
  CString& ExtractLine(CString&);
  int isSubStr(const CString&) const ;
  int isSubStr(char *) const ;
  int isSubStr(const char *, int) const;
  int isSubStrI(char *) const ;
  int isSubStrI(const CString &) const ;
  int isSubStrI(const CString& s, int startpos) const ;
  int isSubStrI(const char * s, int startpos) const ;
  int isSubStr(const int) const ;
  int Val(void) const;
  long ValLong(void) const;
  float ValFloat(void) const;
  int isEqual(const CString &) const;
  int isEqual(const char *) const;
  int operator<(const CString&) const;
  int operator>(const CString&) const;
  int operator>=(const CString&) const;
  int operator<=(const CString&) const;
  const CString& operator=(const CString&);
  const CString& operator=(const char* );
  void underscore_clean(void);
  void underscore_dirt(void);
  void StrF(void);
  void StrDelete(int start, int count);
  void StrAppend(const char *);
  CString& operator+=(const CString& s);
  CString& operator+=(const char * s);
  CString& operator+=(const int i);
  CString& operator+=(const long i);
  CString& operator+=(const float i);
  CString& operator+=(const double i);
  CString& operator+=(const char i);
  char operator[](const int i) const;
  char& operator[](const int i);
  char GetChar(const int i) const;
  char& GetChar(const int i);
  int hash_sum(void);
  void remove_backslash(void);
  CString& remove_br(void);
  CString& add_br(void);
  CString& Flush(CString&);
  CString& StrInsert(int, const CString&);
  CString& StrTrim32(void);
  CString& StrTrim(void);
  CString& StrTrim(char, char);
  CString& StrTrimRight(void);
  CString& StrTrimRight(char, char);
  CString& StrTrimLeft(char, char);
  CString& StrTrimLeft(void);
  CString Copy(int, int) const;
  CString& Copy(int, int, CString&) const;
  int Pos(const char) const;
  int InvPos(const char) const;
  int Pos(const char, int) const;
  CVector<CString> Tokenizer(const char c) const;
  CVector<CString>& Tokenizer(const char c, CVector<CString>&) const;
  CVector<CString> CString::Tokenizer(const CString&) const;
  CVector<CString> CString::Tokenizer(const char *) const;
  CVector<CString>& CString::Tokenizer(const CString&, CVector<CString>&) const;
  CString& Encrypt(void);
  CString& Decrypt(void);
  int EndsWith(const CString&) const;
  int StartsWith(const CString &) const;
  int StartsWith(const char *) const;
  CString& UpCase(void);
  CString& LowerCase(void);
  int strNStr(const CString& s) const;
  CString& append_backslash(void);
  CString& remove_forward_slash(void);
  void fmakeword(FILE * f, char stop, int * cl);
  char x2c(char * what);
  CString& Appendc2x(char);
  CString& unescape_url(void);
  CString& escape_url(void);
  void untreat_stupid(void);
  CString& plus_to_space(void);
  CString Map(const CVector<CString>& SVector);
  CString& Map(const CString& Expression, const CVector<CString> & SVector, CString& Target);
  CString MapTerm(GetTermFunction) const;
  CString& MapTerm(GetTermFunction Func, CString& Target) const;
  CString& ContractSpaces(void);
};

extern char EmptyChar[];
extern const long int C1;
extern const long int C2;

#define callMemberFunction(object,ptrToMember)  ((object).*(ptrToMember))

extern void CStringQSort(CVector<CString> & vector,  int (*cmp_function) (const CString&, const CString&));
extern CString bool_to_space(int bvalue);
typedef CString& (CString::*CStringMemberFn)(void);
extern void applyCStringVector(CVector<CString>& vector, CStringMemberFn memCString);
typedef CVector<CString> CStringVector;

#endif


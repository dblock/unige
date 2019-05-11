/*
  CProcessor - the transformer of internal data

  Daniel Doubrovkine - doubrov5@cuimail.unige.ch / dblock@infomaniak.ch
  University of Geneva - 1998 - All Rights Reserved
  */

#include "cproc.h"

#define C_VAR ';'

char * Months[] = {"JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"};

CProcessor::CProcessor(CFilter * _Filter){
  Filter = _Filter;
}

CString CProcessor::SkipJunk(const CString& Expression, int& CurPos){
  int cnt = CurPos;
  CString Result;

  while(1) {
    while (Expression[CurPos]&&(Expression[CurPos]!='%')&&(Expression[CurPos]!='\\')) CurPos++;
    if (Expression[CurPos] == '%') {
      switch (Expression[CurPos+1]) {
      case '%':
	Result += Expression.Copy(cnt, CurPos-cnt+1);
	CurPos+=2;cnt=CurPos;
	continue;
      }
      break;
    }
    if (Expression[CurPos] == '\\') {
      if ((Expression[CurPos+1]) == C_VAR) break;
      switch (Expression[CurPos+1]) {
      case 'n':
	Result += Expression.Copy(cnt, CurPos-cnt);
	Result += "\n";
	CurPos+=2;cnt=CurPos;
	continue;
      case 't':
	Result += Expression.Copy(cnt, CurPos-cnt);
	Result += "\t";
	CurPos+=2;cnt=CurPos;
	continue;
      case '\\':
	Result += Expression.Copy(cnt, CurPos-cnt+1);
	CurPos+=2;cnt=CurPos;
	continue;
      default:
	Result += Expression.Copy(cnt, CurPos-cnt);
	CurPos++;
	cnt=CurPos;
	continue;
      }
    } else break;
  }
  if (cnt!=CurPos) Result += Expression.Copy(cnt, CurPos-cnt);
  return Result;
}

CString CProcessor::ReadName(const CString& Expression, int& CurPos){
  if (Expression[CurPos] == '%') {
    CString Result;
    if (Expression[CurPos+1] == C_VAR) {
      Result = "A"; Result+=(FCnt++);
      CurPos+=2;
    } else {
      int cnt = ++CurPos;
      while (isalnum(Expression[CurPos]) && (Expression[CurPos])) CurPos++;
      Result = Expression.Copy(cnt, CurPos-cnt);  
    }
    return Result;
  } else return "";
}

CString CProcessor::Express(const CString& Value, const CString& Expression, int& CurPos){
  CString CurValue; int Cut = 0;
  /*
    while (
    (Expression[CurPos] == '-')||
    (Expression[CurPos] == '+')||
    (Expression[CurPos] == '|')||
    (Expression[CurPos] == '^')||
    (Expression[CurPos] == '=')||
    (Expression[CurPos] == '>')||
    (Expression[CurPos] == '<')||
    (Expression[CurPos] == '~')) {
    */

    int Start = 0;
    int Len = 0;
    Cut = 1;
    if (Expression[CurPos] == '~'){ /* value transformer */
      CurPos++;
      if (Expression[CurPos] == 'm') {
	CurPos++;
	int cVal = Value.Val();
	CurValue+=Months[cVal%12];
      } else {
	CurPos--;
	Cut = 0;
      }
    } else if (Expression[CurPos] == '<') { /* complete to left*/
      CurPos++;
      char cChar = Expression[CurPos++];
      if (cChar) {
	int cSize = Filter->ReadInteger(-1, Expression, CurPos);
	if (cSize) {
	  CString Append; for(int i=0;i<cSize-Value.StrLength();i++) Append+=(cChar);
	  CurValue+=Append;
	  CurValue+=Value;
	}
      } else {
	Filter->Bailing("Invlid completion character!", Expression, CurPos);
	Cut = 0;
      }
    } else if (Expression[CurPos] == '>') { /* complete to right */
      CurPos++;
      char cChar = Expression[CurPos++];
      if (cChar) {
	int cSize = Filter->ReadInteger(-1, Expression, CurPos);
	if (cSize) {
	  CString Append; for(int i=0;i<cSize-Value.StrLength();i++) Append+=(cChar);
	  CurValue+=Value;
	  CurValue+=Append;
	}
      } else {
	Filter->Bailing("Invalid completion character!", Expression, CurPos);
	Cut = 0;
      }
    } else if (Expression[CurPos] == '=') { /* comp */
      CurPos++;
      int NewPos = 0;
      CString Comp = Parse(Filter->ReadString(-1, Expression, CurPos), NewPos);
      while ((Expression[CurPos] == '=')||(Expression[CurPos] == '!')) {
	if (Expression[CurPos]=='=') {
	  CurPos++;
	  int NewPos = 0;
	  CString Res = Parse(Filter->ReadString(-1, Expression, CurPos), NewPos);
	  if (Comp == Value) CurValue+=Res;
	} else if (Expression[CurPos]=='!') {
	  CurPos++;
	  int NewPos = 0;
	  CString Res = Parse(Filter->ReadString(-1, Expression, CurPos), NewPos);
	  if (Comp != Value) CurValue+=Res;
	}
      }
    } else if (Expression[CurPos] == '^') { /* vectorize */
      CVector<CString> Tokens;
      CurPos++;
      if (Expression[CurPos]) {
	Value.Tokenizer(Expression[CurPos++], Tokens);
	int Item = 0;
	while (isdigit(Expression[CurPos])) {
	  Item = Filter->ReadInteger(-1, Expression, CurPos);
	  if ((Tokens.Count() >= Item)&&(Item))
	    CurValue+=Tokens[Item-1];
	  else {
	    Filter->Bailing("Invalid vector index!", Expression, CurPos);
	    Cut = 0;
	    break;
	  }
	}
      } else {
	CurValue+=Value;
	CurPos--;
	Cut = 0;
      }
    } else if (Expression[CurPos] == '-') { /* cut */
      CurPos++;
      if (Expression[CurPos] == '-') {
	CurValue+=Value;
	Cut = 0;
      }
      Start = Filter->ReadInteger(-1, Expression, CurPos);
      CurPos++;
      Len = Filter->ReadInteger(-1, Expression, CurPos);
      if ((Len)&&(Start >=0)) {
	CString Tmp(Value); Tmp.StrDelete(Start, Len);
	CurValue+=Tmp;
      }
    } else if (Expression[CurPos] == '+') { /* cut */
      CurPos++;
      if (Expression[CurPos] == '+') {
	CurValue+=Value;
	Cut = 0;
      }
      Start = Filter->ReadInteger(-1, Expression, CurPos);
      CurPos++;
      Len = Filter->ReadInteger(-1, Expression, CurPos);
      if ((Len)&&(Start >=0)) {
	CurValue+=Value.Copy(Start, Len);
      }
    } else if (Expression[CurPos] == '|') { /* trim */
      CurPos++;
      CString Cur = Value;
      if (Expression[CurPos] == 'l') CurValue+=Cur.StrTrimLeft();
      else if (Expression[CurPos] == 'r') CurValue+=Cur.StrTrimRight();
      else if (Expression[CurPos] == 'b') CurValue+=Cur.StrTrim();
      else if (Expression[CurPos] == 'n') CurValue+=Cur.StrTrim32();      
      else if (Expression[CurPos] == '|') {Cut = 0;}
      else {CurPos--; Cut = 0;}
      CurPos++;
    } else Cut = 0;
    
  if (Cut) return Express(CurValue, Expression, CurPos); else return Value;
}

CString CProcessor::Parse(const CString& Expression, int& CurPos){
  CString Result;
  while (CurPos < Expression.StrLength()){
    Result+=SkipJunk(Expression, CurPos);
    if (CurPos < Expression.StrLength()) Result+=Express(Filter->GetValue(ReadName(Expression, CurPos)), Expression, CurPos);
  }
  return Result;
}

CString CProcessor::Process(const CString& Output){
  int CurPos = 0;
  FCnt = 0;
  return Parse(Output, CurPos);
}

CProcessor::~CProcessor(void){
  
}

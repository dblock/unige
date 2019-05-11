/*
  CFilter - the governor of the whole transformation process
  Daniel Doubrovkine - doubrov5@cuimail.unige.ch / dblock@infomaniak.ch
  University of Geneva - 1998 - All Rights Reserved
  */

#include "cfilter.h"
#include <math.h>

/* predefined fields */

//CField CFUndefined("Undefined", (CFieldElementary) CFEUndefined);
CField CFAnything("Eol", CFEAnything);
CField CFString("String", CFEString);
CField CFInteger("Integer", CFEInteger);
CField CFSpace("Space", CFESpace);
CField CFTab("Tab", CFETab);
CField CFReturn("Return", CFEReturn);
//CField CFDelim("Delimiter", CFEDelim);
CField CFChar("Char", CFEChar);

CString EmptyString;

#define Version "0.0524"

/* default constructor */
CFilter::CFilter(void) {
  Errors = 0;
  Stage = 0;
  Verbose = 0;
}

/* the options processor */
int CFilter::ProcessOption(const CString& Option){
  if (Option == "--help") {
    cout << "PLUF - C++ Programmable Filter - (c) Daniel Doubrovkine - doubrov5@cuimail.unige.ch - v." << Version << endl
	 << "Programmable Linear Usage Filter" << endl
	 << "syntax: "
	 << "pluf [options] <input syntax> <output syntax>" << endl
	 << "\toptions:" << endl
	 << "\t\t--verbose:\tshow field values at runtime" << endl
	 << "\t\t--version:\tversion information" << endl
	 << "\t\t--help   :\tthis help screen" << endl
	 << "\tinput syntax:" << endl
	 << "\t\t(default full named field is <Expression>)" << endl
	 << "\t\t<Named Field> => <Named Field>[,]<Named Field>" << endl
	 << "\t\t<Named Field> => <String>=<Base Expression>" << endl
	 << "\t\t<Base Expression> => <Base Expression>[|]<Sing>" << endl
	 << "\t\t<Sing>=>%[ nscti][;] " << endl
	 << "\toutput syntax:" << endl
	 << "\t\t=><Free><Variable>" << endl
	 << "\t\t<Variable>=>%<Name><Operator>" << endl
	 << "\t\t<Name>=>A<Number>" << endl
	 << "\t\t<Name>=><Named Field>" << endl
	 << "\t\t<Free>=><Free><Escape>" << endl
	 << "\t\t<Escape>=>\\[tn\\]" << endl
	 << "\t\t<Operator>=>[+-|]<Delim>" << endl
	 << "\t\t<Delim>=><Start><Punct><Len>" << endl
	 << "\t\t<Punct>=>[,.?/;:-+=|~...]" << endl
	 << "\t\t<Start,Len>=>[1234567890]" << endl
      	 << "\t\tOperators  are + - | ^ = < >" << endl
	 << "\tcheck http://cuiwww.unige.ch/~doubrov5/uni/compil" << endl;
  } else if (Option == "--verbose") {
    Verbose = 1;
  } else if (Option == "--version") {
    cout << Version << endl;
  } else {
    switch (Stage) {
    case 0: 
      DefineFields(Option); 
      break;
    case 1: 
      ProcessString = Option;
      FillFields();
      break;
    }
    Stage++;
  }
  return 1;
}

CString CFilter::GetValue(const CString& Name){
  CField * Field = FindField(Name);
  if (!Field) Field = FindField(Name, UnNamedFields);
  if (!Field) {
    CString Error = "Variable not found: "; Error+=Name; Error+=" !";
    Bailing(Error, "", -1);
  }
  if (Field) return Field->AsString();
  return "";
}

char CFilter::ReadChar(ilist<void *>& Constraints, const CString& Format, int& CurPos){
  char Result = Format[CurPos++];
  //cout << "ReadChar():: [" << Result << "]" << endl;
  if (!Constraints.Count()) return Result;
  for (int i=0;i<Constraints.Count();i++){
    if (Result == (char) Constraints[i]) return Result;
  }
  
  CString Error = "Expected character in range: [";
  for (int j=0;j<Constraints.Count();j++) Error+= (char) Constraints[j];
  Error += "]!";
  Bailing(Error, Format, CurPos); 

  return 0;
}

CString CFilter::ReadString(int Count, const CString& Format, int& CurPos){
  if (Count > 0) {
    CString Result = Format.Copy(CurPos, Count);
    if (Result.StrLength() < Count) {
      Bailing("Insufficient string length!", Format, CurPos);
    }
    CurPos+=Result.StrLength();
    return Result;
  } else if (Format[CurPos] == '(') {
    int Rec = 1;
    for (int i=CurPos+1;i<Format.StrLength();i++) {
      if (Format[i] == ')') {Rec--; if (!Rec) {Rec = i; break;}} 
      else if (Format[i] == '(') Rec++;
    }
    if (Rec>= 0) {
      CString Result(Format);
      Result.StrDelete(Rec, Result.StrLength());
      Result.StrDelete(0, CurPos+1);
      CurPos = Rec+1;
      return Result;
    } else {
      Bailing("Unsatisfied parenthesis ')'", Format, CurPos);
    }


  } else {
    
    SkipSpaces(Format, CurPos);
    int cnt = 0;
    while (isalnum(Format[CurPos]) || (Format[CurPos] == '_') || (Format[CurPos] == ' ')){
      if (((Format[CurPos] == ' ') || isdigit(Format[CurPos]))&&(Count == -1)) break;
      CurPos++;
      cnt++;
    }
    CString Result;
    if (cnt) Result = Format.Copy(CurPos-cnt, cnt); else {
      Bailing("Empty string!", Format, CurPos);
    }
    return Result;
  }
}

int CFilter::ReadInteger(int Count, const CString& Format, int& CurPos){ 
  int cnt=0;
  while ((Format[CurPos] == ' ')&&(Format[CurPos])&&(cnt<Count)) { cnt++; CurPos++;}
  if (cnt == Count) {
    Bailing("Expected integer!", Format, CurPos);
    return 0;
  }

  int Sign=1;
  if (Format[CurPos] == '-') {
    Sign=-1;CurPos++;cnt++;
  } else if (Format[CurPos] == '+') {
    CurPos++; 
    Sign=1;
    cnt++;
  }

  if (cnt == Count) {
    Bailing("Expected integer!", Format, CurPos);
    return 0;
  }

  int Result = 0;
  while (Format[CurPos] == '0') {
    CurPos++;
    if (cnt++ == Count) break;
  }

  while (isdigit(Format[CurPos])) {
    Result*=10; Result+=Format[CurPos++]-'0';
    if (++cnt == Count) break;
  }
  
  if ((cnt == 0)||(cnt < Count)) {
    Bailing("Expected integer!", Format, CurPos);
    return 0;
  }

  Result*=Sign;
  //cout << "[" << Result << "]" << endl;
  return Result;
}

/*
  float CFilter::ReadFloat(float Min, float Max, const CString& Format, int& CurPos){
  SkipSpaces(Format, CurPos);
  float Result = 0;
  Result = ReadInteger(-1, 0, Format, CurPos);
  if ((Format[CurPos] == ',')||(Format[CurPos] == '.')) {
  CurPos++;
  int CurPosTemp = CurPos;
  Result+=(ReadInteger(-1, 0, Format, CurPos)/pow(10,CurPos-CurPosTemp)); 
  }
  if ((Min>=0) && ((Result < Min)||(Result > Max))) {
  cerr << "[" << Errors++ << "] CFilter::ReadInteger() - expected integer ranging from " << Min << " to " << Max << "! (position: " << CurPos << ")" << endl;
  Bailing();
  }
  return Result;
  }
  */

void CFilter::SkipElement(const CString& Format, int& CurPos, const CField * Element){
  if (Element->Elementary == CFESpace) while(Format[CurPos] == ' ') CurPos++;
  else if (Element->Elementary == CFETab) while(Format[CurPos] == '\t') CurPos++;
  else if (Element->Elementary == CFEReturn) while((Format[CurPos] > 0)&&(Format[CurPos] < ' ')) CurPos++;
  else if ((Element->Elementary == CFEAnything)||(Element->Elementary == CFEChar)) {
    while(!((Format[CurPos] >= 0)&&(Format[CurPos] < ' '))) CurPos++;
    while((Format[CurPos] > 0)&&(Format[CurPos] < ' ')) CurPos++;
  } else if (Element->Elementary == CFEString) ReadString(Element->Bound,Format, CurPos);
  else if (Element->Elementary == CFEInteger) ReadInteger(Element->Bound,Format, CurPos);
  else {
    Bailing("Invalid element to skip!", Format, CurPos);
  }
}

void CFilter::SkipSpaces(const CString& Format, int& CurPos){
  while((Format[CurPos] <= ' ') && (Format[CurPos] > 0)) CurPos++;
}

CField * CFilter::FindField(const CString& Name){
  return FindField(Name, NamedFields);
}

CField * CFilter::FindField(const CString& Name, ilist<CField *>& Fields){
  for (int i=0;i<Fields.Count();i++)
    if (Fields[i]->Name == Name) return Fields[i];
  return 0;
}

CField * CFilter::ReadBounds(CField * Target, const CString& Format, int& CurPos){
  CurPos++;  
  if (Target->Elementary == CFEChar){
    while((isprint(Format[CurPos])) && (Format[CurPos]!='%') && !((Format[CurPos] > 0)&&(Format[CurPos] < ' ')) && (Format[CurPos] != '|') && (Format[CurPos] != ',')) {
      if (Format[CurPos] == '-') {
	if (!(Target->Constraints.Count())) {
	  Bailing("Unexpected '-'", Format, CurPos++);
	} else {
	  if (Format[CurPos+1] < Format[CurPos-1]) {
	    CString Error = "Invalid range: ["; Error+=Format[CurPos-1];Error+='-';Error+=Format[CurPos+1];Error+="] !";
	    Bailing(Error, Format, CurPos++);
	  } else {
	    for (int i=Format[CurPos-1];i<=Format[CurPos+1];i++) /*if !(Target->Constraints.FindElt())*/ Target->Constraints+=(void *) i;
	    CurPos+=2;
	  }
	}
      } else Target->Constraints+=(void *) Format[CurPos++];
    }
  } else {
    Target->Bound = ReadInteger(-1, Format, CurPos);
    if (Target->Bound < 0) {
      Bailing("Invalid field bound!", Format, CurPos);
    }
  }
  return Target;
}

CField * CFilter::ReadStaleField(const CString& Format, int& CurPos){
  CurPos+=2;
  CField * Current = 0;
  
  if (Format[CurPos-1] == 'n') Current = new CField(CFReturn);
  else if (Format[CurPos-1] == 'c') Current = new CField(CFChar);
  else if (Format[CurPos-1] == ';') Current = new CField(CFAnything);
  else if (Format[CurPos-1] == 't') Current = new CField(CFTab);
  else if (Format[CurPos-1] == ' ') Current = new CField(CFSpace);
  else if (Format[CurPos-1] == 's') Current = new CField(CFString);
  else if (Format[CurPos-1] == 'i') Current = new CField(CFInteger);
  else {
    Bailing("Expected format identifier!", Format, CurPos);
  }
  if (Current) {
    Current->Name = "A";
    Current->Name+=UnNamedFields.Count();
    UnNamedFields+=Current;
    if (Format[CurPos] == ';') {
      CurPos++;
      Current->Skipper = 1;
    } 
    if (Format[CurPos] == ':') return ReadBounds(Current, Format, CurPos);
    return Current;
  } else return 0;
}

CField * CFilter::ReadNamedField(const CString& Format, int& CurPos){
  CString Name = ReadString(-2, Format, CurPos);

  CField * LField = FindField(Name);
  if (LField) {
    Bailing("Name already defined!", Format, CurPos);
    return 0;
  }

  if (ReadAssignment(Format, CurPos)) {
    //cout << "(new field definition): " << Name << endl;
    CField * Result = new CField(Name, 0);
    NamedFields+=Result;
    while (CurPos < Format.StrLength()) {
      CField * Tmp = ReadField(Format, CurPos);
      if (Tmp) (*Result)+=*Tmp; else break;
      if (Format[CurPos] == '|') CurPos++;
      else if (Format[CurPos] == ',') {
	CurPos++;
	break;
      }
    }
    return Result;
  } else {
    return 0;
  }
}

CField * CFilter::ReadField(const CString& Format, int& CurPos){
  if ((Format[CurPos] == '%')||(Format[CurPos] == '$')) {
    return ReadStaleField(Format, CurPos);
  } else {
    return ReadNamedField(Format, CurPos);
  }
}

CField * CFilter::Recursive(CField * Head){
  if (Head->Tag) {
    Head->Tag = 0;
    return Head;
  } else {
    Head->Tag = 1;
    CField * Result;
    for(int i=0;i<Head->Composite.Count();i++)
      if ((Result = Recursive(Head->Composite[i]))) return Result;
    Head->Tag = 0;
    return 0;
  }	
}

int CFilter::ReadAssignment(const CString& Format, int& CurPos){
  if (Format[CurPos++] == '=') return 1; else {
    Bailing("Expected '=' !", Format, CurPos);
  }
  return 0;
}

void CFilter::DefineFields(const CString& FieldsFormat){
  int CurPos = 0;
  
  CString Fields = "Expression="; Fields+=FieldsFormat;

  FieldExp = ReadField(Fields, CurPos);  

  CField * Rec = Recursive(FieldExp);
  if (Rec) {
    //cerr << "[" << Errors << "] CFilter::DefineFields() - infinite recursion at [" << Rec->Name << "]" << endl;
    Bailing("Infinite recursion!", "", -1);
  }
  if (Errors) {
    cerr << "[" << Errors << "] CFilter::DefineFields() - syntax errors!" << endl;
    exit(0);
  }
}

void CFilter::FillFields(void){
  CString Input;
  char c;
  while (1) {
    c = (char) cin.get();
    if (cin.eof()) break;
    Input += c;
  }
  FillFields(Input);
}

void CFilter::FillFields(const CString& Input){
  int CurPos = 0;
  CProcessor Process(this);
  while (CurPos < Input.StrLength()) {
    FillField(FieldExp, Input, CurPos);
    if (Verbose) FieldExp->Verbose();
    cout << Process.Process(ProcessString);     
  }
}

void CFilter::FillField(CField * Field, const CString& Input, int& CurPos){
  if (Field->Composite.Count()) {
    for (int i=0;i<Field->Composite.Count();i++) {
      if (CurPos >= Input.StrLength()) break;
      FillField(Field->Composite[i], Input, CurPos);
    }
  } else {
    if (Field->Skipper) SkipElement(Input, CurPos, Field);
    else if (Field->Elementary == CFEChar) Field->Push(new char(ReadChar(Field->Constraints, Input, CurPos)));
    else if (Field->Elementary == CFEString) Field->Push(new CString(ReadString(Field->Bound, Input, CurPos)));
    else if (Field->Elementary == CFEInteger) Field->Push(new int(ReadInteger(Field->Bound, Input, CurPos)));
    else {
      Bailing("Invalid type!", Input, CurPos);
    }
  }
}

CFilter::~CFilter(void){
  //cout << "CFilter::~CFilter(void)" << endl;
}

void CFilter::Bailing(CString Error, const CString& Expression, int Pos){
  if (Pos > 0) {
    cout << "[" << Errors++ << "] - Sorry Dave, error at pos " << Pos << ": " << Error << endl;
    int dPos=0; int cPos = Pos-5; if (cPos < 0) {dPos=cPos+5;cPos = 0;} else dPos = 5;
    cout << "\t" << Expression.Copy(cPos, 10) << endl;
    cout << "\t"; for(int i=0;i< dPos;i++) cout << " ";
    cout << "^" << endl;
  } else {
    cout << "[" << Errors++ << "] - Error! " << Error << endl;
  }

  if (Errors > 5) {
    cerr << "CFilter::Error! - too many errors, bailing out" << endl;
    exit(0);
  }
}




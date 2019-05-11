#include "cstring.h"

#define DEBUG_CSTRING

#ifndef strncmpi
#define strncmpi strncasecmp
#define strcmpi strcasecmp
#endif

static ICString EmptyICS;
static int ICSHandleDeleted = 0;

ICString::ICString(void){
  len = 0;
  str = 0;
  refs = 1;
}

int ICString::RefCount(void){
  return refs;
}

ICString::ICString(const char * s){	
  if (s) {
    len = strlen(s);
    str = new char[len+1];
    memcpy(str, s, len);
    str[len]=0;
  } else {
    len = 0;
    str = 0;		
  }
  refs = 1;	
}

ICString::ICString(const CString& s){
  if (s.ICS&&s.ICS->str) {
    len = s.ICS->len;
    str = new char[len+1];
    memcpy(str, s.ICS->str, len+1); 		
  } else {
    len = 0;
    str = 0;		
  }
  refs = 1;
}

ICString::ICString(ICString * ICS){
  if (ICS&&ICS->str) {
    len = ICS->len;
    str = new char[len+1];
    memcpy(str, ICS->str, len+1); 		
  } else {
    len = 0;
    str = 0;		
  }
  refs = 1;
}

void ICString::Reg(void){
  refs++;
}

void ICString::UnReg(void){
  if ((!(--refs))&&(this != &EmptyICS)) delete this;	
}

ICString::~ICString(void){
  if (this == &EmptyICS) ICSHandleDeleted = 1;
  if (str) delete str;
}

ICString * ICString::ICSCopy(void){
  if (refs > 1) {
    ICString * NewICS = new ICString(this);
    UnReg();
    return NewICS;
  } else return this;	
}

char * ICString::asString(void){
  if (str) return str; else return "";
}

const long int C1 = 52845;
const long int C2 = 11719;

void CStringQSort(CVector<CString> & vector,  int (*cmp_function) (const CString&, const CString&));
CString bool_to_space(int bvalue);

void applyCStringVector(CVector<CString>& vector, CStringMemberFn memCString){
  for(int i=0;i<vector.Count();i++)
    callMemberFunction(vector.GetElt(i), memCString)();
}

CString CString::Map(const CVector<CString>& SVector){
  CString Tmp;
  Map((* this), SVector, Tmp);
  return Tmp;
}

CString CString::MapTerm(GetTermFunction Func) const {
  CString Target;
  MapTerm(Func, Target);
  return Target;
}

CString& CString::Flush(CString& Target){
  if (Target.ICS) Target.ICS->UnReg();
  Target.ICS = ICS;
  ICS = &EmptyICS;
  ICS->Reg();
  return Target;
}

CString& CString::MapTerm(GetTermFunction Func, CString& Target) const {
  CString Term;
  int curPos = 0, prevPos = 0;
  CString Prefix;
  CString Postfix;
  CString Elsefix;
  int Regular, TagChar, IdChar;
  while (curPos < ICS->len){
    if ((ICS->str[curPos] == '$')||(ICS->str[curPos]=='�')) {
      IdChar = ICS->str[curPos];
      Prefix.Free();
      Postfix.Free();
      Elsefix.Free();
      Target+=Copy(prevPos, curPos-prevPos);
      curPos++;prevPos = curPos;
      while (isalnum(ICS->str[curPos]) || (ICS->str[curPos] == '.')) curPos++;
      Term = Copy(prevPos, curPos-prevPos);
      prevPos = curPos;
      while ((ICS->str[curPos] == '~')||(ICS->str[curPos] == '#')||(ICS->str[curPos] == '^')) {
	TagChar = ICS->str[curPos];
	if (ICS->str[curPos+1] == '[') Regular=1; else Regular=0;
	curPos++;prevPos = curPos;
	if (Regular) {
	  prevPos++;
	  Regular++;
	  while (ICS->str[curPos]) {
	    curPos++;
	    if (ICS->str[curPos] == '[') Regular++;
	    else {
	       if (ICS->str[curPos] == ']') Regular--;
	       if (Regular == 1) break;
	    }
	  }
	  if (ICS->str[curPos] == ']') curPos++;
	  if (TagChar == '~') Prefix=Copy(prevPos,curPos-prevPos-1).MapTerm(Func);
	  else if (TagChar == '#') Postfix = Copy(prevPos,curPos-prevPos-1).MapTerm(Func);
	  else if (TagChar == '^') Elsefix = Copy(prevPos,curPos-prevPos-1).MapTerm(Func);
	} else {
	  while ((ICS->str[curPos]>' ')&&(ICS->str[curPos]!='#')&&(ICS->str[curPos]!='~')&&(ICS->str[curPos]!='^')) curPos++;
	  if (TagChar == '~') Prefix=Copy(prevPos,curPos-prevPos).MapTerm(Func);
	  else if (TagChar == '#') Postfix = Copy(prevPos,curPos-prevPos).MapTerm(Func);
	  else if (TagChar == '^') Elsefix = Copy(prevPos,curPos-prevPos).MapTerm(Func);
	}
	prevPos = curPos;
      }
      
      //if (Prefix.ICS->len) Prefix = Prefix.MapTerm(Func);
      //if (Postfix.ICS->len) Postfix = Postfix.MapTerm(Func);
      //if (Elsefix.ICS->len) Elsefix = Elsefix.MapTerm(Func);

      Func(Term);
      
      if (Term.ICS->len){
	Target+=Prefix;
	if (IdChar != '�') Target+=Term;
	Target+=Postfix; 
      } else Target+=Elsefix;
      
    } else curPos++;
  }
  Target+=Copy(prevPos, ICS->len);
  return Target;
}

CString& CString::Map(const CString& Expression, const CVector<CString> & SVector, CString& Target){
  Target.Free();
  int DPos = Expression.Pos('$');
  int i, PPos=0;
  while (DPos >= 0) {
    Target+=Expression.Copy(PPos, DPos-PPos);
    i=DPos+1;
    while ((Expression[i]<='9')&&(Expression[i]>='0')) i++;
    PPos = i;
    if (i!=DPos) {
      i = Expression.Copy(DPos+1, i-DPos).Val();
      if (i>=0) {
	if (SVector.Count() <= i) cout << "CString::Map(Error):- invalid index in regular expression - [" << (* this) << "][<b>" << i << "</b>]<br>\n";
	else Target+=SVector[i];
      }
    }    
    DPos = Expression.Pos('$', DPos+1);
  }
  Target+=Expression.Copy(PPos, Expression.ICS->len);
  return Target;
}


CString CString::ExtractLine(void){  
  CString Target;
  ExtractLine(Target);
  return Target;
}

CString& CString::ExtractLine(CString& Target){  
  int iPos = Pos('\n');
  if (iPos >= 0) {
    Target = Copy(0, iPos++);
    StrDelete(0, iPos);   
  } else {
    Flush(Target);
  }
  return Target;
}

CString& CString::plus_to_space(void){
  if (ICS->len){
    for (int i=0;i<ICS->len;i++) 
      if (ICS->str[i] == '+') {
	ICS = ICS->ICSCopy();
	ICS->str[i] = ' ';
      }
  }
  return(* this);
}

long CString::ValLong(void) const {
  if (ICS->len) return atol(ICS->str); else return 0;
}

int CString::Val(void) const {
  if (ICS->len) return atoi(ICS->str); else return 0;
}

float CString::ValFloat(void) const {
  if (ICS->len) return (float) atof(ICS->str); else return 0;
}

char * CString::asString(void) const{
  return ICS->asString();	
}

CString& CString::UpCase(void){
  if (ICS->len) {
    for (int i = 0;i<ICS->len;i++) 
		if ((ICS->str[i]<='z')&&(ICS->str[i]>='a')) {
			ICS = ICS->ICSCopy();			
			ICS->str[i]-=('a' - 'A');
		}
  }
  return(* this);
}

CString& CString::LowerCase(void){
  if (ICS->len) {
    for (int i = 0;i<ICS->len;i++) 
		if ((ICS->str[i]<='Z')&&(ICS->str[i]>='A')) {
			ICS = ICS->ICSCopy();
			ICS->str[i]+=('a' - 'A');
		}
  }
  return(* this);
}

int CString::EndsWith(const CString& iStr) const {
  if (ICS->len < iStr.ICS->len) return 0;
  if (strcmpi(iStr.ICS->str, ICS->str + ICS->len - iStr.ICS->len)) return 0;
  return 1;
}

int CString::StartsWith(const char * iStr) const {   
   if (!iStr) return 1;
   if ((unsigned int) ICS->len < strlen(iStr)) {return 0;}   
   if (ICS->str) return (!(strncmpi(ICS->str, iStr, strlen(iStr)))); else return 0;
}

int CString::StartsWith(const CString& iStr) const {
   if (ICS->len < iStr.ICS->len) return 0;
   return (!(strncmpi(ICS->str, iStr.asString(), iStr.ICS->len)));
}

CString& CString::Encrypt(void){
  int len = ICS->len;
  if (len){		
    char t;
    int key = 1234;
    int i;
    char * tStr = new char[len*2+1];
    for (i=0;i<len;i++){
      t = ICS->str[i] ^ (key >> 8);
      tStr[2*i] = (t & 15) + 64;
      tStr[2*i+1] = ((t & 240) >> 4) + 64;
      key = (t + key) * C1 + C2;
    }
    tStr[len*2]='\0';
    ICS->UnReg();
    ICS = new ICString();
    ICS->str = tStr;
    ICS->len = len*2;	
  }
  return(* this);
}

CString& CString::Decrypt(void){
  int len = ICS->len;
  if (len){
    char t;
    int key = 1234;
    int i;
    len/=2;
    char * tStr = new char[len+1];
    for (i=0;i<len;i++){
      t = (ICS->str[2*i] - 64)  + ((ICS->str[2*i+1] - 64) << 4);
      tStr[i] = t ^ (key >> 8);
      if (!tStr[i]) {
	len = i;
	break;
      }
      key = (t + key) * C1 + C2;
    }
    tStr[len]='\0';
    ICS->UnReg();
    ICS = new ICString(tStr);
    delete tStr;
    //ICS->str = tStr;
    //ICS->len = len; 
  }
  return(*this);
}

CVector<CString> CString::Tokenizer(const CString& iStr) const {
	CVector<CString> retVector;  
	Tokenizer(iStr, retVector);
	return retVector;
}

CVector<CString>& CString::Tokenizer(const CString& iStr, CVector<CString>& retVector) const{
  assert(iStr.ICS->len);
  retVector.Clear();
  CString Current(* this);  
  Current.UpCase();
  CString Target(iStr);
  Target.UpCase();
  int i,j = 0;
  i = Current.isSubStr(Target.asString(), j);
  while (i>=0) {
    CString tmp = Copy(j, i-j);
    retVector+=tmp;
    j = i+iStr.ICS->len;
    i = Current.isSubStr(Target.asString(), j);
  }
  retVector+=Copy(j, ICS->len - j);
  return(retVector);
}

CVector<CString> CString::Tokenizer(const char * str) const {
  CString Dummy(str);
  return Tokenizer(Dummy);
}

CVector<CString> CString::Tokenizer(const char c) const {
	CVector<CString> retVector;
	Tokenizer(c, retVector);
	return retVector;
}

CVector<CString>& CString::Tokenizer(const char c, CVector<CString>& retVector) const {
  assert(c);  
  retVector.Clear();
  int i,j = 0;
  i = Pos(c, j);  
  while (i>=0) {
    retVector+=Copy(j,i-j);
    j = i+1;
    i = Pos(c, j);
  }
  retVector+=Copy(j, ICS->len-j);  
  return (retVector);
}

void CString::Free(void){		
	if (ICS!=&EmptyICS){
		ICS->UnReg();	
		ICS = &EmptyICS;
		ICS->Reg();		
	}
}

int CString::Pos(const char c) const{
  return Pos(c, 0);
}

int CString::InvPos(const char c) const {
  if (!ICS->len) return -1;
  for (int i=ICS->len-1;i>=0;i--) if (ICS->str[i]==c) return(i);
  return -1;
}

int CString::Pos(const char c, int start) const {
  if (!ICS->len) return -1;
  if (start >= ICS->len) return -1;
  for (int i=start;i<ICS->len;i++) if (ICS->str[i]==c) return i;
  return -1;
}

CString CString::Copy(int start, int len) const {
	CString ret;
	Copy(start, len, ret);
	return ret;
}

CString& CString::Copy(int start, int len, CString& ret) const{
  ret.Free();
  if ((start<0)||(start>=ICS->len)||(len<=0)) {   
	return ret;
  }
  if (start + len > ICS->len) len = ICS->len - start;
  if (!len) {
	return ret;
  }  
  char * res = new char[len+1];  
  memcpy(res, ICS->str+start, len);
  res[len]=0;  
  ret.ICS->UnReg();  
  ret.ICS = new ICString();
  ret.ICS->str = res;
  ret.ICS->len = len;    
  return ret;
}

CString& CString::StrTrim32(void){
  StrTrimRight(1, 32);
  StrTrimLeft(1, 32);
  return(*this);
}

CString& CString::StrTrimRight(void){
  return StrTrimRight(' ', ' ');
}

CString& CString::StrTrimLeft(void){
  return StrTrimLeft(' ', ' ');
}

CString& CString::StrTrimRight(char l, char r){
  if (ICS->len){
    char * iPos = ICS->str + ICS->len - 1;
    while ((iPos>=ICS->str)&&(iPos[0]>=l)&&(iPos[0]<=r)) iPos--;
    StrDelete(iPos-ICS->str+1, ICS->len-(iPos-ICS->str)+1);
  }
  return(*this);
}

CString& CString::StrTrimLeft(char l, char r){
  if (ICS->len) {
    char * iPos = ICS->str;
    while ((iPos[0]>=l)&&(iPos[0]<=r)&&(iPos[0])) iPos++;
    StrDelete(0, iPos-ICS->str);
  }
  return(*this);
}

CString& CString::StrTrim(void){
  StrTrimRight();
  StrTrimLeft();
  return(*this);
}

CString& CString::StrTrim(char l, char r){
  StrTrimRight(l, r);
  StrTrimLeft(l, r);
  return(*this);
}

void CString::StrError(char * error){
  cerr << "CString::" << error << endl;
  exit(-1);
}

CString::CString(void){
  ICS = &EmptyICS;
  ICS->Reg();
};

CString::CString(const char * pc){
  if (pc&&strlen(pc)){
    ICS = new ICString(pc);	
  } else {
    ICS = &EmptyICS;
    ICS->Reg();
  }
}

CString::CString(const CString& s) {
  ICS = s.ICS;
  ICS->Reg();	
}

int CString::isSubStr(const char * s, int startpos) const {
  assert(s);
  if (!ICS->str||!ICS->len) return -1;
  assert((startpos>=0));
  if (startpos >= ICS->len) return -1;
  char * res = strstr(ICS->str+startpos, s);
  if (res) return (res - ICS->str); else return -1;
}

int CString::isSubStrI(const CString& s, int startpos) const{
  assert(s.ICS->str);
  if (!ICS->str||!ICS->len) return -1;
  //assert((startpos>=0)&&(startpos<ICS->len)
  if ((startpos<0)||(startpos>=ICS->len)) return -1;
  CString l(* this);
  CString r(s);
  r.UpCase();
  l.UpCase();
  char * res = strstr(l.ICS->str + startpos, r.ICS->str);
  if (res) return (res - l.ICS->str); else return -1;
}

int CString::isSubStrI(const char * s, int startpos) const{
  CString r(s);
  return isSubStrI(r, startpos);
}

int CString::isSubStrI(const CString& s) const{
  assert(s.ICS->str);
  if (!ICS->len) return -1;
  CString l(* this);
  l.UpCase();
  CString r(s);
  r.UpCase();
  char * res = strstr(l.ICS->str, r.ICS->str);
  if (res) return (res - l.ICS->str); else return -1;
}

int CString::isSubStrI(char * s) const {
  assert(s);
  if (!ICS->len) return -1;
  CString l(* this);
  l.UpCase();
  CString r(s);
  r.UpCase();
  char * res = strstr(l.ICS->str, r.ICS->str);
  if (res) return (res - l.ICS->str); else return -1;
}

int CString::isSubStr(const int c) const {
  if (!ICS->len) return -1;
  char * res = strchr(ICS->str, c);
  if (res) return res - ICS->str; else return -1;
}

int CString::isSubStr(char * s) const {
  if (!s||!ICS->len) return -1;
  char * res = strstr(ICS->str, s);
  if (res) return (res-ICS->str); else return -1;
}

int CString::isSubStr(const CString& s) const {
  if (!s.ICS->len||!ICS->len) return -1;
  char * res = strstr(ICS->str, s.ICS->str);
  if (res) return (res - ICS->str); else return -1;
}

int CString::strNStr(const CString& s) const {
  if ((!ICS->len)||(!s.ICS->len)) return 0;
  CString Source = (* this);
  CString Target = s;
  return (Source==Target);
}

int CString::isEqual(const CString& s) const {
  if ((!ICS->len)||(!s.ICS->len)) return 0;
  if (ICS == s.ICS) return 1;
  return(!strcmpi(ICS->str, s.ICS->str));
}

int CString::isEqual(const char * s) const {
  if ((!ICS->len)||(!s)) return 0;
  return(!strcmpi(ICS->str, s));
}

int CString::operator>=(const CString& s) const {
  if (ICS == s.ICS) return 1;

  if (!ICS->len&&!s.ICS->len) return 1;
  if (!ICS->len) return 0;
  if (!s.ICS->len) return 1;

  if (strcmpi(ICS->str,s.ICS->str)>=0) return 1;
  else return 0;
}

int CString::operator<=(const CString& s) const {
  if (ICS == s.ICS) return 1;

  if (!ICS->len&&!s.ICS->len) return 1;
  if (!ICS->len) return 1;
  if (!s.ICS->len) return 0;

  if (strcmpi(ICS->str,s.ICS->str)<=0) return 1;
  else return 0;
}

int CString::operator>(const CString& s) const {
  if (ICS == s.ICS) return 0;
  
  if (!ICS->len&&!s.ICS->len) return 0;
  if (!ICS->len) return 0;
  if (!s.ICS->len) return 1;

  if (strcmpi(ICS->str,s.ICS->str)>0) return 1;
  else return 0;
}


int CString::operator<(const CString& s) const {
  if (ICS == s.ICS) return 0;

  if (!ICS->len&&!s.ICS->len) return 0;
  if (!ICS->len) return 1;
  if (!s.ICS->len) return 0;

  if (strcmpi(ICS->str,s.ICS->str)<0) return 1; else return 0;
}

const CString& CString::operator=(const char* pc) {
	if (ICS) ICS->UnReg();
	if (pc&&strlen(pc)) {		
		ICS = new ICString(pc);  
	} else {
		ICS = &EmptyICS;
		ICS->Reg();
	}
  return *this;
}

CString::~CString() {
  if ((!ICSHandleDeleted)&&(ICS)) ICS->UnReg();
}

const CString& CString::operator=(const CString& s) {		
  if (!s.ICS){
    if (ICS) ICS->UnReg();
    ICS = new ICString();		
  } else if (ICS!=s.ICS){		
    if (ICS) ICS->UnReg();
    ICS = s.ICS;
    ICS->Reg();
  } else if ((&s != this)&&(ICS)) ICS->Reg();
  return *this;	
}

ostream& operator<<(ostream& os, const CString& sStr){
  os << sStr.asString();
  return os;
}

istream& operator>>(istream& is,CString& sStr) {
  char inbuf[BUF_MAX],ch;
  while(1) {
    ch='\n';
    while ((ch=='\n')||(ch==' ')) {
      ch=is.get();
      if ((ch!='\n')&&(ch!=' ')) {
	is.putback(ch);
	break;
      }
    }
    is.getline(inbuf,BUF_MAX-1);
  }
  sStr=inbuf;
  return is;
}

void CString::underscore_clean(void){
  if (ICS->len) 
	for (int i = 0;i<ICS->len;i++) 
		if (ICS->str[i] == '_') {
			ICS = ICS->ICSCopy();
			ICS->str[i] = ' ';
		}
}

void CString::underscore_dirt(void){
  if (ICS->len) 
	  for (int i = 0;i<ICS->len;i++) 
		  if (ICS->str[i] == ' ') {
			  ICS = ICS->ICSCopy();
			  ICS->str[i] = '_';
		  }
}

void CString::StrDelete(int start, int count) {	
  if (ICS->len&&count){
    if (start+count > ICS->len) count = ICS->len - start;
	if (count >= ICS->len) Free();
	else {		
		char * new_str = new char[ICS->len - count + 1];
		for(int i=0;i<start;i++) new_str[i]=ICS->str[i];
		for(int j=start+count;j<ICS->len;j++) new_str[j-count]=ICS->str[j];
		int len = ICS->len - count;
		new_str[len] = 0;		
		ICS->UnReg();
		ICS = new ICString();
		ICS->len = len;
		ICS->str = new_str;		
		}
	}	
}

void CString::StrAppend(const char * s){
  if (s) {
    int jLen = strlen(s);
    int iLen = ICS->len;
    char * newStr = new char[ICS->len+jLen+1];
    assert(newStr);
    if (ICS->len) {
      memcpy(newStr, ICS->str, ICS->len);      
      memcpy(newStr+ICS->len, s, jLen);	  
    } else memcpy(newStr, s, jLen);
    ICS->UnReg();	
    iLen = iLen + jLen;
    newStr[iLen] = 0;  
    ICS = new ICString();
    ICS->str = newStr;
    ICS->len = iLen;    
  }
}

CString& CString::operator+=(const char i){
  workbuf[0] = i;
  workbuf[1] = 0;
  StrAppend(workbuf);
  return(* this);
}

CString& CString::operator+=(const int i){
  sprintf(workbuf, "%d", i);
  StrAppend(workbuf);
  return(*this);
}

CString& CString::operator+=(const long i){
  sprintf(workbuf, "%ld", i);
  StrAppend(workbuf);
  return(*this);
}

CString& CString::operator+=(const float i){
  sprintf(workbuf, "%f", i);
  StrAppend(workbuf);
  return(*this);
}

CString& CString::operator+=(const double i){
  sprintf(workbuf, "%e", i);
  StrAppend(workbuf);
  return(*this);
}

int CString::hash_sum(void){
  int sum = 0;
  char * s;
  for (s=ICS->str;*s!='\0';s++) sum+=tolower(*s);
  return sum;
}

CString& CString::add_br(void){
  int i=0;
  while ((i=isSubStr("\n", i)) >= 0) {
    int ii = i+1;
    while(ICS->str[ii] < ' ') ii++;
    StrDelete(i, ii-i);
    StrInsert(i, "<br>");
    if ((unsigned int) ii-i > strlen("\n")) StrInsert(i, "<br>");
  }
  return(*this);
}

CString& CString::remove_br(void){
  int i=0;
  while ((i = isSubStr("<br>", i)) >= 0) {
	StrDelete(i, strlen("<br>"));
	StrInsert(i, "\n");
  }
  return(*this);
}

void CString::remove_backslash(void){
  if ((ICS->str[ICS->len-1] == '\\')||(ICS->str[ICS->len-1]=='/')) StrDelete(ICS->len - 1, 1);
}

CString& CString::remove_forward_slash(void){
  if (ICS->len) {
    if ((ICS->str[0]=='\\')||(ICS->str[0]=='/')) StrDelete(0, 1);
  }
  return(* this);
}

CString& CString::append_backslash(void){
  if ((!ICS->str)||((ICS->str[ICS->len-1] != '\\')&&(ICS->str[ICS->len-1]!='/')))
  StrAppend("/");
  return (* this);
}

void CString::StrF(void){
  if (ICS->len) {	
    int i, j;
    char * tstr = new char[ICS->len+1];
    for (i = 0, j = 0;i<ICS->len;i++) 
      if ((ICS->str[i] > 32)&&
	  (ICS->str[i] != ' ')&&(ICS->str[i] != '!')&&(ICS->str[i] != '@')&&
	  (ICS->str[i] != '#')&&(ICS->str[i] != '$')&&(ICS->str[i] != '%')&&
	  (ICS->str[i] != '^')&&(ICS->str[i] != '*')&&(ICS->str[i] != '(')&&
	  (ICS->str[i] != ')')&&(ICS->str[i] != '-')&&(ICS->str[i] != '&')&&
	  (ICS->str[i] != '_')&&(ICS->str[i] != '-')&&(ICS->str[i] != '+')&&
	  (ICS->str[i] != '|')&&(ICS->str[i] != '~')&&(ICS->str[i] != '=')&&
	  (ICS->str[i] != '\\')&&(ICS->str[i] != '`')&&(ICS->str[i] != '{')&&
	  (ICS->str[i] != '}')&&(ICS->str[i] != '[')&&(ICS->str[i] != ']')&&
	  (ICS->str[i] != ':')&&(ICS->str[i] != ';')&&(ICS->str[i] != '"')&&
	  (ICS->str[i] != '\'')&&(ICS->str[i] != '<')&&(ICS->str[i] != '>')&&
	  (ICS->str[i] != '?')&&(ICS->str[i] != '/')&&(ICS->str[i] != ',')&&
	  (ICS->str[i] != '.')
	  ) tstr[j++] = ICS->str[i];
    tstr[j]='\0';
	ICS->UnReg();
    ICS = new ICString();
	ICS->str = new char[j+1];
    memcpy(ICS->str, tstr, j);
	ICS->len = j;	
    delete tstr;
    ICS->str[ICS->len] = 0;
  }
}

void CString::fmakeword(FILE * f, char stop, int *cl) {
  ICS = ICS->ICSCopy();
  char c;
  while((!feof(f))&&(--(*cl))) {
    c = (char) fgetc(f);
    if (c == stop) {
      return;
    }
    (* this)+=(char) c;
  }
}

char CString::x2c(char * what) {
  char digit;
  digit = (what[0] >= 'A' ? ((what[0] & 0xdf) - 'A')+10 : (what[0] - '0'));
  digit *= 16;
  digit += (what[1] >= 'A' ? ((what[1] & 0xdf) - 'A')+10 : (what[1] - '0'));
  return(digit);
}

CString& CString::Appendc2x(char c){
  workbuf[0]='`';
  sprintf(workbuf+1, "%02X", c);
  workbuf[3] = 0;
  StrAppend(workbuf);
  return(*this);
}

CString& CString::escape_url(void){
  if (ICS->len) {
    CString Tmp;
    int prev = 0;
    for (int i=0;i<ICS->len;i++){
      if (!(isalnum(ICS->str[i])) && (ICS->str[i]!=' ') && (ICS->str[i]>0)){
		if (i>prev) Tmp+=Copy(prev, i-prev);
		prev = i+1;
		Tmp.Appendc2x(ICS->str[i]);
      }
    }
    Tmp+=Copy(prev, ICS->len-prev);    
    (* this) = Tmp;
  }
  return (* this);
}

CString& CString::unescape_url(void) {
  if (ICS->len){
	ICS = ICS->ICSCopy();
    int x,y;
    for(x=0,y=0;ICS->str[y];++x,++y) {
      if(((ICS->str[x] = ICS->str[y]) == '%')||(ICS->str[x]=='`')) {
	ICS->str[x] = x2c(&ICS->str[y+1]);
	y+=2;
	if (ICS->str[x]=='`') {
	  ICS->str[x] = x2c(&ICS->str[y+1]);
	  y+=2;
	}
      }
    }
    ICS->str[x] = '\0';
    char * newStr = new char[x+1];
	memcpy(newStr, ICS->str, x);
	newStr[x] = 0;
	ICS->UnReg();
	ICS = new ICString();
	ICS->str = newStr;
	ICS->len = x;
  }
  return(*this);
}

void CString::untreat_stupid(void) {
  if (ICS->len){
    int j=0;
    char * result = new char[ICS->len+1];
    for (int i=0;i<ICS->len;i++)
      if ((ICS->str[i]!='\\')||(ICS->str[i+1]!='~')) result[j++]=ICS->str[i];
    result[j]=0;
    ICS->UnReg();
	ICS = new ICString();
	ICS->str = new char[j+1];
	memcpy(ICS->str, result, j);
	ICS->str[j] = 0;
	ICS->len = j;
    delete result;  
  }
}

CString& CString::StrInsert(int pos, const CString& ins){
  assert(pos <= ICS->len);
  if (ins.ICS->len){
    if (ICS->len) {
	  int iLen = ICS->len;
      char * result = new char[ICS->len + ins.ICS->len + 1];
      memcpy(result, ICS->str, pos);
      memcpy(result+pos, ins.asString(), ins.ICS->len);
      memcpy(result+pos+ins.ICS->len, ICS->str + pos, ICS->len - pos);
      iLen = iLen + ins.ICS->len;
      result[iLen] = 0;
      ICS->UnReg();
	  ICS = new ICString();
	  ICS->str = result;
	  ICS->len = iLen;      
    } else {
      StrAppend(ins.asString());
    }
  }
  return (* this);
}

/*
  //#define CString_friend_operator { CString * tmp = new CString(s); (* tmp)+=t; CStringGarbageCollect+=tmp; return(* tmp); }
  
  #define CString_friend_operator { CString tmp = s; s+=t; return s; }
  
  CString operator+(CString& s, CString& t) CString_friend_operator
  CString operator+(CString& s, char * t) CString_friend_operator
  CString operator+(CString& s, int t) CString_friend_operator
  CString operator+(CString& s, double t) CString_friend_operator
  CString operator+(CString& s, float t) CString_friend_operator
  //CString operator+(char * s, CString& t) CString_friend_operator
  CString operator+(CString& s, long t) CString_friend_operator
  CString operator+(int t, CString& s) CString_friend_operator
  CString operator+(double t, CString& s) CString_friend_operator
  CString operator+(float t, CString& s) CString_friend_operator
  CString operator+(long t, CString& s) CString_friend_operator
  */

void CStringQSortInternal(CVector<CString> & vector,  int (*cmp_function) (const CString&, const CString&), int l, int r){  
  int i = l;
  int j = r;
  CString pivot = vector[(l+r)/2]; 
  while (i<=j) {
    while((* cmp_function)(vector[i], pivot) < 0) i++;
    while((* cmp_function)(vector[j], pivot) > 0) j--;
    if (i<=j){
      CString t = vector[i];
      vector[i] = vector[j];
      vector[j] = t;
      i++;
      j--;
    }
  }
  if (l < j) CStringQSortInternal(vector, cmp_function, l, j);
  if (l < r) CStringQSortInternal(vector, cmp_function, i, r);
}

void CStringQSort(CVector<CString> & vector,  int (*cmp_function) (const CString&, const CString&)){
  CStringQSortInternal(vector, cmp_function, 0, vector.Count() - 1);
}

CString bool_to_space(int bvalue){
  if (bvalue) return(" "); else return("");
}

int CString::operator==(const CString& s) const { return isEqual(s); }
int CString::operator==(const char * s) const { return isEqual(s); }
int CString::operator!=(const CString& s) const { return !isEqual(s); }
int CString::operator!=(const char * s) const { return !isEqual(s); }

int CString::StrLength(void) const {
  return ICS->len;
}

CString& CString::operator+=(const CString& s) { StrAppend(s.ICS->str); return(*this);}
CString& CString::operator+=(const char * s) { StrAppend(s); return(*this);}

char CString::GetChar(const int i) const {
  if (ICS->len) { assert((i>=0)&&(i<=ICS->len));
  return ICS->str[i]; } else return 0; 
}

char CString::operator[](const int i) const {
  return GetChar(i);
}

char& CString::GetChar(const int i) {
  assert((ICS->len)&&(i>=0)&&(i<=ICS->len));
  ICS = ICS->ICSCopy();
  return ICS->str[i]; 
}

char& CString::operator[](const int i) { 
  return GetChar(i); 
}

CString& CString::ContractSpaces(void){
  return (* this);
  /*
  if (ICS->len > 1) {
    ICS = ICS->ICSCopy(); 
    char * target = new char[ICS->len+1];
    int i,j;

    for (i=0,j=0;i<ICS->len;i++) {
      if (ICS->str[i] != ' ') target[j++] = ICS->str[i];
      else if (ICS->str[i+1] != ' ') target[j++] = ' ';
    }

    target[j] = 0;
    if (ICS->str) delete ICS->str;
    ICS->str = target;
    ICS->len = j;	
  }
  return (*this);
  */
}





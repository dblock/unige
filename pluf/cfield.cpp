/*
  CField

  Daniel Doubrovkine - doubrov5@cuimail.unige.ch / dblock@infomaniak.ch
  University of Geneva - 1998 - All Rights Reserved
  */

#include "cfield.h"

/* initially, CFields are undefined, but none should stay in this state,
 usually used in automatic vector initializers */
CField::CField(void){
  Name = "Undefined";
  Elementary = CFEUndefined;
  Bound = -1;
  Tag = 0;
}

/* CField destructor, ilists are rather dangerous to destroy because of multiple
   references, so I leave this for the heap deallocator for the moment, even though
   it creates memory holes */
CField::~CField(void){
  
}

/* CField copy constructor for vector manipulations */
CField::CField(const CField& Field){
  Tag = Field.Tag;  
  Name = Field.Name;
  Bound = Field.Bound;
  Elementary = Field.Elementary;
  Composite = Field.Composite;
  Constraints = Field.Constraints;
}

/* CField copy operator for vector manipulations */
CField& CField::operator=(const CField& Field){
  Bound = Field.Bound;
  Name = Field.Name;
  Elementary = Field.Elementary;
  Composite = Field.Composite;
  Constraints = Field.Constraints;
  return (* this);
}

/* real value of the field as a CString, including composite recursions */
CString CField::AsString(void){
  CString Result;
  if (Composite.Count()) {
    for(int i=0;i<Composite.Count();i++) {
      Result+=(Composite[i]->AsString());
    }
  } else if ((!Skipper)&&(DataStack.Count())) {
    switch(Elementary) {
    case CFEString: Result = * (CString *) Pop(); break;
    case CFEInteger: Result += * (int *) Pop(); break;
    case CFESpace: Result = " "; break;
    case CFETab: Result = "\t"; break;
    case CFEReturn: Result += "\n"; break;
    case CFEChar: Result += * (char *) Pop(); break;
    default: break;
    }
  }
  return Result;  
}

/* verbose value of the field, including recursed components */
void CField::Verbose(void){
  if (Composite.Count()) {
    for(int i=0;i<Composite.Count();i++) {
      (Composite[i]->Verbose());
    }
    cout << Name << "=" << AsString() << endl;
  } else if (!Skipper) {
    switch(Elementary){
    case CFEString: cout << Name << "=" << * (CString *) Pop() << endl; break;
    case CFEInteger: cout << Name << "=" << * (int *) Pop() << endl; break;
    case CFEChar: cout << Name << "=" << * (char *) Pop() << endl; break;
    case CFESpace: cout << Name << "=<Space>" << endl; break;
    case CFETab: cout << Name << "=<Tab>" << endl; break;
    case CFEReturn: cout << Name << "=<Enter>" << endl; break;
    default: cout << Name << "=<Undefined>" << endl; break;
    }
  }
}

/* for debug purposes */
ostream& operator<<(ostream& os, const CField& Field) {
  if (Field.Composite.Count()) {
    os << Field.Name << " (begins)" << endl;
    for(int i=0;i<Field.Composite.Count();i++) {
      os << * Field.Composite[i];
    }
    os << Field.Name << " (ends)" << endl;
  } else os << Field.Name << " (" << Field.Bound << ")" << endl;
  return os;  
}

/* elementary CField constructor */
CField::CField(const CString& FName, CFieldElementary ElementaryField){
  Elementary = ElementaryField;
  Name = FName;
  Bound = -1;
  Skipper = 0;
}

/* composite CField constructor */
CField::CField(const CString& FName, CField * Field, ...){
  Name = FName;
  va_list Options;
  va_start(Options, Field);
  while(1) {
    if (Field) {
      Composite += new CField(* Field);
      Field = va_arg(Options, CField *);
    } else break;
  } 
  Bound = -1;
  Skipper = 0;
}

/* default comparison for vectorization */
int CField::operator>(const CField& Field){
  return (Name > Field.Name);
}

/* default comparison for vectorization */
int CField::operator<(const CField& Field){
  return (Name < Field.Name);
}

/* default comparison for vectorization */
int CField::operator==(const CField& Field){
  return (Name == Field.Name);
}

/* composite addition, assuming that field was not elementary */
CField& CField::operator+=(CField& Field){
  Composite += &Field;
  return (* this);
}

/* data push to the stack */
void CField::Push(void * Elt){
  DataStack+=Elt;
}

/* data pop from the stack, normally the graph was organized 
   using recursive names, but this has been suppressed because
   of ambiguous syntax, this returns the last element only (there's
   one element or no elements at all actually */
void * CField::Pop(void){
  if (DataStack.Count()) {
    void * Result = DataStack[DataStack.Count()-1];
    //DataStack-=(DataStack.Count()-1);
    return Result;
  } else {
    /* data protection in case of empty stack */
    switch(Elementary) {
    case CFEString: return (new CString(""));
    case CFEInteger: return (new int(0));
    case CFEChar: return (new char(0));
    default: return 0;
    }
  }
}

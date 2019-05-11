#include "cvector.h"
#include <cstring/cstring.h>
#include <ccontainer/ccontainer.h>
#include <cfield/cfield.h>

#ifndef CVECTOR_CPP_INCL
#define CVECTOR_CPP_INCL

template <class T>
void CVector<T>::operator=(const CVector<T>& rhs) {
    if (m_pArray) delete[] m_pArray;
    m_nArrayDim = rhs.m_nArrayDim;
    m_nArrayFill = 0;
    m_pArray = new T[m_nArrayDim];
    int i;
    for(i=0;i<rhs.Count();i++) {
      T temp = rhs.GetElt(i);
      AddElt(temp);
    }
  }

template <class T>
void CVector<T>::Flush(CVector<T>& rsh){
    rsh.Clear();
    rsh.m_nArrayDim = m_nArrayDim;
    rsh.m_nArrayFill = m_nArrayFill;
    rsh.m_pArray = m_pArray;
    m_nArrayDim = 1;
    m_pArray = new T[m_nArrayDim];
    m_nArrayFill = 0;
  }

template <class T>
inline int CVector<T>::Count(void) const {
  return m_nArrayFill;
}

template <class T>
CVector<T>::~CVector(void){ 
  delete[] m_pArray;
}

template <class T>
inline CVector<T>& CVector<T>::operator+=(const T& NewElt) {return AddElt(NewElt);}

template <class T>
void CVector<T>::operator-=(const T& Elt) {DeleteElt(FindElt(Elt));}

template <class T>
void CVector<T>::operator-=(const int nIndex) {DeleteElt(nIndex);}

template <class T>
T& CVector<T>::operator[](const int nIndex) const {return GetElt(nIndex);}

template <class T>
CVector<T>::CVector(const CVector<T>& rhs){
  m_nArrayFill = 0;
  m_nArrayDim = rhs.Count();
  m_pArray = new T[m_nArrayDim];
  int i;
  for(i=0;i<rhs.Count();i++) AddElt(rhs[i]);
}

template <class T>
void CVector<T>::QSort(){  
  if (m_nArrayFill) QSort(0, m_nArrayFill - 1);
}

template <class T>
void CVector<T>::QSort(int l, int r){  
  int i = l;
  int j = r;
  T pivot = m_pArray[(l+r)/2]; 
  while (i<=j) {
    while(m_pArray[i]<pivot) i++;
    while(m_pArray[j]>pivot) j--;
    if (i<=j){
      T t = m_pArray[i];
      m_pArray[i] = m_pArray[j];
      m_pArray[j] = t;
      i++;
      j--;
    }
  }
  if (l < j) QSort(l, j);
  if (l < r) QSort(i, r);
}

template <class T>
int CVector<T>::Contains(const T& elt){
  return FindElt(elt)+1;
}

template <class T>
T& CVector<T>::GetElt(const int nIndex) const {
#ifdef _DEBUG_CPP
  assert(nIndex < m_nArrayFill && nIndex >= 0);
#endif
  return m_pArray[nIndex];
}

template <class T>
CVector<T>::CVector(void) {  
  m_nArrayDim = 5;
  m_nArrayFill = 0;
  T * m_pArray_local = new T[m_nArrayDim]; 
  m_pArray = m_pArray_local;
#ifdef _DEBUG_CPP
  assert(m_pArray);
#endif
}

template <class T>
void CVector<T>::Clear(void){
  delete[] m_pArray;
  m_pArray = new T[m_nArrayDim];
  m_nArrayFill = 0;
}

template <class T>
CVector<T>& CVector<T> :: AddElt(const T& Elt){	
  if (m_nArrayFill >= m_nArrayDim){
    m_nArrayDim+=5;
    T* m_pArray_new = new T[m_nArrayDim];
    for (int i=0;i<m_nArrayFill;i++)
      m_pArray_new[i]=m_pArray[i];
    delete[] m_pArray;
    m_pArray = m_pArray_new;	
  }
  m_pArray[m_nArrayFill++] = Elt; //((* new T) = Elt);
  return *this;
}

template <class T>
void CVector<T> :: DeleteElt(int nIndex) {
  if (nIndex >= 0){
    for (int i = nIndex; i < m_nArrayFill - 1; i++)
      m_pArray[i] = m_pArray[i + 1];
    m_nArrayFill--;
  }
}

template <class T> 
int CVector<T> :: FindElt(const T& Value) const {
  for (int i = 0; i < m_nArrayFill; i++)
    if (m_pArray[i]==Value) {
      return i;
    }
  return -1;
}

template <class T>
int CVector<T>::operator<(const CVector<T>& Other) const {
  if (Count() > Other.Count()) return 0;
  else if (Count() < Other.Count()) return 1;
  else 
    for (int i=0;i<Count();i++) {
      if (GetElt(i) > Other[i]) return 0;
      else if (GetElt(i) < Other[i]) return 1;
    }
  return 0;
}

template <class T>
int CVector<T>::operator>(const CVector<T>& Other) const {
  if (Count() < Other.Count()) return 0;
  else if (Count() > Other.Count()) return 1;
  else 
    for (int i=0;i<Count();i++) {
      if (GetElt(i) < Other[i]) return 0;
      else if (GetElt(i) > Other[i]) return 1;
    }
  return 0;
}

template <class T>
int CVector<T>::operator==(const CVector<T>& Other) const {
  if (Count() != Other.Count()) return 0;
  else for (int i=0;i<Count();i++)
    if (!(GetElt(i) == Other[i])) return 0;
  return 1;
}

template <class T>
int CVector<T>::operator!=(const CVector<T>& Other) const {
  return (!((* this)==Other));
}

template <class T>
ostream& operator<< (ostream& out, const CVector<T>& rhs) {
  int nMax = rhs.Count();
  for (int i = 0; i < nMax; i++)
    /* signature will match the element << operator */
    out << rhs.GetElt(i) << "\n";
  return out;
}

template <class T> 
ofstream& operator<< (ofstream& fout, const CVector<T>& rhs) {
  int nMax = rhs.Count();
  for (int i = 0; i < nMax; i++)
    fout << rhs.GetElt(i) << "\n";
  return fout;
}

template class CVector<long>;
template class CVector<int>;
template class CVector<CField>;
template class CVector<CString>;

#endif

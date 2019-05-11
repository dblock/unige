#ifndef CVECTOR_H
#define CVECTOR_H

#include <iostream.h>
#include <fstream.h>
#include <assert.h>

template <class T>
class CVector {
protected:
  int m_nArrayDim;  
  int m_nArrayFill;
  T * m_pArray;  
public:
  T& GetElt(const int nIndex) const;
  int Contains(const T&);
  void Clear(void);
  CVector<T>(void);
  void operator=(const CVector<T>& rhs);
  void Flush(CVector<T>&);
  CVector<T>(const CVector<T>&);
  int Count(void) const;
  ~CVector(void);
  CVector<T>& AddElt(const T& NewElt);
  void DeleteElt(int nIndex);
  int FindElt(const T& Elt) const;
  CVector<T>& operator+=(const T& NewElt);
  void operator-=(const T& Elt);
  void operator-=(const int nIndex);
  T& operator[](const int nIndex) const;
  int operator==(const CVector<T>&) const;
  int operator>(const CVector<T>&) const;
  int operator<(const CVector<T>&) const;
  int operator!=(const CVector<T>&) const;
  void QSort(int, int);
  void QSort();

  /****  Iterator support 
    CVector<T>& operator++();       //Increment current location
    CVector<T>& operator++(int);    //Increment current location - post
    CVector<T>& operator--();       //Decrement current location
    CVector<T>& operator--(int)     //Decrementer
    const T& operator[](int rhs) const; //Return this element
    const T& operator[](const T& rhs);  //Return matching element; set current
    const T& operator*() ;         //Return current element
    int operator!=(int);           //Test for End-of-Array  ********/

  friend ostream& operator<<(ostream&, const CVector<T>&);
  friend ofstream& operator<<(ofstream&, const CVector<T>&);
#ifdef ANSI
  friend cgiOutStream& operator<<(cgiOutStream&, const CVector<T>&);
#endif
};

#endif

/*
  PLUF - C++ Programming Filter

  Daniel Doubrovkine - doubrov5@cuimail.unige.ch / dblock@infomaniak.ch
  University of Geneva - 1998 - All Rights Reserved
 */


#include <cfilter/cfilter.h>
#include <cfield/cfield.h>

#include <slist/slist_v2.cpp>
template class ilist<CField *>;
template class ilist<void *>;

void main(int argc, char ** argv){
  CFilter Filter;
  for(int i=1;i<argc;i++) Filter.ProcessOption(argv[i]);
}

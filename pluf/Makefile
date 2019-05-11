DIRS=slist cstring cvector cfield cfilter cproc cpf
UNAME = $(shell uname -a | cut -f1 -d' ')
ADDSunOS = /unige/gnu/bin/make 
ADDLinux = /usr/bin/make 
CURADD = $(ADD$(UNAME))

all clean:
	@for I in $(DIRS); do cd `pwd`/$$I; $(CURADD) -f ../Makefile.each $@ || exit 1; cd ..; done
	c++ obj/* -o pluf.$(UNAME)



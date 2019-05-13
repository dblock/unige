# (c) Daniel Doubrovkine - uniGe - 1997

.c.o:
	cc -c $*.c

all: salut

salut: ghost.o salut.o
	cc -o salut ghost.o salut.o

ghost.o:salut.h
salut.o:salut.h

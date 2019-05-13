/*
Complete Unidirectional Graph Implementation for tp12 Systeme Info
(c) Daniel Doubrovkine - 1997 - doubro5@cui.unige.ch
*/

#include <stdio.h>
#include <stdlib.h>

char * verylast;

typedef struct {
	char ch;
	int term;
	} ncontain;

typedef struct {
	void * brother;
	void * child;
	void * parent;
	ncontain * inside;
	} pnode;

pnode * init(parent, ich, iterm) 
	char ich; 
	int iterm; 
	pnode * parent; {
	pnode * inode;
	ncontain * icontain;
	
	inode = (pnode *) malloc (sizeof(pnode));
	icontain = (ncontain *) malloc (sizeof(ncontain));	

	inode->brother = NULL;
	inode->child = NULL;
	inode->parent = parent;
	icontain->ch = ich;
	icontain->term = iterm;
	inode->inside = icontain;

	return(inode);
	}

pnode * getbrotherbycontents(inode, ch)
	pnode * inode;
	char ch; {
	ncontain * ic;

	while (inode != NULL) {
		ic = inode->inside;
		if ((ic->ch) == ch) return(inode);
		inode = (inode->brother);
		}
	return(NULL);
	}

pnode * getchildbycontents(inode, ch)
	pnode * inode;
	char ch; {
	if (inode->child!=NULL) return(getbrotherbycontents(inode->child, ch));
		else return(NULL);
	}

pnode * getlastbrother(inode)
	pnode * inode; {
	
	while(inode->brother!=NULL) inode = inode->brother;
	return(inode);
	}

pnode * getlastchild(inode)
	pnode * inode; {
	
	if (inode->child!=NULL) return(getlastbrother(inode->child));
	return(inode);
	}

pnode * addchild(inode, ch, term) 
	char ch;
	int term;
	pnode * inode; {
	pnode * tnode;
	
	tnode = getchildbycontents(inode, ch);
	if (tnode != NULL) return(tnode);
	
	tnode = init(inode, ch, term);
	if (inode->child!=NULL) {
		inode = getlastchild(inode);
		inode->brother = tnode;
		} else inode->child = tnode;
	return(tnode);
	}

pnode * addbrother(inode, ch, term)
	char ch;
	int term;
	pnode * inode; {
	pnode * tnode;

	tnode = getbrotherbycontents(inode, ch);
	if (tnode!=NULL) return(tnode);
	inode = getlastbrother(inode);
	tnode = init(inode->parent, ch, term);
	inode->brother = tnode;
	return(tnode);
	}

pnode * getbrotherbyindex(inode, i)
	pnode * inode;
	int i; {

	if (inode->parent!=NULL) {
		inode = inode->parent;
		inode = inode->child;
		}

	for (i;i>0;i--) {
		if (inode==NULL) return(NULL);
		inode = inode->brother;
		}
	return(inode);
	}

pnode * getchildbyindex(inode, i)
	pnode * inode;
	int i; {
	if (inode->child!=NULL) return(getbrotherbyindex(inode->child, i));
	   else return(inode);
	}

void contents(inode, level)
	pnode * inode; 
	int level; {
	int i;

	i = level;
	while (i-->0) printf(" ");
	printf("%c\n", inode->inside->ch);
	if (inode->child != NULL) contents(inode->child, level+1);
	if (inode->brother != NULL) contents(inode->brother, level);
	}

char * contentsbfs(inode, iword, out)
	pnode * inode; 
	int out;
	char * iword; {
	
	char * tword;

	if (iword == NULL) {
		tword = (char *) malloc(sizeof(char));
		} else {
		tword = (char *) malloc(sizeof(char)*(strlen(iword)+1));
		sprintf(tword, "%s%c", iword, inode->inside->ch);
		} 
	if (inode->inside->term) {
		if (out) printf("\t%s\n\r", tword);
		verylast = strdup(tword);
		}

	if (inode->child != NULL) contentsbfs(inode->child, tword, out);
	tword[strlen(tword)-1]='\0';
	if (inode->brother != NULL) contentsbfs(inode->brother, tword, out);	
	}


int brothercount(inode)
	pnode * inode; {
	int i;
	while (inode!=NULL) { i++; inode = inode->brother; }
	return(i);
	}

int childcount(inode)
	pnode * inode; {
	if (inode == NULL) return(0); 
	else return(brothercount(inode->child));
	}

pnode * bound(inode, iword) 
	pnode * inode;
	char * iword; {
	pnode * tnode;

	if (iword == NULL) return(inode);
	if (iword[0]=='\0') return(inode->child);

	tnode = getchildbycontents(inode, iword[0]);
	if (tnode != NULL) return(bound(tnode, iword+1));
	return(NULL);
	}

int expandcount(top) 
	pnode * top; {
	int icount;
	if (top == NULL) return(-1);
	if (top->inside->term) icount = 1; else icount = 0;
	if (top->child != NULL) icount+= expandcount(top->child);
	if (top->brother != NULL) icount+= expandcount(top->brother);
	return(icount);
	}

int expandone(top, iword)
	char * iword;
	pnode * top; {
	int ic;
	
	top = bound(top, iword);
	ic = expandcount(top);
	if (ic == 1) {
		contentsbfs(top, iword, 0);
		printf("%s\n\r", verylast + strlen(iword));
		return(1);
		} else 
	if (ic > 1) {
		printf("\n\r");
		contentsbfs(top, iword, 1);
		printf("%s", iword);
		return(0);
		} else printf("");	
	return(0);
	}

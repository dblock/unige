/* TP12 Systeme Info - (c) Daniel Doubrovkine - 1997
---------------------------------------------------------------------------------------------
   launch with either params delimited by spaces or input strings at first line space delim
   use right arrow to complete strings or show lists	 
   notes: there's maybe a bug in backspace press
*/

#include <stdio.h>
#include <string.h>
#include "nodes.c"
#include <curses.h>

#define MAXCOMMAND 2048

pnode * top;

char * trim(iStr)
	char * iStr; {
	if (iStr == NULL) return(NULL);
	while ((iStr!=NULL)&&(strlen(iStr)>0)) if (iStr[0]<=' ') iStr++; else break;
	while ((iStr!=NULL)&&(strlen(iStr)>0))
	   if (iStr[strlen(iStr)-1]<=' ') 
	       iStr[strlen(iStr)-1] = '\0'; else break;
	return(iStr);
	}

void add_str(iword) 
	char * iword; {

	pnode * current;
	int i;
	
	current = top;
	for (i=0;i<strlen(iword);i++) {
		current = addchild(current, iword[i], 0);
		}
	current->inside->term = 1;
	}

void getstrings(void) {
	char * tExec;
	char * tF;
	
	top = init(NULL, 255, 0);

	tExec = (char *) malloc (sizeof(char)*MAXCOMMAND);
	if (fgets(tExec, MAXCOMMAND, stdin)!=NULL) {
		tExec = trim(tExec);
		while (tExec!=NULL) { 
			tF = strrchr(tExec, ' ');
			if (tF != NULL) {
				add_str(trim(tF));
				tExec[tF - tExec] = '\0';
				} else {
				add_str(tExec);
				tExec = NULL;
				}}}
	}

void workhard(void) {
	int ch;
	char * container;
	char * tmp;
	int escape;

	printf("working hard...");
	container = (char *) malloc(sizeof(char));
	container[0] = '\0';
	
	initscr();
	cbreak();
	keypad(stdscr, TRUE);

	ch = getchar();
	while (ch!=KEY_BREAK) {
	   switch (ch) {
		case '':		escape = 1;
	     			 	break;
	     	case 67: 		if (escape)
					   if (expandone(top, container)) {
						free(container);
						container = (char *) malloc(sizeof(char));
						container[0] = '\0';
						escape = 0;
						}
					break;
	     	case '\r': 	
			free(container);
			container = (char *) malloc(sizeof(char));
			container[0] = '\0'; 
			printf("\n\r");
			break;
		case 8:
			if (strlen(container) >= 0) {
				container[strlen(container)-1]='\0';
				printf("%c %c", ch, ch);
				break;
				}
	    	default:		
		   if ((ch == 79) && (escape)) break;
			tmp = (char *) malloc(sizeof(char)*(strlen(container)+1));
			strcpy(tmp, container);
			tmp[strlen(container)] = ch;
			tmp[strlen(container)+1] = '\0';
			container = tmp;
			printf("%c", ch);
			break;
		}	
		fflush(stdout);
		ch = getchar();
		}
	}

void main(void){
	getstrings();
	workhard();
	}


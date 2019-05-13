/*(c) Daniel Doubrovkine - 1997 - doubrov5@unige.ch*/

#include <stdio.h>
#include <sys/param.h>
#include <string.h>

#define MAXCOMMAND 1024

char * strreplace(where, from, to) 
	char * where;
	char * from;
	char * to;
{
	char * iFound;
	char * target;
	int fSize;
	int tSize;
	
	if ((from == NULL)||(to == NULL)||(where == NULL)) return(where);
	iFound = strstr(where, from);
	if (iFound == NULL) return(where);

	fSize = iFound - where;
	tSize = (strlen(to) + strlen(where) - strlen(from) + 2);
	target = (char *) malloc (sizeof(char) * tSize);
	strncpy(target, where, fSize);
	target[fSize]='\0';
	where+=(fSize + strlen(from));
	strcat(target, to);
	strcat(target, strreplace(where, from , to));
	return(target);
}

void prompt(void){
	char * tHome;
	char * tPwd;
	char * pr;

	tHome = (char *) getenv("HOME");
	tPwd = (char *) malloc (sizeof(char)*MAXPATHLEN);
	getwd(tPwd);
	if ((tHome!=NULL)&&(tPwd!=NULL)) {
		if (strlen(tHome)<=strlen(tPwd)) {
		   if (!strncmp(tHome, tPwd, strlen(tHome))) {
			pr = tPwd + strlen(tHome);
			printf("~%s", pr);
		}} else printf("%s", tPwd); }
	printf(">");
}

char * trim(iStr)
	char * iStr; {
	if (iStr == NULL) return(NULL);
	while ((iStr!=NULL)&&(strlen(iStr)>0)) if (iStr[0]<=' ') iStr++; else break;
	
	while ((iStr!=NULL)&&(strlen(iStr)>0))
	   if (iStr[strlen(iStr)-1]<=' ') 
	       iStr[strlen(iStr)-1] = '\0'; else break;
	
	return(iStr);
	} 

void dsh_error(iError) 
	char * iError; {
	fprintf(stderr, "dsh::%s\n", iError);
	}

void dsh_cd(iPath) 
	char * iPath; {
	char * iHome;

	if (iPath == NULL) {
		dsh_error("please specify a path");
		return;
		}
	
	iHome = (char *) getenv("HOME");
	if (iHome!=NULL) if (strlen(iHome)>0) iPath = strreplace(iPath,"~", iHome);
		
	if (strlen(iPath)==0) dsh_error("please specify a path");
	else if (strlen(iPath)>MAXPATHLEN) dsh_error("path too long");
	else if (chdir(iPath)) dsh_error("error changing directory");
}

void execute_command(iE, iA) 
	char * iE;
	char * iA; {
	int stat;
	char * iT;

	if (iA!=NULL) {
		iT = (char *) malloc ((strlen(iE)+strlen(iA)+1)*sizeof(char));
		strcpy(iT, iE);
		strcat(iT, " ");
		strcat(iT, iA);
		} else iT = iE;

	switch (fork()) {
		case -1: dsh_error("failed to fork");
			 break;
		case 0: /*new thread*/
			 /*execlp(iE, iE, iA, 0);*/
			 system(iT);
			 exit(3);
		default:
  			 wait(&stat);
			 break;
		};
}

void analyse_expression(iExpression) 
	char * iExpression; {
	char * iArgument;
	int rPos = 0;

	iExpression = trim(iExpression);
	if (!strlen(iExpression)) return;

	iArgument = (char *) strchr(iExpression, ' ');
	if (iArgument!=NULL) {
		iExpression[iArgument++ - iExpression] = '\0';
		iArgument = trim(iArgument);
		}
	if (!strcmp(iExpression, "exit")) exit(0); 
	else if (!strcmp(iExpression, "quit")) exit(0); 
	else if (!strcmp(iExpression, "cwd")) printf("%s\n", getcwd());
	else if (!strcmp(iExpression, "cd")) dsh_cd(iArgument);
	else if (!strcmp(iExpression, "type")) execute_command("cat", iArgument);
	else if (!strcmp(iExpression, "dir")) execute_command("ls", iArgument);
	/* else if (!strcmp(iExpression, "echo")) printf("%s\n",iArgument); */
	else execute_command(iExpression, iArgument);
}

void user(void){
	char * tExec;

	tExec = (char *) malloc (sizeof(char)*MAXCOMMAND);
	while (fgets(tExec, MAXCOMMAND, stdin)!=NULL) {
		analyse_expression(tExec);
		prompt();
		}
	free(tExec);
}

void main(void) { 
	prompt();
	user();
}

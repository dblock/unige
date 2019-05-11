#include <conio.h>
#include <stdio.h>
#include <process.h>
#include <dir.h>
#include <string.h>
#include <dos.h>
#include <alloc.h>
#include <ctype.h>
#include <stdlib.h>

#ifdef __cplusplus
  int max (int value1, int value2);
  int max(int value1, int value2)
  {return ( (value1 > value2) ? value1 : value2);}
#endif

int c_break(void);
int handler(int errval,int ax,int bp,int si);
//-------------------------------------------
void pop_cursor(void);
void push_cursor(void);
void helpme(void);
void exit_routine(void);
void save_curdir(void);
void restore_curdir(void);
char *current_directory(char *path);
void process_dir(char *process_directory, char *flag);
void process_file(char *directory,char *filename);
void init_xrep(int argc,char *argv[]);
void get_replacements(char *stringfile);
void process_flag(char *directory,char *flag);
void replace(char *filename);
void percentage_upgrade(long current_length,long total_length,long string_length);
long filesize(FILE *stream);
//------------------------------------------make_names2();
void make_names2(char *source, char *message);
char drive[MAXDRIVE];
char dir[MAXDIR];
char file[MAXFILE];
char ext[MAXEXT];
char new_str[MAXDRIVE+MAXDIR+MAXFILE+MAXEXT];
char old_dir[MAXDIR];
//------------------------------------------char
char all_flag[MAXDRIVE+MAXDIR];
char curdir[MAXDRIVE+MAXDIR];
char *replace_from;
char *replace_to;
char temp_from[MAXDRIVE+MAXDIR+MAXFILE+MAXEXT];
char temp_to[MAXDRIVE+MAXDIR+MAXFILE+MAXEXT];
char temp_file[MAXDRIVE+MAXDIR+MAXFILE+MAXEXT];
char work_file[MAXDRIVE+MAXDIR+MAXFILE+MAXEXT];
//------------------------------------------int
int opt_no_subdirs=0;
int ch;
int cnt;
int a,b,c,d,e,f,g,h,i,j,k,l,n,o,p,q,r,s,t,u,v,w,x,y,z;
int opt_overwrite=0;
long read_filesize;
int sline_ssize=10240;
int srepl_ssize_from=1;
int srepl_ssize_to=1;
//------------------------------------------
char xrep_flag[15];
//------------------------------------------replace();
int local_replacement;
char new_filename[MAXDRIVE+MAXDIR+MAXFILE+MAXEXT];
char the_filename[MAXDRIVE+MAXDIR+MAXFILE+MAXEXT];
char _temp[MAXDRIVE+MAXDIR+MAXFILE+MAXEXT];
char _temp2[MAXDRIVE+MAXDIR+MAXFILE+MAXEXT];
char file_[MAXFILE];
char ext_[MAXEXT];
char *working_string;
char *working_now;
fpos_t begpos;
fpos_t thispos;
char *working_replace;
char *working_to_replace;
int replacement=0;
//------------------------------------------

void main(int argc,char *argv[])
{
	clrscr();
	push_cursor();
	ctrlbrk(c_break);
	harderr(handler);
	save_curdir();
	init_xrep(argc,argv);
	process_dir(new_str,xrep_flag);
	restore_curdir();
	printf("\n\nxrep:: %d replacements made",replacement);
	pop_cursor();
}

void process_dir(char working_directory[MAXDIR],char *flag)
{
	strupr(working_directory);
	printf("\nxrep::(chdir): %s",working_directory);

	strcpy(all_flag,working_directory);
	if (all_flag[strlen(all_flag)-1]!='\\') strcat(all_flag,"\\");
	strcat(all_flag,"*.*");
	process_flag(working_directory,flag);
	if (opt_no_subdirs==0)
	{
	chdir(working_directory);
	struct ffblk ffblk;
	int done;
	done = findfirst(all_flag,&ffblk,FA_RDONLY+FA_HIDDEN+FA_SYSTEM+FA_DIREC+FA_ARCH);
	while (!done)
	{
	   if (strcmp(ffblk.ff_name,".")!=0)
	   if (strstr(ffblk.ff_name,"..")==NULL)
	   if (ffblk.ff_attrib==FA_DIREC)
		{
		char pushed_dir[MAXDIR];
		strcpy(pushed_dir,working_directory);
		if (working_directory[strlen(working_directory)-1]!='\\') strcat(working_directory,"\\");
		strcat(working_directory,ffblk.ff_name);
		process_dir(working_directory,flag);
		strcpy(working_directory,"");
		strcpy(working_directory,pushed_dir);
//		printf("\nxrep::(chpop): %s",process_directory);
		}
//	   else printf("\n  %s",ffblk.ff_name);

	   done = findnext(&ffblk);
	}
	}
}


void process_flag(char *directory,char *flag)
{
	strcpy(temp_file,directory);
	if (temp_file[strlen(temp_file)-1]!='\\') strcat(temp_file,"\\");
	strcat(temp_file,flag);
	struct ffblk ffblk;
	int done;
	done = findfirst(temp_file,&ffblk,0);
	while (!done)
		{
		   process_file(directory,ffblk.ff_name);
		   done = findnext(&ffblk);
		}
}

void process_file(char *directory,char *filename)
{
	if (directory[strlen(directory)-1]!='\\') strcat(directory,"\\");
//	printf("\n  xrep:: %s%s", directory,filename);
	strcpy(work_file,directory);
	strcat(work_file,filename);
	replace(work_file);
}

void helpme(void)
{
	     clrscr();
	     printf("X-REPLACE - Advanced Structural Replace Utility, v. 1.32");
	     printf("\n            Daniel Doubrovkine (c), Switzerland, 1995");
	     printf("\n            email welcome: dblock@infomaniak.ch / doubrov5@cui.unige.ch\n");
	     printf("\n\n  Disclaimer: The author claims no responsibility for damages caused by any");
	     printf("\n  use of this software, as well as third party modifications of the");
	     printf("\n  original code of XREP destributed freely to encourage and help developpers.");
	     printf("\n\n  Though XREP is totally  free, it does entirely  remain  the property of it's");
	     printf("\n  author, and thus cannot be sold! Any illegal sale of this software will be ");
	     printf("\n  prosecuted at maximum extent possible under the federal criminal law of the");
	     printf("\n  Helvetic Confederation.");
	     getch();
	     clrscr();
	     printf("X-REPLACE - Advanced Structural Replace Utility, v. 1.32");
	     printf("\nXREP replaces text string in flagged files, subdirectories included.\n");
	     printf("\nsyntax:");
	     printf("\n\n\txrep <flags or file> <strings container> <options>");
	     printf("\n\n<flags or file>     the files you want to process (ex: TEXT.TXT or *.TXT)");
	     printf("\n<strings container> a simple text file containing the strings to replace");
	     printf("\n                    example of a container:");
	     printf("\n\t\t\\this is a comment (lines starting with '\\' are ignored)");
	     printf("\n\t\tYou|Thou");
	     printf("\n\t\tgreen|blue");
	     printf("\n\t\t\\'You' will be replaced by 'Thou'");
	     printf("\n\t\t\\'green' will be replaced by 'blue'");
	     printf("\n\t\t\\note that all changes ARE case sensitive");
	     printf("\n<options>           -x : eXclude subdirectories");
	     printf("\nrestrictions and notes:");
	     printf("\n\teach text line size: %dKb (broken in two if needed)",div(sline_ssize,1024).quot);
	     printf("\n\tphysical base memory restrictions only for string containers");
	     printf("\n.XRP files are made as backup (warns if overwrite) in case of replacements.");
	     exit_routine();
}

void exit_routine(void)
{
	fcloseall();
	free(replace_from);
	free(replace_to);
	free(working_string);
	free(working_now);
	free(working_replace);
	free(working_to_replace);
	pop_cursor();
	exit(1);
}


void save_curdir(void)
{
   current_directory(curdir);
}

void restore_curdir(void)
{
    strupr(curdir);
    setdisk(curdir[0]-'A');
    chdir(curdir);
}

char *current_directory(char *path)
{
   strcpy(path, "X:\\");
   path[0] = 'A' + getdisk();
   getcurdir(0, path+3);
   return(path);
}

void init_xrep(int argc,char *argv[])
{
asm{
   xor ax,ax
   mov ah,0x0C
   int 0x21
   }
clrscr();
if (argc<3) helpme();

	     printf("X-REPLACE - Advanced Structural Replace Utility, version 1.32");
	     printf("\n            BSA (Better String Analysis v.1.1) (c) D.D.");
	     printf("\n            Daniel Doubrovkine (c) - uniGE - Switzerland, 1995");
	     printf("\n            email welcome: dblock@infomaniak.ch / doubrov5@cui.unige.ch");

printf("\n  xreplace::init");
printf("\n  xreplace::container: %s",strupr(argv[2]));

for(n=3;n<argc;n++)	//treat arguments for subdir flag and SOS opt
	{
	strupr(argv[n]);
	printf("\n  xreplace::option: %s ",argv[n]);
	if (strcmp(argv[n],"-X")==0) {opt_no_subdirs=1;printf("::excluding subdirectories.");}
	else
	if (strcmp(argv[n],"/X")==0) {opt_no_subdirs=1;printf("::excluding subdirectories.");}
	else
	printf("::illegal option, ignored.",argv[n]);
	}


get_replacements(argv[2]);
make_names2(argv[1],"replacement");
}

void get_replacements(char *stringfile)
{
printf("\n  xreplace::opening string container: %s",stringfile);
FILE *container_file;
container_file=fopen(stringfile,"rt");
if (container_file== NULL){perror("\n  xreplace::cannot open string container file");exit_routine();}
fseek(container_file, 0L, SEEK_END);
printf("\nAllocating %ld bytes for source string container.",ftell(container_file));
if ((replace_from = (char *) malloc(ftell(container_file)))==NULL)
{
   printf("\nNot enough memory to allocate buffer (malloc size: %ld bytes.)",ftell(container_file));
   exit_routine();
}
printf("\nAllocating %ld bytes for target string container.",ftell(container_file));
if ((replace_to = (char *) malloc(ftell(container_file)))==NULL)
{
   printf("\nNot enough memory to allocate buffer (malloc size: %ld bytes.)",ftell(container_file));
   exit_routine();
}

printf("\nAllocating %dKb for source string read.",div(sline_ssize,1024).quot);
if ((working_string = (char *) malloc(sline_ssize))==NULL)
{
   printf("\nNot enough memory to allocate buffer (malloc size: %dKb.)",div(sline_ssize,1024).quot);
   exit_routine();
}
printf("\nAllocating 10Kb for target string write.");
if ((working_now = (char *) malloc(sline_ssize))==NULL)
{
   printf("\nNot enough memory to allocate buffer (malloc size: %dKb.)",div(sline_ssize,1024).quot);
   exit_routine();
}

strcpy(replace_from,"");
strcpy(replace_to,"");
strcpy(working_string,"");
strcpy(working_now,"");
rewind(container_file);
while(!feof(container_file))
{
	fpos_t filepos;
	fgetpos(container_file, &filepos);
	ch=fgetc(container_file);
	if (ch=='\\')
		{
		goto nextline;
		}
	fsetpos(container_file, &filepos);
if(feof(container_file)) break;
//replace from
a=0;
//printf("\nxrep::replace from: ");
   while(!feof(container_file))
	{
	ch=fgetc(container_file);
		if (ch=='|') break;
		if (ch<32) break;
	temp_from[a]=ch;a++;
//	replace_from[i]=ch;i++;
//	printf("%c",ch);
	}
	temp_from[a]='\0';
if(feof(container_file)) break;
//replace_from[i]='|';i++;
//replace to
a=0;
//printf("\nxrep::replace to: ");
   while(!feof(container_file))
	{
	ch=fgetc(container_file);
		if (ch=='|') break;
		if (ch<32) break;
//	printf("%c",ch);
	//replace_to[j]=ch;j++;
	temp_to[a]=ch;a++;
	if (feof(container_file))break;
	}
temp_to[a]='\0';
if(feof(container_file)) break;
nextline:
	if ((strlen(temp_from)>0)&&(strlen(temp_to)>0))
	if (strcmp(temp_from,temp_to)==0)
		{
		printf("\n  xrep::replace from : %s\n  xrep::replace to   : %s",temp_from,temp_to);
		printf("  xreplace::illegal circular replace detected:\n\t%s -> %s ::ignoring",temp_from,temp_to);
		}
		else
		{
		printf("\n  xrep::replace from : %s\n  xrep::replace to   : %s",temp_from,temp_to);
		strcat(replace_from,temp_from);
		strcat(replace_from,"|");
		strcat(replace_to,temp_to);
		strcat(replace_to,"|");
		//for maxlen temp_from, temp_to malloc
		srepl_ssize_from=max(srepl_ssize_from,strlen(temp_from)+1);
		srepl_ssize_to=max(srepl_ssize_to,strlen(temp_to)+1);
		}

   for(;;)
	{
	if (ch<32) break;
	ch=fgetc(container_file);
	if(feof(container_file)) break;
	}
}
//malloc replacers
printf("\nAllocating %d bytes for source string replacer.",srepl_ssize_from);
if ((working_replace = (char *) malloc(srepl_ssize_from))==NULL)
{
   printf("\nNot enough memory to allocate buffer (malloc size: %d bytes.)",srepl_ssize_from);
   exit_routine();
}
printf("\nAllocating %d bytes for target string replacer.",srepl_ssize_to);
if ((working_to_replace = (char *) malloc(srepl_ssize_to))==NULL)
{
   printf("\nNot enough memory to allocate buffer (malloc size: %d bytes.)",srepl_ssize_to);
   exit_routine();
}
strcpy(working_replace,"");
strcpy(working_to_replace,"");
//done.
replace_from[strlen(replace_from)-1]='\0';
replace_to[strlen(replace_to)-1]='\0';
fclose(container_file);
}

void make_names2(char *source, char *message)
{
int flags;					//fnsplit flags
//make from argument
flags=fnsplit(source,drive,dir,file,ext);      	//split source
//printf("\nfrom: %s\nto: %s\ndrive: %s\n %s\nfile: %s\next: %s\n",from,to,drive,dir,file,ext);
//-------------------------------------------------------------- DRIVE
	//in case no drive has been specified
	if (!(flags & DRIVE))
	{
	drive[0]=_getdrive() + 'A' - 1;
	drive[1]=':';
	drive[2]='\0';
	}
//	printf("\nbsa(1.1)::assuming %s drive:: %s", message, drive);
//-------------------------------------------------------------- DIRECTORY
	/*
	is the file made by fnsplit a directory?
		YES:
		   assume the new directory
		NO:
		   is the directory specified at all?
		   YES:
		      does this directory exist at all?
			YES: assume as it is
			NO: invalid directory, exit
		   NO:
		      assume the current directory for the specified drive
	*/
	//check stupidities
	if (strstr(dir,"...")!=NULL) {printf("\n  bsa(1.1)::error::%s:illegal directory name:\n   %s%s",message,drive,dir);exit(1);}
	if (strstr(dir,"*")!=NULL) {printf("\n  bsa(1.1)::error::%s:illegal directory name:\n   %s%s",message,drive,dir);exit(1);}
	if (strstr(dir,"?")!=NULL) {printf("\n  bsa(1.1)::error::%s:illegal directory name:\n   %s%s",message,drive,dir);exit(1);}
	//check if file is directory
	strcpy(new_str,drive);
	strcat(new_str,dir);
	strcat(new_str,file);
	strcat(new_str,ext);

	//directories often end with \\, not ignored by chdir
	if (new_str[strlen(new_str)-1]=='\\') new_str[strlen(new_str)-1]='\0';
	//can it be a directory?
	struct ffblk ffblk;
	//push the actual directory on the drive
	strcpy(old_dir,drive);
	strcat(old_dir,"\\");
	getcurdir(drive[0]-'A'+1,old_dir+3);
	//check if the specified name is a directory
	while(dir[strlen(dir)-1]=='.') {if (dir[strlen(dir)-1]=='.') dir[strlen(dir)-1]='\0';}
	if (!chdir(new_str))
	{
	  getcurdir(drive[0]-'A'+1, dir);
//	  printf("\nbsa(1.1)::assuming %s as %s%s",message,drive,dir);
	  //pop the old directory
	  chdir(old_dir);
	  //clean the filename and extention
	  strcpy(file,"*");
	  strcpy(ext,".*");
	}
	else
	{
	    //clean the pending directory backslash
	 if (flags & DIRECTORY)
	 {
	   if (strlen(dir)>1) if (dir[strlen(dir)-1]=='\\') dir[strlen(dir)-1]='\0';
	   //keep the directory as it was given by the user
	   //check for the existance of the directory
	   strcpy(old_dir,drive);
	   strcat(old_dir,"\\");
	   getcurdir(drive[0]-'A'+1,old_dir+3);
	   strcpy(new_str,drive);
	   strcat(new_str,dir);
	   if (!chdir(new_str))
	    {
	    getcurdir(drive[0]-'A'+1, dir);
//	    printf("\nbsa(1.1)::assuming %s as %s%s",message,drive,dir);
	    //pop the old directory
	    chdir(old_dir);
	    }
	    //otherwise illegal directory
	    else
	    {
//	    printf("\nbsa(1.1)::no such directory name: %s%s",drive,dir);
	    exit(1);
	    }
	 }//if flags & directory
	 else //no directory has been specified by the user and file's not a dir
	 {
	 getcurdir(drive[0]-'A'+1, dir);
//	 printf("\nbsa(1.1)::assuming %s as %s%s",message,drive,dir);
	 }
	}

if (dir[0]!='\\')
	{
	strcpy(old_dir,"\\");
	strcat(old_dir,dir);
	strcpy(dir,old_dir);
	}
if (dir[strlen(dir)-1]!='\\') strcat(dir,"\\");

//------------------------------------------------------------------ FILE
//no filename specified
if (!(flags & FILENAME))
	{
	strcpy(file,"*");
	if (!(flags & EXTENSION)) strcpy(ext,".*");
	}

strupr(drive);
setdisk(drive[0]-'A');
printf("\n  bsa(1.1)::assuming %s file(s): %s%s",message,file,ext);
printf("\n  bsa(1.1)::final asumptions as for %s:\n  (drive) %s\n  (directory) %s\n  (flag) %s%s",message,drive,dir,file,ext);
strcpy(new_str,drive);
strcat(new_str,dir);
strcpy(all_flag,new_str);
strcat(all_flag,"*.*");
strupr(all_flag);
strcpy(xrep_flag,file);
strcat(xrep_flag,ext);
}

void replace(char *filename)
{
   local_replacement=0;
   FILE *init_file;
   FILE *target_file;
   int thex;
   int they;
   strcpy(new_filename,filename);
   strupr(new_filename);
   local_replacement=0;
   strcpy(the_filename,new_filename);
   printf("\n  xrep::parsing %s\n       ",new_filename);
   init_file=fopen(new_filename,"rb");
   if (init_file== NULL){perror("\nxreplace::cannot open source file");return;}
   fnsplit(new_filename,_temp,_temp2,file_,ext_);
   strcpy(ext_,".XRP");
   fnmerge(new_filename,_temp,_temp2,file_,ext_);

   if (opt_overwrite==0)
   {
   target_file=fopen(new_filename,"rb");
   if (target_file!=NULL)
	{
	fclose(target_file);
	printf("\nBackup file %s found. \nDo you wish to overwrite it? [Y(es)/A(lways)/Q(uit)]",new_filename);
	switch(getch()){
	 case 'Y':
	 case 'y': printf(" YES\n");break;
	 case 'q':
	 case 'Q': exit_routine();
		   break;
	 case 'A':
	 case 'a': printf(" YES\n");opt_overwrite=1;
		   break;
	 }
	}
   }
   fclose(target_file);
   target_file=fopen(new_filename,"wb+");
   if (target_file== NULL){perror("\nxreplace::cannot open target backup file");fclose(init_file);return;}
   //create a backup copy
   for(;;)
	{
	ch=fgetc(init_file);
		if (feof(init_file)) break;
		//if (ch==0xFF) goto binary_file;
		if (ch==0x00) goto binary_file;
		fputc(ch, target_file);
	}
   goto normal_file;

   binary_file:
   printf(" (file is binary)");
   fclose(init_file);
   fclose(target_file);
   remove(new_filename);
   return;

normal_file:
   fclose(init_file);
   fclose(target_file);
   //replace algorithm
   init_file=fopen(new_filename,"rb");
   target_file=fopen(the_filename,"wb+");
   if (init_file== NULL){perror("\nxreplace::cannot open source file");return;}
   if (target_file== NULL){perror("\nxreplace::cannot open target file");fclose(init_file);return;}
   read_filesize=filesize(init_file);
   fgetpos(init_file,&begpos);
   k=0;
   thex=wherex()+1;
   they=wherey();
   strcpy(working_string,"");
   gotoxy(6,wherey());printf("[                    ] (ESCAPE aborts)");
   while(!feof(init_file)){


	asm{
	xor	ax,ax
	mov 	ah,1
	int	0x16
	cmp 	al,0x1B
	je 	exit_call
	xor 	ax,ax
	mov 	ah,0x0C
	int 	0x21
	  }
	goto noexitcall;
exit_call:
	printf("\nESCAPE pressed, aborting.");
	fclose(init_file);
	fclose(target_file);
	init_file=fopen(new_filename,"rb");
	target_file=fopen(the_filename,"wb+");
	for(;;){ch=fgetc(init_file);if feof(init_file) break; fputc(ch,target_file);}
	exit_routine();
noexitcall:


	for(cnt=0;!feof(init_file);cnt++)
	   {
	   ch=fgetc(init_file);
	   working_string[k]=ch;k++;
	   if (ch==10) break;
	   if (cnt>=sline_ssize) break;
	   }
	working_string[k]='\0';k=0;

		//make replacements!!!!

		  for(l=0,x=0,y=0,n=0;l<strlen(replace_from);l++,x++)
		  {
			for(l,n=0;l<strlen(replace_from);l++,n++)
			{
			if (replace_from[l]=='|') break;
			working_replace[n]=replace_from[l];
			}
			working_replace[n]='\0';
			for(x,y=0;x<strlen(replace_to);x++,y++)
			{
			if (replace_to[x]=='|') break;
			working_to_replace[y]=replace_to[x];
			}
			working_to_replace[y]='\0';

			//for(;;)
			//{

			strcpy(working_now,working_string);
			char *pointer;
			pointer=strstr(working_string,working_replace);
			if(pointer)
			 {
//			 printf("\nFound %s in %s",working_replace,working_string);
			 replacement++;
			 local_replacement++;
			 b=pointer-working_string;
			 working_string[b]='\0';
			 b+=strlen(working_replace);
			 strcat(working_string,working_to_replace);
			 for(a=strlen(working_string);b<=strlen(working_now);b++,a++)
				{working_string[a]=working_now[b];}
//			 printf("\nreplacing by: %s (%s)",working_string,working_to_replace);
//			 getch();
			 }
			 //else break;
			//}


			//look for working_replace
			//replace by working_to_replace
			//replace in working_string

		}


		//--------------------------
	fwrite(working_string, strlen(working_string), 1, target_file);
	gotoxy(thex,they);
	fgetpos(init_file,&thispos);
	percentage_upgrade(thispos-begpos,read_filesize,20);
//	printf("(%ld bytes) (%d replacements in this file)",thispos-begpos,local_replacement);
}

   if(local_replacement>0)
   {
   if(local_replacement>1) printf("\n     (%d occurences replaced)",local_replacement);
   if(local_replacement==1) printf("\n     (1 occurence replaced)");
   printf("\n        xrep::backup: %s \n\tfile size: ",new_filename);
	fgetpos(init_file,&thispos);
	printf("%ld -> ",thispos-begpos);
	fseek(target_file,0L,SEEK_SET);
	fgetpos(target_file,&begpos);
	fseek(target_file,0L,SEEK_END);
	fgetpos(target_file,&thispos);
	printf("%ld bytes.",thispos-begpos);


   fclose(init_file);
   fclose(target_file);
   }
   else
   {
   fclose(init_file);
   fclose(target_file);
   remove(new_filename);
   }
}

int c_break(void)
{
   printf("CTRL-BREAK pressed.");
   exit_routine();
   return(0);
}

 #define ABORT   2
 int buf[500];
 static char *err_msg[] = {
     "write protect",
     "unknown unit",
     "drive not ready",
     "unknown command",
     "data error (CRC)",
     "bad request",
     "seek error",
     "unknown media type",
     "sector not found",
     "printer out of paper",
     "write fault",
     "read fault",
     "general failure",
     "reserved",
     "reserved",
     "invalid disk change"
 };

 error_win(char *msg)
 {
    cputs(msg);
    return(ABORT);
 }

 /*
 pragma warn -par reduces warnings which occur
 due to the non use of the parameters errval,
 bp and si to the handler.
 */
 #pragma warn -par

 int handler(int errval,int ax,int bp,int si)
 {
    static char msg[80];
    unsigned di;
    int drive;
    int errorno;

    di= _DI;
 /*
 if this is not a disk error then it was
 another device having trouble
 */
    if (ax < 0)
    {
       /* report the error */
       error_win("Device error");
       /* and return to the program directly requesting abort */
       hardretn(ABORT);
    }
 /* otherwise it was a disk error */
    drive = ax & 0x00FF;
    errorno = di & 0x00FF;
 /* report which error it was */
    printf("\nxcomp::unexpected error: ");
    sprintf(msg, "%s on drive %c",err_msg[errorno], 'A' + drive);
 /*
 return to the program via dos interrupt 0x23 with abort, retry,
 or ignore as input by the user.
 */
    hardresume(error_win(msg));
    return ABORT;
 }
 #pragma warn +par

void push_cursor(void)
{
	asm{
	push	ax
	push	cx
	mov 	ah,1
	mov 	cx,5050
	int 	0x10
	pop	cx
	pop	ax
	}

}

void pop_cursor(void)
{
	asm{
	push 	ax
	push	cx
	mov 	ch,6
	mov 	cl,7
	mov 	ah,1
	int 	0x10
	pop	cx
	pop	ax
	}
}

void percentage_upgrade(long current_length,long total_length,long string_length)
{
gotoxy(7,wherey());
int m;
for (m=0;m<(current_length*string_length)/total_length;m++) printf("±");
int xx=wherex();
int yy=wherey();
gotoxy(string_length/2+5,yy);
printf("%d%",current_length*100/total_length);
gotoxy(xx,yy);
}

long filesize(FILE *stream)
{
   long curpos, length;

   curpos = ftell(stream);
   fseek(stream, 0L, SEEK_END);
   length = ftell(stream);
   fseek(stream, curpos, SEEK_SET);
   return length;
}



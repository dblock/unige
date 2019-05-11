// XC - xCOMPARE ASU Advanced Structural (Compare) Utility
// Daniel Doubrovkine - 1995 - uniGE (University of Geneva)
// last version can be found at: www.infomaniak.ch/~dblock
// first of all some excuses for unreadable code,incomprehensible structure,
// in comprehensible variables' names and some stupidities a bit everywhere.
// HEY! Why would you think i'd destribute something good?
// nope, seriously talking this prog works very well and i really like it
// very much. Compiled under Borland C/C++ 3.1 (DOS), put small memory model
// unless you want to hang up your machine.

#include <stdio.h>
#include <dos.h>
#include <string.h>
#include <dir.h>
#include <stdlib.h>
#include <conio.h>
#include <io.h>
#include <fcntl.h>
#include <ctype.h>

//variables declaration
char drive[MAXDRIVE];
char dir[MAXDIR];
char file[MAXFILE];
char ext[MAXEXT];
char source_curdir[MAXPATH];
char target_curdir[MAXPATH];
char new_str[255];
char _file[255];
char _str[255];
char __str[255];
char _ext[255];
char t_str[255];
char t__str[255];
char t_ext[255];
char _logged[255];
char _leftlogged[255];
int totalcount=0;
int dircount=0;
void still_compare(FILE *in_handle,FILE *out_handle);
void compare_routine(char *directory,char *filetocompare);
void helpme(void);
void compare_subroutine(char *from_compare,char *to_compare);
void file_compare(char *file_from,char *file_to);
void make_names2(char *source, char *message);
int scandir(char *thedir);
void option_pause(void);
void option_error(void);
void beep(void);
void exit_subroutine(void);
int _flagged=0;
int _positive=0;
int _negative=0;
int _notfound=0;
int opt_scandir=1;
int opt_quiet=0;
int opt_errors=0;
int opt_pause=0;
int opt_errors_only=0;
int target_isfile=0;
int opt_sizeonly=0;
int source_type=0;	//0:directory 1:file
int target_type=0;
int opt_inverse=0;
int opt_nobeep=0;
int opt_still=1;
int opt_existance=0;
char argument1[999];
char argument2[999];
int c_break(void);
int handler(int errval,int ax,int bp,int si);
char old_dir[MAXDIR];
char _new_logged[255];
void clean_duplicates(char *string);

//init routine
void main(int argc,char *argv[])
{
printf("XC (XCOMP) - Advanced Structural Compare Utility, version 1.31");
printf("\n             (c) Daniel Doubrovkine - (All Rights Reserved)");
printf("\n             BSA (Better String Analysis v.1.0) (c) D.D.");
printf("\n             Physical error handlers (c) by Borland International, Inc. 1992");
printf("\n             University of Geneva (Switzerland) - 1995");
printf("\n             email welcome: dblock@infomaniak.ch");
printf("\nออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ");
//clear keyboard buffer
       asm{
	xor ax,ax
	mov ah,0x0C
	int 0x21
	  }

ctrlbrk(c_break);
harderr(handler);
if (argc<3) helpme();		//less than 2 arguments (argv[0] is argc=1)
int n;for(n=0;n<argc;n++)	//treat arguments for subdir flag and SOS opt
	{
	strupr(argv[n]);

	if (strcmp(argv[n],"-L")==0) opt_still=0;
	else
	if (strcmp(argv[n],"/L")==0) opt_still=0;
	else
	if (strcmp(argv[n],"-X")==0) opt_existance=1;
	else
	if (strcmp(argv[n],"/X")==0) opt_existance=1;
	else
	if (strcmp(argv[n],"-I")==0) opt_inverse=1;
	else
	if (strcmp(argv[n],"/I")==0) opt_inverse=1;
	else
	if (strcmp(argv[n],"-B")==0) opt_nobeep=1;
	else
	if (strcmp(argv[n],"/B")==0) opt_nobeep=1;
	else
	if (strcmp(argv[n],"-Z")==0) opt_sizeonly=1;
	else
	if (strcmp(argv[n],"/Z")==0) opt_sizeonly=1;
	else
	if (strcmp(argv[n],"-S")==0) opt_scandir=0;
	else
	if (strcmp(argv[n],"/S")==0) opt_scandir=0;
	else
	if (strcmp(argv[n],"-?")==0) helpme();
	else
	if (strcmp(argv[n],"/?")==0) helpme();
	else
	if (strcmp(argv[n],"/Q")==0) opt_quiet=1;
	else
	if (strcmp(argv[n],"-Q")==0) opt_quiet=1;
	else
	if (strcmp(argv[n],"/P")==0) opt_pause=1;
	else
	if (strcmp(argv[n],"-P")==0) opt_pause=1;
	else
	if (strcmp(argv[n],"/F")==0) opt_errors=1;
	else
	if (strcmp(argv[n],"-F")==0) opt_errors=1;
	else
	if (strcmp(argv[n],"/E")==0) opt_errors_only=1;
	else
	if (strcmp(argv[n],"-E")==0) opt_errors_only=1;
	else
	if(n>2)printf("\nxcomp::illegal option: %s :will be ignored.",argv[n]);
	}
	strcpy(argument1,argv[1]);
	strcpy(argument2,argv[2]);
	if (opt_existance==1) opt_errors_only=1;
	if (opt_inverse==1) opt_quiet=1;
	if (opt_quiet==1) {opt_pause=0;opt_errors=0;}
	if (opt_errors_only==1) {opt_quiet=1;if (opt_pause==1) opt_errors=1; opt_pause=0;}
	if (opt_pause==1) {opt_errors=1;}
	if (opt_quiet==0){if (argc>3) {printf("\nxcomp::encountered %d extra option",argc-3);if(argc>4)printf("s");printf(".");}}
   //check if target is a file
   struct ffblk ffblk;

   //if argument 2 is a file, only then arg[1] can be one too

   if (findfirst(argument2,&ffblk,FA_RDONLY+FA_HIDDEN+FA_SYSTEM+/*FA_DIREC*/+FA_ARCH)!=-1)	//-1
   if (strchr(argument2,'*')==NULL)
   if (strchr(argument2,'?')==NULL)
   {
   target_isfile=1;
   }
   else
   {
   if (findfirst(argument1,&ffblk,FA_RDONLY+FA_HIDDEN+FA_SYSTEM+/*FA_DIREC+*/FA_ARCH)!=-1) //-1
   if (strchr(argument1,'*')==NULL)
   if (strchr(argument1,'?')==NULL)
   {printf("\nxcomp::illegal source:only target can be a single file.");exit(1);}
   }

file_compare(argument1,argument2);	//if two files have been specified, this will check them only

make_names2(argument2,"target");
	strcpy(t_str,drive);
	strcat(t_str,dir);
	strcat(t_str,file);
	strcat(t_str,ext);

	strcpy(target_curdir,drive);
	strcat(target_curdir,"\\");
	getcurdir(drive[0]-'A'+1,target_curdir+3);

	strcpy(t__str,drive);
	strcat(t__str,dir);
//	strcpy(_logged,t__str);

make_names2(argument1,"source");
	strcpy(_str,drive);
	strcat(_str,dir);
	strcat(_str,file);
	strcat(_str,ext);

	strcpy(__str,drive);
	strcat(__str,dir);

	strcpy(_leftlogged,__str);
	strcpy(_logged,__str);

	strcpy(source_curdir,drive);
	strcat(source_curdir,"\\");
	getcurdir(drive[0]-'A'+1,source_curdir+3);

   if (findfirst(_str,&ffblk,FA_RDONLY+FA_HIDDEN+FA_SYSTEM+FA_DIREC+FA_ARCH)==-1)
	{
	beep();
	printf("\nerror::source, no such file(s) or dir(s):\n %s",_str);option_pause();exit(1);
	}
   if (findfirst(t_str,&ffblk,FA_RDONLY+FA_HIDDEN+FA_SYSTEM+FA_DIREC+FA_ARCH)==-1)
	{
	beep();
	printf("\nerror::target, no such file(s) or dir(s):\n %s",t_str);option_pause();exit(1);
	}

if (opt_quiet==0)printf("\nsuccessfull::source: %s",_str);
if (opt_quiet==0)printf("\nsuccessfull::target: %s",t_str);
if (opt_inverse==1) printf("\nsource:: %s\n",t_str);
if(target_isfile==1)if (opt_quiet==0) printf(" (single file)");
//check for * and ? in target dir, flagged files not allowed
   if ((strchr(t_str,'*')!=NULL)||(strchr(t_str,'?')!=NULL))
   if (strstr(t_str,"*.*")==NULL){printf("\nerror::target, should be *.*, directory or file.");exit(1);}
   _flagged=1;if (strchr(t_str,'*')==NULL)
   if (strchr(t_str,'?')==NULL){_flagged=0;}
if (opt_quiet==0)printf("\nsuccessfull::target current dir: %s\nsuccessfull::source current dir: %s",source_curdir,target_curdir);

scandir(__str);

if (chdir(source_curdir)!=0) if(opt_quiet==0) perror("\nerror::chdir:source:");
if (chdir(target_curdir)!=0) if(opt_quiet==0) perror("\nerror::chdir:target:");
beep();
printf("\nออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ");
printf("\nXC (XCOMP) - Advanced Structural Compare Utility, v.1.31 D.Doubrovkine (c) 95'");
printf("\nออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ");
printf("\nxcomp::status: %d file(s) compared", totalcount);
printf("\nxcomp::status: %d dir(s) parsed",dircount);
printf("\nxcomp::status: %d file(s) matching",_positive);
printf("\nxcomp::status: %d file(s) different",_negative);
printf("\nxcomp::status: %d file(s) not found or not opened",_notfound);
printf("\nxcomp::successfully terminated!อออออออออออออออออออออออออออออออออออออออออออออออ\n");
}


void compare_routine(char *directory,char *filetocompare)
{
fcloseall();
char from_compare[255];
char to_compare[255];

if (_flagged==0){
//totalcount++;
int i,a; for(i=strlen(_leftlogged),a=0;i<strlen(_logged);i++,a++) _new_logged[a]=_logged[i];_new_logged[a]='\0';
strcpy(from_compare,directory);
strcat(from_compare,filetocompare);
strcpy(to_compare,t__str);
if(target_isfile==0)
	{
	strcat(to_compare,_new_logged);
	if (strlen(_new_logged)!=0) strcat(to_compare,"\\");
	}
strcat(to_compare,file);
strcat(to_compare,ext);
}

if (_flagged==1){
//totalcount++;
/*_new_logged*/

	int i,a;
	char _new_logged[255];
	for(i=strlen(_leftlogged),a=0;i<strlen(_logged);i++,a++)
		_new_logged[a]=_logged[i];
	_new_logged[a]='\0';

strcpy(from_compare,directory);
strcat(from_compare,filetocompare);
strcpy(to_compare,t__str);

strcat(to_compare,_new_logged);


if (strlen(_new_logged)!=0) strcat(to_compare,"\\");
strcat(to_compare,filetocompare);
clean_duplicates(to_compare);
}
//single file consideration
if (target_isfile==1) strcpy(to_compare,t_str);
compare_subroutine(from_compare,to_compare);
}

void compare_subroutine(char *from_compare,char *to_compare)
{
if (opt_quiet==0)printf("\n from:: %s\n to  :: %s",from_compare,to_compare);
FILE *in_handle;
FILE *out_handle;
if ((in_handle = fopen(from_compare,"rb")) == NULL)
{if(opt_quiet==0)
 perror("\nerror::source::open:");option_pause();
 return;}
if ((out_handle = fopen(to_compare, "rb")) == NULL)
{if(opt_quiet==0)
 perror("\nerror::target::open:");
 option_pause();
 _notfound++;
 fclose(in_handle);
 if (opt_existance==1)
	{
	printf("\nxcomp::source: %s",from_compare);
	printf("\nxcomp::target file does not exist: \n %s",to_compare);
	_negative++;
	}
 return;}

if (opt_existance==1) {_positive++;fclose(in_handle); fclose(out_handle); return;}

fseek(in_handle, 0L, SEEK_END);
fseek(out_handle, 0L, SEEK_END);
if (ftell(in_handle)!=ftell(out_handle))
	{_negative++;
	  if (opt_errors_only==1)
	  {printf("\n from:: %s\n to  :: %s",from_compare,to_compare);}
	  if ((opt_quiet==0)||(opt_errors_only==1))
		{
		beep();
		printf("\ncompare::error: files are different sizes.");
			if (opt_still==1) still_compare(in_handle,out_handle);
		}
		option_error();
		fclose(in_handle);fclose(out_handle);
		return;
	}
if (opt_sizeonly==1)
	{
	_positive++;
	printf("\nxcomp::files are same size.");
	fclose(in_handle);fclose(out_handle);
	return;
	}

fseek(in_handle, 0L, SEEK_SET);
fseek(out_handle, 0L, SEEK_SET);
int l;
while(!feof(in_handle)||!feof(out_handle))
{for(l=1;l<=50;){
int in_ch=getc(in_handle);
int out_ch=getc(out_handle);
int print_in_ch=in_ch;
int print_out_ch=out_ch;
if (in_ch!=out_ch)
	{
	switch (in_ch){
		    case 8:
		    case 26:
		    case 13:
		    case 10:
		    case 9:
		    case 7: print_in_ch=' ';
		    default: break;
		    }
	switch (out_ch){
		    case 8:
		    case 26:
		    case 13:
		    case 10:
		    case 9:
		    case 7: print_out_ch=' ';
		    default: break;

		     }

	if (opt_quiet==0)printf("\n  cmp::err#%.2d source: %.2Xh(%.3d)(%c) target: %.2Xh(%.3d)(%c) pos: %.8ld(%.8Xh)",l,in_ch,in_ch,print_in_ch,out_ch,out_ch,print_out_ch,ftell(in_handle),ftell(in_handle));l++;
	if (opt_errors_only==1)
		{
		if (l==2) printf("\n from:: %s\n to  :: %s",from_compare,to_compare);
		printf("\n  cmp::err#%.2d source: %.2Xh(%.3d)(%c) target: %.2Xh(%.3d)(%c) pos: %.8ld(%.8Xh)",l,in_ch,in_ch,print_in_ch,out_ch,out_ch,print_out_ch,ftell(in_handle),ftell(in_handle));
		}
	}
if (l>=50) break;
if (feof(in_handle)) break;
if (feof(out_handle)) break;
}
if (l>=50) break;}
if (l==1)
	{

	if (opt_inverse==1)
	{
	_positive++;
	printf("\n         %s",from_compare);
	fclose(in_handle);fclose(out_handle);
	}
	else
	{
	if (opt_quiet==0) printf("\nxcomp::files compare OK.");
	_positive++;
	}
	}
	else
	{
	if (opt_quiet==0) {beep();printf("\n     xcomp::found %d mismatch",l-1);}
	if(l-1>1)if (opt_quiet==0)printf("es");if (opt_quiet==0)printf(".");if(l>=50) if (opt_quiet==0)printf("..too many errors...ending compare.");_negative++;
	}
if (l>1) option_error();
fclose(in_handle);
fclose(out_handle);
}

void option_pause(void)
{
if (opt_pause==1)
	{
	printf("\n\txcomp::paused:hit a key.");
	switch(getch()){
		   case 0x1B:exit_subroutine();
		   default:;
		   }
	}
}

void option_error(void)
{
if (opt_errors==1)
	{
	printf("\n\txcomp::paused:hit a key.");
	switch(getch()){
		   case 0x1B:exit_subroutine();
		   default:;
		   }
	}
}

void helpme(void)
{
	printf("\nXCOMP is designed to compare separate files or full directory structures.");
	printf("\n\nThe  biggest interest  of this software is to compare two entire  directories,");
	printf("\nsubdirectories  included.  If you  make a copy of a hard disk onto a CD or  a  ");
	printf("\nSYQUEST and you are not quite sure of the result, just compare the source and");
	printf("\nthe target directories, fast and efficiently!");
	printf("\n\nDisclaimer: The author claims no responsibility for damages caused by any");
	printf("\nuse of this software, as well as third party modifications of the");
	printf("\noriginal code of XC destributed freely to encourage and help developpers.");
	printf("\n\nThough XC is totally  free, it does entirely  remain  the property of it's");
	printf("\nauthor, and thus cannot be sold! Any illegal sale of this software will be ");
	printf("\nprosecuted at maximum extent possible under the federal criminal law of the");
	printf("\nHelvetic Confederation.");
	getch();
	clrscr();
	printf("\nsyntax: XC <source> <target> <options>     (...gee that's really easy...)");
	printf("\n <source>: a single file, a flag or a directory to compare");
	printf("\n <target>: a single file or a directory to compare to");
	printf("\n <options> options start with '/' or '-');");
	printf("\n\t-? : show this help screen");
	printf("\n\t-s : do not include subdirectories");
	printf("\n\t-p : pause on all errors (unexistant files, etc...)");
	printf("\n\t-f : pause on compare errors only (different files only)");
	printf("\n\t-q : quiet mode, show statistics only (overrides -f and -p)");
	printf("\n\t-e : show compare errors only (-q is thus enabled too)");
	printf("\n\t-z : compare file size only");
	printf("\n\t-i : show matching files only");
	printf("\n\t-b : beep on errors");
	printf("\n\t-l : do not compare files of different sizes");
	printf("\n\t-x : check for existance only (-e enabled)");
	printf("\ndetail: (<source> and <target> contents:");
	printf("\n <directory> <directory>             : compare two entire directories");
	printf("\n <single file 1> <single file 2>     : compare file 1 to file 2");
	printf("\n <directory or *.*> <single file>    : compare every file of a directory to ");
	printf("\n                                       one and only target file");
	printf("\n <flag (*?.* (etc.))> <file>         : compare flagged files to a single file");
	printf("\n <flag (*?.* (etc.))> <directory>    : compare flagged files with the same");
	printf("\n                                       files in the target directory");
	exit(1);
}

void file_compare(char *file_from,char *file_to)
{
   struct ffblk ffblk;
   if (findfirst(file_from,&ffblk,FA_RDONLY+FA_HIDDEN+FA_SYSTEM/*+FA_DIREC*/+FA_ARCH)!=-1)
   if (strchr(file_from,'*')==NULL)
   if (strchr(file_from,'?')==NULL)
   if (findfirst(file_to,&ffblk,FA_RDONLY+FA_HIDDEN+FA_SYSTEM/*+FA_DIREC*/+FA_ARCH)!=-1)
   if (strchr(file_to,'*')==NULL)
   if (strchr(file_to,'?')==NULL)
   {
   if (opt_quiet==0)printf("\nxcomp::successfull:source:file: %s",file_from);
   if (opt_quiet==0)printf("\nxcomp::successfull:target:file: %s",file_to);
   compare_subroutine(file_from,file_to);
   exit(1);
   }
}

void beep(void)
{
if (opt_nobeep==1){sound(70);delay(100);nosound();}
}

int scandir(char *thedir)
{
  strupr(thedir);
  if (opt_quiet==0)printf("\nxcomp::cd: %s",thedir);
  char thestring[255];
  char thetwostring[255];
  char thedirstring[255];
  int thecount=0;
  if (drive!=NULL) if (dir!=NULL) if (thedir[strlen(thedir)-1]!='\\') strcat(thedir,"\\");

  strcpy(thestring,thedir);
  strcat(thestring,file);
  strcat(thestring,ext);

  struct ffblk ffblk;
  int done = findfirst(thestring,&ffblk,FA_RDONLY+FA_HIDDEN+FA_SYSTEM+FA_DIREC+FA_ARCH);

  while (!done)
  {
    if (ffblk.ff_attrib==FA_DIREC)
    if (opt_scandir==1)
    if (strcmp(ffblk.ff_name,".")!=0)
    if (strstr(ffblk.ff_name,"..")==NULL)
    {
    //dirtag=1;

    dircount++;
    strcpy(thetwostring,thedir);
    strcat(thetwostring,ffblk.ff_name);
    char old_logged[255];
    strcpy(old_logged,_logged);
    strcpy(_logged,thetwostring);
    chdir(thetwostring);
    scandir(thetwostring);
    strcpy(_logged,old_logged);
    }

    if (ffblk.ff_attrib!=FA_DIREC)
    if (strcmp(ffblk.ff_name,".")!=0)
    if (strstr(ffblk.ff_name,"..")==NULL)
    {
    compare_routine(thedir,ffblk.ff_name);
    thecount++;
    totalcount++;
    }

       asm{
	mov ah,1
	int 0x16
	cmp al,0x1B
	je exit_routine
	xor ax,ax
	mov ah,0x0C
	int 0x21
	  }

    nextdir:
    done = findnext(&ffblk);
  }
return(0);
exit_routine:
exit_subroutine();
return(0);
}

void make_names2(char *source, char *message)
{
int flags;					//fnsplit flags
//make from argument
flags=fnsplit(source,drive,dir,file,ext);      	//split source
//printf("\nfrom: %s\nto: %s\ndrive: %s\ndir: %s\nfile: %s\next: %s\n",from,to,drive,dir,file,ext);
//-------------------------------------------------------------- DRIVE
	//in case no drive has been specified
	if (!(flags & DRIVE))
	{
	drive[0]=_getdrive() + 'A' - 1;
	drive[1]=':';
	drive[2]='\0';
	}
	if (opt_quiet==0)printf("\nbsa::assuming %s drive:: %s", message, drive);
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
	if (strstr(dir,"...")!=NULL) {if (opt_quiet==0)printf("\nbsa::error::%s:illegal directory name:\n   %s%s",message,drive,dir);exit(1);}
	if (strstr(dir,"*")!=NULL) {if (opt_quiet==0)printf("\nbsa::error::%s:illegal directory name:\n   %s%s",message,drive,dir);exit(1);}
	if (strstr(dir,"?")!=NULL) {if (opt_quiet==0)printf("\nbsa::error::%s:illegal directory name:\n   %s%s",message,drive,dir);exit(1);}
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
	if (!chdir(new_str))
	{
	  getcurdir(drive[0]-'A'+1, dir);
	  if (opt_quiet==0)printf("\nbsa::assuming %s dir: %s\\%s",message,drive,dir);
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
	    if (opt_quiet==0)printf("\nbsa::assuming %s dir: %s\\%s",message,drive,dir);
	    //pop the old directory
	    chdir(old_dir);
	    }
	    //otherwise illegal directory
	    else
	    {
	    if (opt_quiet==0)printf("\nbsa::no such directory name: %s\\%s",drive,dir);
	    exit(1);
	    }
	 }//if flags & directory
	 else //no directory has been specified by the user and file's not a dir
	 {
	 getcurdir(drive[0]-'A'+1, dir);
	 if (opt_quiet==0)printf("\nbsa::assuming %s dir: %s\\%s",message,drive,dir);
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

if (opt_quiet==0)printf("\nbsa::assuming %s file(s): %s%s",message,file,ext);
}

//--------------------------------------------------------------------------
void exit_subroutine(void)
{
beep();
if (chdir(source_curdir)!=0) if(opt_quiet==0)perror("\nerror::chdir:source");
if (chdir(target_curdir)!=0) if(opt_quiet==0)perror("\nerror::chdir:target");
printf("\nออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ");
printf("\nXC (XCOMP) - Advanced Structural Compare Utility, v.1.31 D.Doubrovkine (c) 95'");
printf("\nออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ");
printf("\nxcomp::status: %d file(s) compared", totalcount);
printf("\nxcomp::status: %d dir(s) parsed",dircount);
printf("\nxcomp::status: %d file(s) matching",_positive);
printf("\nxcomp::status: %d file(s) different",_negative);
printf("\nxcomp::status: %d file(s) not found or not opened",_notfound);
printf("\nxcomp::user terminated.");
exit(1);
}

void still_compare(FILE *in_handle,FILE *out_handle)
{
fseek(in_handle, 0L, SEEK_SET);
fseek(out_handle, 0L, SEEK_SET);
	for (;;)
	{
	int in_ch=getc(in_handle);
	int out_ch=getc(out_handle);
	if (in_ch!=out_ch) break;
	if (feof(in_handle)||feof(out_handle)) break;
	}

	if (ftell(in_handle)==1) {if (opt_quiet==0) printf("\nNo bytes matching.");}
	else	  {if (opt_quiet==0) printf("\nMismatch at position: %.8ld (%.8Xh)",ftell(in_handle),ftell(in_handle));}

	fclose(in_handle);
	fclose(out_handle);

}

int c_break(void)
{
   printf("CTRL-BREAK pressed.");
   exit_subroutine();
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

void clean_duplicates(char *string)
{
	int a,b;
	for(a=0,b=0;a<=strlen(string);a++)
		{
		if (string[a]=='\\')
		 {if (string[a+1]=='\\') goto nowrite;}

		string[b]=string[a];
		b++;
		nowrite:
		}
		string[b]='\0';
}

#include <conio.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <dir.h>
#include <dos.h>
#include <ctype.h>

char *s;
char drive[MAXDRIVE];
char dir[MAXDIR];
char file[MAXFILE];
char ext[MAXEXT];
char dirname[255];
char filename[255];
char leftside[255];
char rightside[255];
char nextname[255];
int nextchar=0;
char cmdline[255];
int disknum=0;
char diskname[255];
int thenum=0;
int num_files(char *thename);
int check_dups(char *filename);
char filename_table[9999]="";
int always_flag=0;

void treat_errors(char *argument, int argnum)
{
clrscr();
int error=0;
if (strchr(argument, '?')==NULL)
if (strchr(argument, '*')==NULL) error=1;
if (strchr(argument, '?')!=NULL)
if (strchr(argument, '*')!=NULL) error=1;
if (argnum!=2) error=1;

if (error==1)
	{
	printf("[ZiPiT 2.1] Error in arguments...\n");
	printf("Syntax: ZiPiT [ZiPLeFT][* or ?][ZiPRiGHT]\n");
	printf("in english: ZIPIT ZIPNAME\n");
	printf("where ZIPNAME contains a * (or ?) character for the changing number.\n");
	printf("An example for stupid ones who did not understant my clear explanation:\n");
	printf("ZIPIT F:\\FILES\\ZIP*HI.ZIP\n");
	printf("Where ZIP*HI.ZIP represents these files:\n");
	printf("        zip1hi.zip\n");
	printf("        zip2hi.zip\n");
	printf("        zip3hi.zip\n");
	printf("        zip??hi.zip\n");
	printf("ZiPiT 2.1 search algorithm will try to find any alternative name for the\n");
	printf("changing part, so sequences like 1,2...9,0 then A,B,C, etc... will be\n");
	printf("treated. ZiPiT will make DISK1, DISK2, DISK3, etc... directories and run\n");
	printf("PKUNZIP to unzip the zips into them, make PKUNZIP accessible to ZiPiT!\n");
	printf("Note: ZiPiT can be interrupted by pressing ESCAPE at any moment.");
	exit(1);
	}
}

int separate_name_dir(char *argument)
{
if (strchr(argument, '\\')==NULL) {strcpy(dirname,""); strcpy(filename,argument); return(0);}
char *ptr = strrchr(argument, '\\');
int i,a;
for (i=0;i<=ptr-argument;i++) dirname[i]=argument[i];
for (a=0,i;i<=strlen(argument);a++,i++) filename[a]=argument[i];
return(0);
}

int separate_name_parts(char *argument)
{
int chrforsep;
if (strchr(argument, '?')!=NULL) chrforsep='?';
if (strchr(argument, '*')!=NULL) chrforsep='*';

char *ptr = strchr(argument, chrforsep);
int i,a;
for (i=0;i<ptr-argument;i++) leftside[i]=argument[i];
for (a=0,i=i+1;i<=strlen(argument);a++,i++) rightside[a]=argument[i];
//printf("\n%s - %s ... %s - %s", dirname, filename, leftside, rightside);
return(0);
}

int create_next_name(void)
{
nextchar++;
strcpy(nextname,dirname);
strcat(nextname,leftside);
	int dec, sign;
	int ndig=1;
	if (nextchar>=10) ndig=2;
	if (nextchar>=100) ndig=3;
	if (nextchar>=1000) ndig=4;
	if (nextchar>=10000) ndig=5;
	strcat(nextname,ecvt(nextchar, ndig, &dec, &sign));
	strcat(nextname,rightside);
return(0);
}

int create_next_name3(void)
{
strcpy(nextname,dirname);
strcat(nextname,leftside);
strcat(nextname,"X");
nextname[strlen(dirname)+strlen(leftside)]=nextchar;
strcat(nextname,rightside);

return(0);
}

int create_next_name2(void)
{
strcpy(nextname,dirname);
strcat(nextname,leftside);
	int dec, sign;
	int ndig=1;
	if (nextchar<10) strcat(nextname,"0");
	if (nextchar>=10) ndig=2;
	if (nextchar>=100) ndig=3;
	if (nextchar>=1000) ndig=4;
	if (nextchar>=10000) ndig=5;
	strcat(nextname,ecvt(nextchar, ndig, &dec, &sign));
	strcat(nextname,rightside);
return(0);
}

int makenewdir (void)
{
	disknum++;
	int dec, sign;
	int ndig=1;
	if (disknum>=10) ndig=2;
	if (disknum>=100) ndig=3;
	if (disknum>=1000) ndig=4;
	if (disknum>=10000) ndig=5;
	strcpy(diskname,"DISK");
	strcat(diskname,ecvt(disknum, ndig, &dec, &sign));
	return(0);
}

int show_existing(void)
{
	int i;
	struct ffblk ffblk;
	int looking;

	create_next_name();

	if (thenum==disknum)
	{
	printf("[ZiPiT] Total of %d files processed...", disknum);
	exit(1);
	}
	looking = findfirst(nextname,&ffblk,0);

	fnsplit(nextname,drive,dir,file,ext);
	if ((check_dups(file)==-1)||(looking))
	{
	printf("lookup failed.\n");
	create_next_name2();

	looking = findfirst(nextname,&ffblk,0);
	fnsplit(nextname,drive,dir,file,ext);
	if ((check_dups(file)==-1)||(looking))
	{
	if (nextchar<58) nextchar='A';
	printf("lookup failed.\n");
	create_next_name3();
	looking = findfirst(nextname,&ffblk,0);
	fnsplit(nextname,drive,dir,file,ext);
	if ((check_dups(file)==-1)||(looking))
	{
	printf("[ZiPiT] Total of %d files processed...", disknum);
	exit(1);
	}}}
	printf("lookup successfull.\n");
	makenewdir();
	strcpy(cmdline,"PKUNZIP -d ");
	strcat(cmdline,nextname);
	strcat(cmdline," ");
	strcat(cmdline,diskname);
	if (!mkdir(diskname))
	printf("[ZiPiT] Created %s directory...\n", diskname);
	else
	{
	if (findfirst(diskname,&ffblk,FA_DIREC)!=-1)
		{printf("[ZiPiT] Directory %s already exists!\n",diskname);}
	else
		{ printf("[ZiPiT] Error creating %s",diskname);
		  perror("");}
	printf("\tIgnore? [(Y)es/(N)o/(A)lways] ");
	if (always_flag==0)
	{
	switch(getch()){
		       case 0x1B:
		       case 'N':
		       case 'n':printf("NO\n[ZiPiT] Exiting on error...");
				exit(1);
		       case 'A':
		       case 'a':always_flag=1;
		       case 'Y':
		       case 'y':
		       case 'O':
		       case 'o':
		       default: printf("YES\n");
		       }
	}
	else
	{
	printf("YES\n");
	}
	}

	printf("[ZiPiT] Executing: %s\n",cmdline);

	asm{
	mov ah,1
	int 16h
	cmp al,1Bh
	je exit_routine
	xor ax,ax
	mov ah,0Ch
	int 21h
	  }

	if (system(cmdline)==-1)
		{perror("[ZiPiT] Error executing PKUNZIP");}

	asm{
	mov ah,1
	int 16h
	cmp al,1Bh
	je exit_routine
	xor ax,ax
	mov ah,0Ch
	int 21h
	  }

	return(0);

exit_routine:
	printf("[ZiPiT] Interrupted by user.\n");
	exit(1);
	return(0);
}

void main (int argc,char **argv)
{
treat_errors(argv[1],argc);
separate_name_dir(argv[1]);
separate_name_parts(filename);
printf("ZiPiT 2.1 - Daniel Doubrovkine - January, 1995\n\n");
thenum=num_files(argv[1]);
for(;;)
show_existing();
}

int num_files(char *the_name)
{
struct ffblk ffblk;
int done;
int numfiles=0;
printf("[ZiPiT] Searching for files with the %s pattern...\n",the_name);
done = findfirst(the_name,&ffblk,0);
while (!done)
{
numfiles++;
printf("   þ %s\n", ffblk.ff_name);
done = findnext(&ffblk);
}
printf("[ZiPiT] Processed a total of %d zips...\n",numfiles);
return(numfiles);
}

int check_dups(char *filename)
{
printf("[ZiPiT] Enhanced verification for %s",filename);
if (strlen(filename)>8) {printf("...failed...",filename); return(-1);}
strcat(filename,";");
if (strstr(filename_table,filename)==NULL)
	{
	strcat(filename_table,filename);
	printf("...passed...",filename);
	return(0);
	}
filename[strlen(filename)-1]='\0';
printf("...failed...",filename);
return(-1);
}

/* ===== vlist.c =================================================================
(c) Daniel Doubrovkine - 1997 - University of Geneva - doubrov5@cui.unige.ch

	mutexed clist unit, part of the xmount project	

comments, description:

	clist is the C version of C++ template ilist structures (c) D.D.- 1996
	i.e chained list of templated (ilist) or predefined (clist) record type 
	here used with mount_record which is the contents of parameters for
	a unit available for mount as defined by version 6.0 of AT&T UNIX

	functions advised for external use: 
		list_count		- number of entries
		list_contents		- output of contents
		list_remove_device	- remove an item by device
		list_get_device		- get a record by device
		chew_tab		- construct the chained list

	there's a blocking mutex that should be initialized from a parent core
		construct_flag_mutex
---------------------------------------------------------------------------------- */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

pthread_mutex_t construct_flag_mutex;

typedef struct {
	char * source_device;
	char * target_path;
	char * source_fs;
	char * mount_options;
	char * fs_freq;
	char * fs_passno;
	char * alias;
	} mount_record;

typedef struct {
	void * next;		
	void * previous;
	mount_record * contents;
	} node;

typedef struct {
	void * ptr;		
	int count;
	} clist;

/*count items in a clist*/
int list_count(clist * alist){
	return(alist->count);
	}

/*init a clist (you better do it before using a clist)*/
clist * list_init(void){
	clist * target;
	
	target = (clist *) malloc(sizeof(clist));	
	target->ptr = NULL;
	target->count = 0;
	return(target);
	}

/*list contents of a clist*/
void list_contents(clist * alist){
	node * cnode;

	if (!alist) return;		
	pthread_mutex_lock(&construct_flag_mutex);
	cnode = alist->ptr;
	while (cnode) {
		/*
		printf("    source device: %s\n", cnode->contents->source_device);
		printf("      target path: %s\n", cnode->contents->target_path);
		printf("source filesystem: %s\n", cnode->contents->source_fs);
		printf("    mount options: %s\n", cnode->contents->mount_options);
		printf("      source fsck: %s\n\n", cnode->contents->source_fsck);
		*/
		printf("\t[%s][%s]\n", cnode->contents->source_device, cnode->contents->target_path);
		cnode = cnode->next;
		}
	pthread_mutex_unlock(&construct_flag_mutex);
	}

/*add an item to a list*/
void list_add(clist * alist, mount_record * arecord){
	node * new_node;

	new_node = (node *) malloc (sizeof(node));
	new_node->next = alist->ptr;
	if (alist->ptr) ((node *) alist->ptr)->previous = new_node;
	alist->ptr = new_node;
	new_node->previous = alist;
	new_node->contents = arecord;
	}

/*compare records by fields*/
int compare_record(char * entry[], mount_record * target){	
	return(
		((strcmp(target->source_device, entry[5]))||
		(strcmp(target->target_path, entry[4])) ||
		(strcmp(target->source_fs, entry[3])) /*||
		(strcmp(target->mount_options, entry[2]))||
		(strcmp(target->fs_freq, entry[1]))||
		(strcmp(target->fs_passno, entry[0]))*/)
		
		);
	}

/*init a single mount record (better use this one to create a record)*/
mount_record * mount_record_init(char * entry[]) {
	mount_record * target;
	int i;

	target = (mount_record *) malloc (sizeof(mount_record));
	target->source_device = entry[5];
	target->target_path = entry[4];
	target->source_fs = entry[3];
	target->mount_options = entry[2];
	target->fs_freq = entry[1];
	target->fs_passno = entry[0];
	if (!strcmp(target->source_device, "/ramdisk/dev/fd0")) {
           	if (!strcmp(target->target_path, "/mnt/floppy/msdos")) target->alias = "[floppy - msdos]";
	   else if (!strcmp(target->target_path, "/mnt/floppy/linux")) target->alias = "[floppy - linux]";
	   else if (!strcmp(target->target_path, "/mnt/floppy/win95")) target->alias = "[floppy - win95]";
	   } else
	if (!strcmp(target->source_device, "/ramdisk/dev/fd1")) {
           	if (!strcmp(target->target_path, "/mnt/floppy2/msdos")) target->alias = "[second floppy - msdos]";
	   else if (!strcmp(target->target_path, "/mnt/floppy2/linux")) target->alias = "[second floppy - linux]";
	   else if (!strcmp(target->target_path, "/mnt/floppy2/win95")) target->alias = "[second floppy - win95]";
	   }
	else if (strstr(target->source_fs, "iso9660")) target->alias = "[cdrom]";
	else target->alias = NULL;
	return(target);
	}

/*recursively dispose a clist*/
void list_free(clist * alist) {
	node * cnode;
	node * tnode;

	cnode = alist->ptr;
	while (cnode){
		tnode = cnode;
		cnode = cnode->next;
		free(tnode->contents);
		free(tnode);
		}
	free(alist);
	}

/*remove an item by device from a clist*/
int list_remove_device(clist * alist, char * device){
	node * cnode;

	cnode = alist->ptr;
	while (cnode){
		if (!strcmp(cnode->contents->source_device, device)) {
			if (cnode->previous) ((node *) cnode->previous)->next = cnode->next;
			if (cnode->next) ((node*) cnode->next)->previous = cnode->previous;
			/*printf("removing [%s]\n", cnode->contents->source_device);*/
			free(cnode->contents);
			free(cnode);
			return(1);
			}
		cnode = cnode->next;
		}
	return(0);
	}

/* get device by contents */
mount_record * list_get_device(clist * alist, char * device, char * target){
	node * cnode;

	pthread_mutex_lock(&construct_flag_mutex);
	cnode = alist->ptr;
	while (cnode) {
		/*printf("looking for [%s->%s] in [%s->%s]\n", device, target, cnode->contents->source_device, cnode->contents->target_path); */
		if ((!strcmp(cnode->contents->source_device, device))&&
		    (!strcmp(cnode->contents->target_path, target)))  {
			pthread_mutex_unlock(&construct_flag_mutex);
			return(cnode->contents);
			}
		cnode = cnode->next;
		}
	pthread_mutex_unlock(&construct_flag_mutex);
	return(0);
	}

/*get an record by alias*/
mount_record * list_get_alias(clist * alist, char * dev_alias){
	node * cnode;

	pthread_mutex_lock(&construct_flag_mutex);
	cnode = alist->ptr;
	while (cnode) {
		if (cnode->contents->alias) 
		if (!strcmp(cnode->contents->alias, dev_alias)) {
			pthread_mutex_unlock(&construct_flag_mutex);
			return(cnode->contents);
			}
		cnode = cnode->next;
		}
	pthread_mutex_unlock(&construct_flag_mutex);
	return(0);
	}

/*get a single line from a tab file*/
int getline(char *s, int n, FILE *f) {
    register int i=0;

    while(1) {
        s[i] = (char)fgetc(f);
        if(s[i] == 13) s[i] = fgetc(f);
        if(feof(f)||(s[i] == 10)||(i==(n-1))) {
            s[i] = '\0';
            return (feof(f) ? 1 : 0);
        }
    ++i;
    }}

/*add an entry from a line read from tab (moderated by a clist)*/
void add_tabentry(clist * tab_list, char * s, clist * moderator){
	char * icnt[6];
	int i;
	char * j;
	char * k;
	node * cnode;
	int moderate;

	for (i=0;i<=4;i++){
		j = strrchr(s, 32);
		k = strrchr(s, 9);
		if (k > j) j = k;
		
		icnt[i] = strdup(j + 1);
		j[0] = '\0';
		while ((j[-1] == 9)||(j[-1] == 32)) (--j)[0]='\0';
		}
	icnt[5] = strdup(s);
	moderate = 0;
	if (moderator){
	   cnode = moderator->ptr;
	   while (cnode) {
		if (!(compare_record(icnt, cnode->contents))) {
				//("moderated [%s] by: [%s]\n", icnt[5], cnode->contents->source_device);
				
				moderate = 1;
				break;
				}	
		cnode = cnode->next;
		}
	   }
	if (!moderate) list_add(tab_list, mount_record_init(icnt));
	}

/*parse the tab file and construct a clist (optionally moderated)*/
clist * chew_tab(char * ntab, clist * moderator){
	FILE * tab_file;
	char * s;
	clist * tab_list;	

	debugs("vlist::chewing tab\n");
	tab_list = list_init();
	debugs("vlist::chew init done\n");
	if (!(tab_file = fopen(ntab, "r"))) {
		debugs("vlist::unable to open demanded file\n");
		return(0);	
		}
	s = (char *) malloc(1024*sizeof(char));
	getline(s, 1024, tab_file);
	while (!feof(tab_file)) {
		add_tabentry(tab_list, s, moderator);
		getline(s, 1024, tab_file);
		}
	fclose(tab_file);
	return(tab_list);
	}


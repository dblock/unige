/* ===== vcore.c =================================================================
(c) Daniel Doubrovkine - 1997 - University of Geneva - doubrov5@cui.unige.ch

	common xmount project routines / xview / debug / clists, etc...
	also contains the forked mount exec routines
---------------------------------------------------------------------------------- */
#define developp
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

/* ===== debug(s) ================================================================
	descr:  	debug routines for debug output
---------------------------------------------------------------------------------- */
void debugs(char * istr){
	#ifdef develop
	fprintf(stderr, istr);
	#endif
	}

void debug(char * istr){
	#ifdef develop
	debugs(istr);
	fprintf(stderr, "\n");
	#endif
	}

/* ===== xstatus(s) ==============================================================
	descr:  	outputs a string to the status pane
---------------------------------------------------------------------------------- */
void xstatus(char * status_str){
	textsw_insert(xvmount_xmount_main->status_pane, "XMount -> ", strlen("XMount -> "));
	textsw_insert(xvmount_xmount_main->status_pane, status_str, strlen(status_str));
	textsw_insert(xvmount_xmount_main->status_pane, "\n", strlen("\n"));
	}

#include "vlist.c"

char * fs_unspec = "[unspecified]";

int mtab_in_use;
pthread_mutex_t mount_flag_mutex;
int xmount_terminated;

clist * fstab;
clist * mtab;
clist * full_fstab;

Notify_client client1 = (Notify_client) 10;
int pipe_io[2];

#include "vmount.c"

#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/resource.h>

char * separator = " -> \0";

/* ===== clear_xview_list ========================================================
	descr:  	deletes all items from a list
---------------------------------------------------------------------------------- */
void clear_xview_list(Xv_object * aObject){
	int items_count;

	items_count = xv_get((int) aObject, PANEL_LIST_NROWS, INSTANCE);
	if (items_count)
	while (items_count--) {
		xv_set((int) aObject, PANEL_LIST_DELETE, 0, NULL);  
		}
	}

/* ===== fill_xview_single_list ==================================================
	descr:  	fills a list with the contents of a clist, checks aliases
---------------------------------------------------------------------------------- */
void fill_xview_single_list(Xv_object * aObject, clist * alist){
	node * cnode;
	int cnt;
	int lcnt;
	int access_rights;
	int can_add;
	char * icontents;
	mount_record * inside_contents;

	cnt = 0;
	lcnt = 0;
	cnode = alist -> ptr;
	while (cnode){
		if (cnode->contents->alias) {
			icontents = strdup(cnode->contents->alias);			
			} else {
			icontents = (char *) malloc (sizeof(char) * 
				(strlen(cnode->contents->source_device) + strlen(cnode->contents->target_path) + strlen(separator) + 1));
				strcpy(icontents, cnode->contents->source_device);
				icontents[strlen(cnode->contents->source_device)] = '\0';
				strcat(icontents, separator);
				icontents[strlen(cnode->contents->source_device) + strlen(separator)] = '\0';
				strcat(icontents, cnode->contents->target_path);
				icontents[strlen(cnode->contents->source_device) + strlen(separator) + strlen(cnode->contents->target_path)] = '\0';
			}
		can_add = 1;
		if (geteuid())
			if (alist == fstab) can_add = (int) (strstr(cnode->contents->mount_options, "user"));
			else {
				can_add = 0;
				inside_contents = list_get_device(full_fstab, cnode->contents->source_device, cnode->contents->target_path);
				if (inside_contents) can_add = (int) (strstr(inside_contents->mount_options, "user"));
			    }
		if (can_add) {
			xv_set((int) aObject, PANEL_LIST_INSERT, lcnt, PANEL_LIST_STRING, lcnt, icontents, NULL);
				lcnt++;
			}
		cnt ++;
		free(icontents);
		cnode = cnode->next;
		}
	}

/* ===== fill_xview_lsit =========================================================
	descr:  	clears and fills the mtab and fstab lists
---------------------------------------------------------------------------------- */
void fill_xview_list(Xv_window win){
	xvmount_xmount_main_objects *ip = (xvmount_xmount_main_objects *) xv_get(win, XV_KEY_DATA, INSTANCE);

	clear_xview_list((Xv_object *) ip->fstab_list);
	clear_xview_list((Xv_object *) ip->mount_list);
	fill_xview_single_list((Xv_object *) ip->mount_list, mtab);
	fill_xview_single_list((Xv_object *) ip->fstab_list, fstab);
	panel_paint(ip->lists_panel, PANEL_CLEAR);
	}

/* ===== xv_enable_disable =======================================================
	descr:  	disables and enabled buttons
---------------------------------------------------------------------------------- */
void xv_enable_disable(int truefalse){
	xv_set(xvmount_xmount_main->command_unmount, PANEL_INACTIVE, truefalse ,NULL);
	xv_set(xvmount_xmount_main->command_mount, PANEL_INACTIVE, truefalse,NULL);
	xv_set(xvmount_xmount_main->root_command_unmount, PANEL_INACTIVE, truefalse ,NULL);
	xv_set(xvmount_xmount_main->root_command_mount, PANEL_INACTIVE, truefalse,NULL);
	panel_paint(xvmount_xmount_main->lists_panel, PANEL_CLEAR);
	}

/* ===== mount_unmount_xview =====================================================
	descr:  	treats list entry for partition mount / umount
---------------------------------------------------------------------------------- */
void mount_unmount_xview(char * d_constructor, int mount){
	char * device;
	char * target;
	mount_record * i_device;

	pthread_mutex_lock(&mount_flag_mutex);
	xv_enable_disable(TRUE);
	if (strstr(d_constructor, separator)) {
		target = strdup(strstr(d_constructor, separator) + strlen(separator));
		device = strdup(d_constructor);
		device[strstr(d_constructor, separator) - d_constructor] = '\0';
		fstab_user_mount_unmount(device, target, mount);
		free(device);
		free(target);
		} else {
		i_device = list_get_alias(full_fstab, d_constructor);
		if (i_device) 
			fstab_user_mount_unmount(i_device->source_device, i_device->target_path, mount);
			else {
				xv_enable_disable(FALSE);
				pthread_mutex_unlock(&construct_flag_mutex);			
			     }
	}}

/* ===== read_vmount =============================================================
	descr:  	notify client for output from mount (forked)
---------------------------------------------------------------------------------- */
Notify_value read_vmount(Notify_client client, register int fd) {
	char buf[1024];
	int bytes, i;

	if (!ioctl(fd, FIONREAD, &bytes))
		while(bytes)
			if ((i=read(fd, buf, sizeof buf))>0){
				textsw_insert(xvmount_xmount_main->status_pane,buf,i);
				bytes -= i;
				}
	return NOTIFY_DONE;
	}

/* ===== sigchldcatcher ==========================================================
	descr:  	signal catcher for mount terminate from fork
---------------------------------------------------------------------------------- */
Notify_value sigchldcatcher(Notify_client client, int pid, union wait * status, struct rusage * rusage){
	if (WIFEXITED(*status)){
		textsw_normalize_view(xvmount_xmount_main->status_pane, (Textsw_index) xv_get(xvmount_xmount_main->status_pane, TEXTSW_INSERTION_POINT));
		notify_set_input_func(client, NOTIFY_FUNC_NULL, (client == client1)?pipe_io[0]:0);
		xv_enable_disable(FALSE);
		pthread_mutex_unlock(&mount_flag_mutex);
		return NOTIFY_DONE;
		}
	return NOTIFY_IGNORED;
	}

/* ===== resize_lists ============================================================
	descr:  	main window fit routine (to avoid xview resize bugs:)
---------------------------------------------------------------------------------- */
void resize_lists(xvmount_xmount_main_objects *ip){
	double lists_dim;
	double stats_dim = 0.2;
	double comm_dim = 0.2;
	double root_dim = 0.2;

	if (geteuid()) lists_dim = 0.6; else lists_dim = 0.4;
	xv_set(ip->lists_panel, XV_HEIGHT, (int) (xv_get(ip->xmount_main, XV_HEIGHT, INSTANCE) * lists_dim), NULL);
	xv_set(ip->status_pane, XV_HEIGHT, (int) (xv_get(ip->xmount_main, XV_HEIGHT, INSTANCE) * stats_dim), NULL);
	xv_set(ip->status_pane, XV_Y, (int) (xv_get(ip->lists_panel, XV_HEIGHT, INSTANCE)), NULL);
	xv_set(ip->command_controls, XV_HEIGHT, (int) (xv_get(ip->xmount_main, XV_HEIGHT, INSTANCE) * comm_dim), NULL);
	xv_set(ip->command_controls, XV_Y, (int) (xv_get(ip->status_pane, XV_HEIGHT, INSTANCE)+ xv_get(ip->status_pane, XV_Y, INSTANCE)), NULL);
	xv_set(ip->command_panel, XV_HEIGHT, (int) (xv_get(ip->xmount_main, XV_HEIGHT, INSTANCE) * root_dim), NULL);
	xv_set(ip->command_panel, XV_Y, (int) (xv_get(ip->command_controls, XV_HEIGHT, INSTANCE) + xv_get(ip->command_controls, XV_Y, INSTANCE)), NULL);
	xv_set(ip->lists_panel, XV_WIDTH, xv_get(ip->xmount_main, XV_WIDTH, INSTANCE), NULL);
	xv_set(ip->command_panel, XV_WIDTH, xv_get(ip->xmount_main, XV_WIDTH, INSTANCE), NULL);
	xv_set(ip->mount_list, PANEL_LIST_WIDTH, (int) (xv_get(ip->xmount_main, XV_WIDTH, INSTANCE) / 2) - xv_get(ip->command_unmount, XV_WIDTH, INSTANCE) - 25, NULL);
	xv_set(ip->fstab_list, PANEL_LIST_WIDTH, xv_get(ip->mount_list, PANEL_LIST_WIDTH, INSTANCE), NULL);
	xv_set(ip->command_mount, XV_X, xv_get(ip->mount_list, PANEL_LIST_WIDTH, INSTANCE) + xv_get(ip->mount_list, XV_X, INSTANCE) + 30, NULL);
	xv_set(ip->command_unmount, XV_X, xv_get(ip->command_mount, XV_X, INSTANCE),  NULL);
	xv_set(ip->fstab_list, XV_X, xv_get(ip->command_unmount, XV_WIDTH, INSTANCE) + xv_get(ip->command_unmount, XV_X, INSTANCE) + 20, NULL);
	xv_set(ip->fstab_list, PANEL_LIST_DISPLAY_ROWS, (int) xv_get(ip->mount_list, PANEL_LIST_DISPLAY_ROWS, INSTANCE), NULL);
	xv_set(ip->mount_list, PANEL_LIST_DISPLAY_ROWS, (int) ((xv_get(ip->lists_panel, XV_HEIGHT, INSTANCE) - 3 * xv_get(ip->lists_panel, XV_Y, INSTANCE)) / xv_get(ip->mount_list, PANEL_LIST_ROW_HEIGHT, INSTANCE)) - 3,NULL);
	}

/* ===== destroy_func ============================================================
	descr:  	interposed destroy handler
---------------------------------------------------------------------------------- */
Notify_value destroy_func(Notify_client client, Destroy_status status){
	if ((status == DESTROY_CLEANUP)||(status == DESTROY_PROCESS_DEATH)) {
		decmutex(&threads_running, &threads_running_mutex, &threads_running_condition);	
		textsw_reset(xvmount_xmount_main->status_pane, 0, 0);
		xmount_terminated = 1;
		return(notify_next_destroy_func(client, status));
		}
	return(NOTIFY_DONE);
	}

/* ===== init_env==== ============================================================
	descr:		environment init for internationalization 
---------------------------------------------------------------------------------- */
void init_env(void) {
	char *xvmount_env;
	char *domain_path;
	char *help_path;
	xvmount_env = getenv("XVMOUNT_HOME");
	if (xvmount_env) {
		domain_path = (char *) malloc (strlen(xvmount_env) + 8);
		strcpy(domain_path, xvmount_env);
		strcat(domain_path, "/locale");
	} else
		domain_path = "/user/l1/doubrov5/works/syst/xmount/locale";

	bindtextdomain("xvmount_labels", domain_path);
	xvmount_env = getenv("HELPPATH");
	if (xvmount_env) {
		help_path = (char *) malloc (strlen(xvmount_env) + strlen(domain_path) + 11);
		strcpy(help_path,"HELPPATH=");
		strcat(help_path, domain_path);
		strcat(help_path, ":");
		strcat(help_path, xvmount_env);
	} else 
		help_path = "/user/l1/doubrov5/works/syst/xmount/locale";
	putenv(help_path);
	}

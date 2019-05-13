/* ===== vlist.c =================================================================
(c) Daniel Doubrovkine - 1997 - University of Geneva - doubrov5@cui.unige.ch

	mount side routines, part of the xmount project	

comments, description:

	mount side functions use the mount_record structure constructed as
	defined in the 6.0 version of AT&T UNIX

	for external use:
		is_mount
		root_mount (system call mount)
		fstab_mount (system exec mount)		
---------------------------------------------------------------------------------- */

#include <sys/mount.h>
#include <linux/fs.h>
#include <sys/signal.h>

/* for future additionnal implementation of root device mount 
   (currently still using direct system(mount)
int is_mount(char * device, char * target) {
	return (int) list_get_device(mtab, device, target);
	}

typedef struct {
	int read_only;
	int no_suid;
	int no_dev;
	int no_exec;
	int sync;
	int remount;
	int magic_flag;
	} root_mount_options;

char * root_mount(mount_record * device, root_mount_options * root_options) {
	int r_opt;

	if (!device) return("no device specified");

	debug("[mounting root access device:]");
	debugs("\tdevice:      "); debug(device->source_device);
	debugs("\ttarget:      "); debug(device->target_path);
	debugs("\tfile system: "); debug(device->source_fs);
	debugs("\toptions:     "); debug(device->mount_options);	
	debugs("\tdump field:  "); debug(device->fs_freq);
	debugs("\tfsck field:  "); debug(device->fs_passno);

	r_opt = 0;
	if (root_options) {
		if (root_options->read_only) r_opt&=MS_RDONLY;
		if (root_options->no_suid) r_opt&=MS_NOSUID;
		if (root_options->no_dev) r_opt&=MS_NODEV;
		if (root_options->no_exec) r_opt&=MS_NOEXEC;
		if (root_options->sync) r_opt&=MS_SYNCHRONOUS;
		if (root_options->remount) r_opt&=MS_REMOUNT;
		if (root_options->magic_flag) r_opt&=MS_MGC_VAL;
		} else r_opt = MS_MGC_VAL;

	mount(device->source_device, 
		     device->target_path,
		     device->source_fs,
		     r_opt,
		     0);		     
	return(strerror(errno));
	}
*/

/*mount fork routine
  execute the mount and initialize the notify client */
void mount_fork_exec(char * execstr){
	Notify_value read_vmount(), sigchldcatcher();
	FILE * fp;
	int pid, i;
	
	xstatus(execstr);
	pipe(pipe_io);
	switch (pid = fork()){
		case -1: close(pipe_io[0]);
			 close(pipe_io[1]);
			 perror("unable to pipe");
			 xmount_terminated = 1;
			 pthread_exit(0);
		case 0:
			 dup2(pipe_io[1], 1);
			 dup2(pipe_io[1], 2);
			 close(pipe_io[0]);
			 for (i = getdtablesize();i>2;i--) (void) close(i);
			 for (i = 0;i<NSIG;i++) (void) signal(i, SIG_DFL);
			 system(execstr);
			 close(pipe_io[1]);
			 exit(0);
		default:
		         close(pipe_io[1]);
		}
		notify_set_input_func(client1, read_vmount, pipe_io[0]);
		notify_set_wait3_func(client1, sigchldcatcher, pid);
	}

/*root device mount*/
void root_mount_unmount(char * device, char * mnt, char * fs, char * addit, int mount){
	char execstr[1024];
	
	if ((!strlen(device))&&(!strlen(mnt))) return;
	if (mount) sprintf(execstr, "mount"); else sprintf(execstr, "umount");
	if (device) if (strlen(device)) sprintf(execstr, "%s %s", execstr, device);
	if (mnt) if (strlen(mnt)) sprintf(execstr, "%s %s", execstr, mnt);
	if (fs) if (strcmp(fs, (char *) dgettext("xvmount_labels", "[unspecified]"))) sprintf(execstr, "%s -t %s", execstr, fs);
	if (addit) if (strlen(addit)) sprintf(execstr, "%s %s", execstr, addit);
	mount_fork_exec(execstr);	
	}

/*user device mount*/
void fstab_user_mount_unmount(char * device, char * target, int mount){
	char execstr[1024];
	
	if (mount) sprintf(execstr, "mount %s", target);
	else sprintf(execstr, "umount %s", target);
	mount_fork_exec(execstr);
	}

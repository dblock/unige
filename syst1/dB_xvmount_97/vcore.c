/* ===== vcore.c =================================================================
(c) Daniel Doubrovkine - 1997 - University of Geneva - doubrov5@cui.unige.ch

	multithread kernel unit, part (heart) of the xmount project	
	(the main of the project is here)
	it will initialize the mutex and create a fstab fixed structure
	it will create two threads, one that will maintain mtab changes
	the other that will maintain the interface
---------------------------------------------------------------------------------- */

#include <stdio.h>
#include <stdlib.h>
#include "sched.h"
#include <pthread.h>

int threads_running;

pthread_mutex_t threads_running_mutex;
pthread_cond_t threads_running_condition;
pthread_mutex_t interface_done;

#define MTAB "/etc/mtab"
#define FSTAB "/etc/fstab"

/* ===== decmutex ================================================================
	descr:  	mutex decrement
	block: 		core / application
	blocking vars:  (mutexed) arg(* decint) <- (mutex) arg(* rmutex)
	yielding cond:  (signal) arg(* rcond) <- (mutexed) arg(* decint) <- 0 
	tasks: 		yield arg(*rcond) if arg(*decint) is zero 
---------------------------------------------------------------------------------- */
void decmutex(int * decint, pthread_mutex_t * rmutex, pthread_cond_t * rcond){
	pthread_mutex_lock(rmutex);
	(*decint)--;
	if (!(*decint)) pthread_cond_signal(rcond);
	pthread_mutex_unlock(rmutex);
	}

#include "vcommon.c"
#include <sys/stat.h> 
#include <sys/types.h>                  
#include <unistd.h>
#include <time.h>


/* ===== mtab_construct ==========================================================
	descr:  	descendant of mtab_organize
			reconstruct calls for the mtab clist structure  
	block: 		core
	blocking vars:  (mutex) construct_flag_mutex (mtab construction)
	tasks: 		exclusive parse on the mtab, clist and mtab_stat rebuild  
---------------------------------------------------------------------------------- */
void mtab_construct(struct stat * mtab_stat){
	debugs("core::mtab construct: entry\n");
	pthread_mutex_lock(&mount_flag_mutex);
	if (mtab) list_free(mtab);
	if (fstab) list_free(fstab);
	mtab = chew_tab(MTAB, NULL);
	fstab = chew_tab(FSTAB, mtab);
	if ( -1 ==  stat (MTAB, mtab_stat)) {
      		debugs("core::mtab contructor:died at mtab stat retrieve");
		pthread_mutex_unlock(&mount_flag_mutex);
		decmutex(&threads_running, &threads_running_mutex, &threads_running_condition);
      		pthread_exit(0);
      		}
	debugs("mtab:\n");
	debugs("fstab:\n");
	debugs("core::mtab/fstab reconstructed\n");
	pthread_mutex_lock(&interface_done);	
	fill_xview_list(xvmount_xmount_main->xmount_main);
	pthread_mutex_unlock(&interface_done);
	pthread_mutex_unlock(&mount_flag_mutex);
	}

/* ===== mtab_organize ===========================================================
	descr:  	descendant of maintain_core
			consult modifications on mtab  
	block: 		core
	blocking vars:  (mutex) construct_flag_mutex (mtab construction)
	tasks: 		check the modification stats for mtab  
---------------------------------------------------------------------------------- */
void mtab_organize(struct stat * mtab_stat){
	struct stat mtab_stat_now;
	if ( -1 ==  stat (MTAB, &mtab_stat_now)) {
      		debugs("core::mtab contructor:died at mtab stat retrieve\n");
		decmutex(&threads_running, &threads_running_mutex, &threads_running_condition);
      		pthread_exit(0);
      		}
	if (mtab_stat->st_mtime!=mtab_stat_now.st_mtime) {
		pthread_mutex_lock(&construct_flag_mutex);
		mtab_construct(mtab_stat);
		pthread_mutex_unlock(&construct_flag_mutex);
		}
	}

/* ===== maintain_core ============================================================
	descr:  	maintain_core is the entry for the mtab maintance thread  
	block: 		core
	blocking vars:  (mutexed) threads_running <- threads_running_mutex
			(mutex) construct_flag_mutex (mtab construction)
	blocking conds: (mutexed) threads_running <- threads_running_condition <- 0
	tasks: 		initialize and maintain the interface in a separate block 
---------------------------------------------------------------------------------- */
void maintain_core(void * args){
	int xmount_term_read;
	struct stat mtab_stat;
	debugs("core::maintain_core(entry)\n");
	full_fstab = chew_tab(FSTAB, NULL);
	mtab_construct(&mtab_stat);
	while((!xmount_terminated)&&(threads_running == 2)) {
		mtab_organize(&mtab_stat);
		sleep(1);
		}
	debugs("core::maintain_core(exit)\n");
	list_free(fstab);
	list_free(mtab);
	list_free(full_fstab);
	decmutex(&threads_running, &threads_running_mutex, &threads_running_condition);
	}

/* ===== maintain_interface ======================================================
	descr:  	maintain_interface is the entry for the X-Interface 
	block: 		core
	blocking vars:  (mutexed) threads_running <- threads_running_mutex
	blocking conds: (mutexed) threads_running <- threads_running_condition <- 0
	tasks: 		initialize and maintain the interface in a separate block 
---------------------------------------------------------------------------------- */
void maintain_interface(void * args){
	debugs("core::maintain_interface(entry)\n");
	init_env();
	INSTANCE = xv_unique_key();
	xvmount_xmount_main = xvmount_xmount_main_objects_initialize((xvmount_xmount_main_objects *) NULL, (Xv_opaque) NULL);
	Xvmount_about_box = xvmount_about_box_objects_initialize((xvmount_about_box_objects *) NULL, (Xv_opaque) NULL);
	notify_interpose_destroy_func(xvmount_xmount_main->xmount_main, destroy_func);
	pthread_mutex_unlock(&interface_done);
	xv_main_loop(xvmount_xmount_main->xmount_main);
	debugs("core::maintain_interface(exit)\n");
	decmutex(&threads_running, &threads_running_mutex, &threads_running_condition);
	}


/* ===== init_core ================================================================
	descr:  	init_core is the main kernel unit of the whole application
	block: 		application / core
	blocking vars: 	(mutexed) threads_running <- threads_running_mutex
	blocking conds:	(mutexed) threads_running <- threads_running_condition <- 0
	tasks: 		initialize mutex and two main threads 
			- core_thread (mtab / fstab parallelization maintaince)
			- interface_thread (interface jobs, semaphore responsibilities) 
---------------------------------------------------------------------------------- */
void init_core(void){
	pthread_t core_thread_id;
	pthread_t interface_thread_id;
	void * core_thread_entry;
	void * interface_thread_entry;
	pthread_attr_t thread_attr;
	pthread_mutexattr_t recursive_mutex_attr; 
	xmount_terminated = 0;
	threads_running = 2;
	pthread_attr_init(&thread_attr);
	pthread_mutexattr_init(&recursive_mutex_attr);
	pthread_mutexattr_setkind_np(&recursive_mutex_attr, PTHREAD_MUTEX_RECURSIVE_NP);
	pthread_cond_init(&threads_running_condition, 0);
	pthread_mutex_init(&interface_done, 0);
	pthread_mutex_lock(&interface_done);
	pthread_mutex_init(&threads_running_mutex, 0);
	pthread_mutex_init(&mount_flag_mutex, 0);
	pthread_mutex_init(&construct_flag_mutex, &recursive_mutex_attr);
	core_thread_entry = &maintain_core;
	pthread_create(&core_thread_id, &thread_attr, core_thread_entry, NULL);
	interface_thread_entry = &maintain_interface;
	pthread_create(&interface_thread_id, &thread_attr, interface_thread_entry, NULL);
	pthread_cond_wait(&threads_running_condition, &threads_running_mutex);
	}



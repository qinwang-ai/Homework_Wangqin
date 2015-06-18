#include "pcb.h"

int process_num = 2; 
int start_process_num = 1;
char isProcessRun = 0; 
struct pcb PCB_queue[ process_num_MAX +1 ];
struct semaphore sema_array[ sema_num_MAX +1]; 

struct fcb{
	const char *name;
	char f_num;
	char f_size;
	char f_addr;		//block num
	int f_toMem;		//
};

extern struct fcb FCB_array[];

short int w_is_r;
short int nw_is_r;
short int _cs,_flags;
int _ip;
short int _ax,_bx,_cx,_dx,_es,_ds,_sp,_bp,_si,_di,_fs,_gs,_ss;

inline void backto_os(){
	init_flag_position();	
	__asm__("pop %si");
	screen_init();
	__asm__("pop %si");
	print_welcome_msg();
	__asm__("pop %si");
	print_message();
	__asm__("pop %si");
	print_flag(); //root@wangqin4377@:   position
	__asm__("pop %si");
}

inline void saveToqueue(){
	PCB_queue[ w_is_r].tss.ES = _es;
	PCB_queue[ w_is_r].tss.DS = _ds;
	PCB_queue[ w_is_r].tss.GS = _gs;
	PCB_queue[ w_is_r].tss.FS = _fs;
	PCB_queue[ w_is_r].tss.SS = _ss;
								
	PCB_queue[ w_is_r].tss.AX = _ax;
	PCB_queue[ w_is_r].tss.BX = _bx;
	PCB_queue[ w_is_r].tss.CX = _cx;
	PCB_queue[ w_is_r].tss.DX = _dx;
	PCB_queue[ w_is_r].tss.SI = _si;
	PCB_queue[ w_is_r].tss.DI = _di;
	PCB_queue[ w_is_r].tss.BP = _bp;
}

inline void queueTodata(){
	_es = PCB_queue[ nw_is_r].tss.ES;
	_ds = PCB_queue[ nw_is_r].tss.DS;
	_gs = PCB_queue[ nw_is_r].tss.GS;
	_fs = PCB_queue[ nw_is_r].tss.FS;
	_ss = PCB_queue[ nw_is_r].tss.SS;
							   
	_ax = PCB_queue[ nw_is_r].tss.AX;
	_bx = PCB_queue[ nw_is_r].tss.BX;
	_cx = PCB_queue[ nw_is_r].tss.CX;
	_dx = PCB_queue[ nw_is_r].tss.DX;
	_si = PCB_queue[ nw_is_r].tss.SI;
	_di = PCB_queue[ nw_is_r].tss.DI;
	_bp = PCB_queue[ nw_is_r].tss.BP;
}


void init_pcb( int i, short int current_process_SEG){
	//tss
	PCB_queue[ i].tss.DS = 0; 
	PCB_queue[ i].tss.ES = current_process_SEG; 
	PCB_queue[ i].tss.FS = 0; 
	PCB_queue[ i].tss.CS = 0; 
	PCB_queue[ i].tss.SS = 0; 
	PCB_queue[ i].tss.GS = 0; 
	PCB_queue[ i].tss.DI = 0; 
	PCB_queue[ i].tss.SI = 0; 
	PCB_queue[ i].tss.SP = current_process_SEG-4; 
	PCB_queue[ i].tss.BP = 0; 
	PCB_queue[ i].tss.AX = 0; 
	PCB_queue[ i].tss.BX = 0; 
	PCB_queue[ i].tss.CX = 0; 
	PCB_queue[ i].tss.DX = 0; 
	PCB_queue[ i].tss.IP = current_process_SEG;		//cs;ip 
	PCB_queue[ i].tss.Flags = 512; 
	PCB_queue[ i].tss.Stack_END = current_process_SEG-4; 

	PCB_queue[ i].f_pid = -1; 
	PCB_queue[ i].process_id = i; 
	PCB_queue[ i].process_status = READY; 
}

int fin_times = 0;
void schedule(){
	saveall_reg();			//hurry not inclue sp	
	__asm__("pop %cx");
	__asm__("pop %eax");	//junk

	if( PCB_queue[ w_is_r].process_status == RUNNING){
		PCB_queue[ w_is_r].process_status = READY;
	}
	while(1){
		if( w_is_r == 0)
			nw_is_r = start_process_num;
		else
			nw_is_r = w_is_r + 1;

		if( nw_is_r > process_num){
			nw_is_r = start_process_num;	
		}
		if( PCB_queue[ nw_is_r].process_status == READY) break;
		w_is_r = nw_is_r;
	}
	
	PCB_queue[ nw_is_r].process_status = RUNNING;

	saveToqueue();			//code order don't change	

	//----------------set ip cs flag--------
	__asm__("pop %ax");
	__asm__("pop %bx");
	__asm__("pop %cx");

	saveall_reg_seg();		//include sp
	__asm__("pop %cx");

	if( _di == 0x1234){	
		isProcessRun = 0;			//shut down process
		nw_is_r = 0;
		process_num --;
		backto_os();
	}else{
		isProcessRun = 1;
	}


	PCB_queue[ w_is_r].tss.SP = _sp;
	PCB_queue[ w_is_r].tss.IP = _ip;
	PCB_queue[ w_is_r].tss.CS = _cs;
	PCB_queue[ w_is_r].tss.Flags = _flags;

	//-----------------end------------------
	_ip = PCB_queue[ nw_is_r].tss.IP;
	_cs = PCB_queue[ nw_is_r].tss.CS;
	_flags = PCB_queue[ nw_is_r].tss.Flags;
	_sp = PCB_queue[ nw_is_r].tss.SP;

	restore_reg_seg();		//include sp
	__asm__("pop %cx");

	queueTodata();		// ax bx cx...
	
	w_is_r = nw_is_r;			//change now running process
	restore_reg();	
	__asm__(" pop %di");		//don't use di in any process is dangerous

	__asm__(" jmp schedule_end");
	while(1);
}

void Process(){
	int current_process_SEG = process_SEG;
	int i,j;
	for( i = start_process_num; i <= process_num; i++){
		current_process_SEG = i*0x0800;
		init_pcb( i, current_process_SEG);
	}
	for( i = 0;i<= sema_num_MAX; i++){
		sema_array[ i].count = 0;
		sema_array[ i].used = 0;
		sema_array[ i].head = 0;
		sema_array[ i].tail = 0;
	}

	load_user( 1, FCB_array[ 0].f_toMem);
	__asm__(" pop %cx");
	load_user( 2, FCB_array[ 1].f_toMem);
	__asm__(" pop %cx");
		// 4000- sub stack 

	w_is_r = 0;
	isProcessRun=1; // enter user process mode
}

void update_fa(){
	saveall_reg();			//hurry not inclue sp	
	__asm__("pop %cx");
	saveToqueue();			//code order don't change	

	__asm__("mov %sp,%dx");	//save fa ip flags  cs sp
	__asm__("add $22,%sp");
	__asm__("pop %ax");
	__asm__("pop %bx");
	__asm__("pop %cx");

	saveall_reg_seg();		//include sp
	__asm__("pop %cx");

	__asm__("mov %dx,%sp");
	PCB_queue[ w_is_r].tss.SP = _sp;
	PCB_queue[ w_is_r].tss.IP = _ip;		
	PCB_queue[ w_is_r].tss.CS = _cs;
	PCB_queue[ w_is_r].tss.Flags = _flags;
}
extern void restore_flags();
short int sub_stack,fa_stack;
void do_fork(){
	process_num++;
	PCB_queue[ process_num].f_pid = w_is_r;		//sub -> father
	PCB_queue[ process_num].process_id = process_num;
	//copy_fa_Tss
	
	update_fa();
	restore_flags();	//to fix some stack bug
	__asm__("pop %cx");
	// update fa end	
	PCB_queue[ process_num].tss = PCB_queue[ w_is_r].tss;
	PCB_queue[ process_num].tss.SP = _sp + 0x1000;
	PCB_queue[ process_num].tss.AX = 0;
	PCB_queue[ process_num].tss.Stack_END = PCB_queue[ w_is_r].tss.Stack_END+0x1000; 
	
	sub_stack = (PCB_queue[ process_num].tss.Stack_END-0x200)/16;
	fa_stack = (PCB_queue[ w_is_r].tss.Stack_END-0x200)/16;
	__asm__("mov $0x104,%cx");
	copy_stack();
	__asm__("pop %cx");

	PCB_queue[ process_num].process_status = READY;

	restore_ax_pid();
	__asm__("pop %bx");

	__asm__("pop %bx");
	__asm__("pop %bx");
	__asm__("pop %bx");
	__asm__("jmp *%bx");
}

void do_wait(){
	PCB_queue[ w_is_r].process_status = BLOCK;
	__asm__("int $0x1c");
	__asm__("pop %ax");
	__asm__("pop %ax");
	__asm__("pop %ax");
	__asm__("jmp *%ax");
}
void do_exit(){
	PCB_queue[ w_is_r].process_status = DONE;
	PCB_queue[ PCB_queue[ w_is_r].f_pid].process_status = READY;
	__asm__("int $0x1c");
	__asm__("pop %ax");
	__asm__("pop %ax");
	__asm__("pop %ax");
	__asm__("jmp *%ax");
}
char if_find = 0;
char sema_index;
int i;
void do_getsem(){
	if_find = 0;
	for(i=0;i<=sema_num_MAX;i++){
		if( sema_array[ i].used == 0){
			sema_array[ i].used = 1;
			if_find = 1;
			sema_index = i;
			break;
		}
	}
	if( !if_find){
		return_sema(-1);
	}
	return_sema( sema_index);
	__asm__("pop %cx");
	__asm__("pop %ecx");

	__asm__("pop %bx");
	__asm__("pop %bx");
	__asm__("pop %bx");
	__asm__("jmp *%bx");  //back to os_syscall callrun  
}

void semaBlock( char s){
	PCB_queue[ w_is_r].process_status = BLOCK;
	sema_array[ s].block_queue[ sema_array[ s].tail] = w_is_r;
	sema_array[ s].tail++;
	if( sema_array[ s].tail>process_num_MAX)
		sema_array[ s].tail = 0;
}
char s_index;
void do_P(){
	sitoindex();
	__asm__("pop %bx");

	sema_array[ s_index].count --;
	if( sema_array[ s_index].count<0){
		semaBlock( s_index);	
	}

	__asm__("mov %bp,%sp");
	__asm__("pop %bx");
	__asm__("pop %bx");
	__asm__("pop %bx");
	__asm__("jmp *%bx");  //back to os_syscall callrun  
}
char temp;
void semaWakeUp( char s){
	temp = sema_array[ s].block_queue[ sema_array[ s].head];
	PCB_queue[ temp].process_status = READY;
	sema_array[ s].head++;
	if( sema_array[ s].head > process_num_MAX)
		sema_array[ s].head = 0;
}

void do_V(){
	sitoindex();
	__asm__("pop %bx");
	sema_array[ s_index].count ++;
	if( sema_array[ s_index].count<=0){
		semaWakeUp( s_index);	
	}
	__asm__("mov %bp,%sp");
	__asm__("pop %bx");
	__asm__("pop %bx");
	__asm__("pop %bx");
	__asm__("jmp *%bx");  //back to os_syscall callrun  
}
void do_free(){
	sitoindex();
	__asm__("pop %bx");
	sema_array[ s_index].count = 0;
	sema_array[ s_index].used = 0;
	sema_array[ s_index].head = 0;
	sema_array[ s_index].tail = 0;
	__asm__("mov %bp,%sp");
	__asm__("pop %bx");
	__asm__("pop %bx");
	__asm__("pop %bx");
	__asm__("jmp *%bx");  //back to os_syscall callrun  
}



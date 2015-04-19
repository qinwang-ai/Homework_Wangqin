__asm__(".code16gcc");

#include "stdio.h"
#include "os.h"
//--------------------------local-------

char listen_key();
void syscall_test();




char key[64];
char screen_sc_T = 1;
char flag_len=17; //root@wangqin4377
//============================+MAIN==============
void main(){
	//--------------------init
	init_ss();
	screen_init();
	interrupt_init();
	syscall_init();
	print_welcome_msg();
	print_message();
	print_flag(); //root@wangqin4377@:   position
	//--------------------init_end

	while(1){
		char length = listen_key();

		if_screen_scroll(); //bottom of screen	
		flag_scroll();//move flag to next line
		print_flag();
	}
}

//============================MAIN END===============

char listen_key(){
//	unsigned short int init_pos = get_pointer_pos();
	flag_len=17;
	char i = gets( key);
	screen_sc_T = 1;
	if( strcmp( key, "clear\0")){			// char *,const char *
		clear();
		return i;
	}

	if( strcmp( key, "time\0")){
		time();
		return i;
	}

	if( strcmp( key, "date\0")){
		date();
		return i;
	}

	if( strcmp( key, "python\0")){
		python();
		return i;
	}

	if( strcmp( key, "help\0")){
		//can't refer 2 two times, so...
		init_flag_position();	
		screen_init();
		print_welcome_msg();
		print_message();
		print_flag(); //root@wangqin4377@:   position

		return i;
	}


//---------------------------------mark: man xxx, run xxx,asc xx...

	if( synCheck( key, "asc\0")){
		asc( key);
		return i;
	}

	if( synCheck( key, "man\0")){
		man( key);
		return i;
	}	
	
	if( synCheck( key, "run\0")){
		run( key);
		return i;
	}

	if( synCheck( key, "syscall\0")){
		syscall_test();
		return i;
	}


	if( synCheck( key, "int\0")){
		if( strcmp( key, "int 33h")){
			__asm__(  "int $0x33");
			return i;
		}
		if( strcmp( key, "int 34h")){
			__asm__(  "int $0x34");
			return i;
		}
		if( strcmp( key, "int 35h")){
			__asm__(  "int $0x35");
			return i;
		}
		if( strcmp( key, "int 36h")){
			__asm__(  "int $0x36");
			return i;
		}
	}

	if( key[0] == '\0'){
		return i;
	}
	
	flag_scroll();
	set_pointer_pos();
	print_str("  No such file or Directory", 27);
	screen_sc_T = 2;
	return i;
}

void syscall_test(){
	switch( key [8]){
		case '0':{
			__asm__("mov $0,%ah");  //012
			__asm__("int $0x80");
			break;
		}
		case '1':{
			__asm__("mov $0xb800,%ax");
			__asm__("mov %ax,%es");
			__asm__("mov $542,%dx");	// 542 548 576
			__asm__("mov $1,%ah");  //123
			__asm__("int $0x80");
			break;
		}
		case '2':{
			__asm__("mov $0xb800,%ax");
			__asm__("mov %ax,%es");
			__asm__("mov $548,%dx");	// 542 548 576
			__asm__("mov $2,%ah");  //123
			__asm__("int $0x80");
			break;
		}

		default:return;
	}
}



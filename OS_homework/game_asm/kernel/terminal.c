#include "terminal.h"

char key[64];
char screen_sc_T = 1;
char flag_len=17; //root@wangqin4377
char Print_flag_mark = 1;
char j;
struct fcb{
	const char *name;
	char f_num;
	char f_size;
	char f_addr;		//block num
	int f_toMem;		//
};

extern struct fcb FCB_array[];

//--------------------------------- SHELL core os.c---------
char listen_key(){
//	unsigned short int init_pos = get_pointer_pos();
	flag_len=17;
	char i = gets( key);
	screen_sc_T = 1;
	Print_flag_mark = 1;
	if( strcmp( key, "clear\0")){			// char *,const char *
		clear();
		return i;
	}

	if( strcmp( key, "python\0")){
		python();
		Print_flag_mark = 1;
		return i;
	}

	if( strcmp( key, "game\0")){
		clear();
		set_pointer_pos();
		Print_flag_mark = 0;
		print_equl();
		__asm__("pop %cx");
		Process();
		return i;
	}
	if( strcmp( key, "ls\0")){
		for (j = 0;j<= 5;j++){
			printToscn(' ');
			print_str( FCB_array[j].name ,strlen( FCB_array[ j].name));
		}	
		printToscn('\r');
		for (j = 6;j<= 7;j++){
			printToscn(' ');
			print_str( FCB_array[j].name ,strlen( FCB_array[ j].name));
		}
		flag_scroll();
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
		
	if( strcmp( key, "run user1\0")){
		run( "run 1");
		return i;
	}else{
		if( strcmp( key, "run user2\0")){
			run( "run 2");
		}
		return i;
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




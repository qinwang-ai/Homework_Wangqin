#include "terminal.h"

char key[64];
char screen_sc_T = 1;
char flag_len=17; //root@wangqin4377
char Print_flag_mark = 1;

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

	if( strcmp( key, "start\0")){
		clear();
		set_pointer_pos();
		Print_flag_mark = 0;
		Process();
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
		
	if( synCheck( key, "run\0")){
		run( key);
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




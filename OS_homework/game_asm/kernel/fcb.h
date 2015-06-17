#define file_sum 7
struct fcb{
	const char *name;
	char f_num;
	char f_size;
	char f_addr;		//block num
	int f_toMem;		//
};
struct fcb FCB_array[ file_sum];
inline void fcb_init(){
	FCB_array[0].name = "process1\0"; 
	FCB_array[1].name = "process2\0"; 
	FCB_array[2].name = "process3\0"; 
	FCB_array[3].name = "process4\0"; 
	FCB_array[4].name = "process_wait\0"; 
	FCB_array[5].name = "user1\0"; 
	FCB_array[6].name = "user2\0"; 
	FCB_array[0].f_addr = 37; 
	FCB_array[1].f_addr = 73; 
	FCB_array[2].f_addr = 109; 
	FCB_array[3].f_addr = 145; 
	FCB_array[4].f_addr = 181;
	FCB_array[5].f_addr = 217;
	FCB_array[6].f_addr = 253;
	FCB_array[0].f_toMem = 0x0800; 
	FCB_array[1].f_toMem = 0x1000; 
	FCB_array[2].f_toMem = 0x1800; 
	FCB_array[3].f_toMem = 0x2000; 
	FCB_array[4].f_toMem = 0x2800;
	FCB_array[5].f_toMem = 0x3000;
	FCB_array[6].f_toMem = 0x1000;
}


char Usr_num = '3';
void run( char *str){
	str += 4;
	while( *str != '\0'){
		if('0'<*str && *str< Usr_num){
		
				load_user( 6 + *str-'0', FCB_array[ 7].f_toMem);	//in oslib.asm	usri in i sector 
				__asm__(" pop %ax");

				run_user();
				__asm__(" pop %ax");
				
		}else{
			run_error();
			return;
		}
		str++;
	}
	init_flag_position();	
	screen_init();
	print_welcome_msg();
	print_message();
	print_flag(); //root@wangqin4377@:   position
}


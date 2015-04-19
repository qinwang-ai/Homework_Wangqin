extern void interrupt_init();
extern void syscall_init();
extern void print_message();
extern void print_welcome_msg();

inline void run( char *str){
	str += 4;
	
	while( *str != '\0'){
		if('0'<*str && *str<'4'){
			load_user( *str-'0');	//in oslib.asm	usri in i sector 
			run_user();
			
			}else{
				run_error();
			}
		str++;
	}
	init_flag_position();	
	screen_init();
	print_welcome_msg();
	print_message();
	print_flag(); //root@wangqin4377@:   position
}


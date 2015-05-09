#ifndef _OS_H
#define _OS_H

__asm__(".code16gcc");

extern void interrupt_init();
extern void syscall_init();
extern void print_message();
extern void print_welcome_msg();
extern char listen_key();
extern void print_flag();
extern void loader_user( char , unsigned short int);


extern char Print_flag_mark;
char Usr_num = '3';

inline void run( char *str){
	str += 4;
	
	while( *str != '\0'){
		if('0'<*str && *str< Usr_num){
		
				load_user( 6 + *str-'0', 0x1000);	//in oslib.asm	usri in i sector 
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

#endif

#include "os.h"

//============================+MAIN==============
void main(){
	//--------------------init
	screen_init();
	__asm__("pop %si");
	interrupt_init();
	__asm__("pop %si");
	syscall_init();
	__asm__("pop %si");
	print_welcome_msg();
	__asm__("pop %si");
	print_message();
	__asm__("pop %si");
	print_flag(); //root@wangqin4377@:   position
	__asm__("pop %si");
	//--------------------init_end
	while(1){
		char length = listen_key();

		if_screen_scroll(); //bottom of screen	
		flag_scroll();//move flag to next line
		__asm__("pop %si");
		if( Print_flag_mark)
			print_flag();
		__asm__("pop %si");
	}
}

//============================MAIN END===============



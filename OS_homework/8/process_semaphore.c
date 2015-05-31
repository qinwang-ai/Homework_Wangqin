#include "muti_process.h"

#define DelayTime 120
char fruit_disk; // 苹果=1，雪梨=2，。。。
short int semaphore1,semaphore2;
char words[60];
char pid;
void main(){
    semaphore1 = GetSem( 0);
    semaphore2 = GetSem( 1);

    if ( fork())
		while(1) { 
			sema_P( semaphore1); 
			sema_P( semaphore2); 
			myprintf( words);
			fruit_disk=0;

			delay();
			__asm__("pop %ax");
			delay();
			__asm__("pop %ax");

		}
	else{
			if( fork())
				while(1) { 
					putwords("Father will live one year after anther for ever! \0");
					sema_V(semaphore1);

					delay();
					__asm__("pop %ax");
					delay();
					__asm__("pop %ax");

				}
			else
				while(1){ 
					putfruit(); 
					sema_V(semaphore2);

					delay();
					__asm__("pop %ax");
					delay();
					__asm__("pop %ax");
				}
	}
}




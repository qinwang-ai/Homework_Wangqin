#include "muti_process.h"

char fruit_disk; // 苹果=1，雪梨=2，。。。
int s;
char words[60];
void main(){
    GetSem( 0);
	while(1);
    if ( fork())
		while(1) { 
			sema_P(s); 
			sema_P(s); 
			myprintf(words);
			fruit_disk=0;
		}
	 else    
		if(fork())
		while(1) { 
			while(1);
			putwords("Father will live one year after anther for ever!\0"); 
			sema_V(s);
		}
	    else
		    while(1) { putfruit(); sema_V(s);}
}




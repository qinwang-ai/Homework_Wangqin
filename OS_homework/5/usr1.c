
#include "user.h"

char key[64];
char screen_sc_T = 1;
char flag_len=17; //root@wangqin4377
char ch = '1';
const char *msg="";

int a;
void main(){

	screen_init();

	getch( &ch);
	gets( key);
	putch('\r');
	putch('\n');
	scanf("a=%d",&a);

	putch( ch);
	puts( key);
	printint( "ch=%c,a=%d,str=%s",ch,a,key);

	wait_key();
}



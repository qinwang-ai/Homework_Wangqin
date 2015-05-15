#include "muti_process.h"

char str[ 80] = "129djwqhdsajd128dw9i39ie93i8494urjoiew98kdkd";
int LetterNr = 0;
void main() {
	__asm__( "sti");
	int pid;
	char ch;
	printf( "\r\nBefore fork \r\n");
	printf( "fork start..");
	pid = fork();
	if ( pid == -1) printf( "error in fork!\0");
	if ( pid){
		printf( "\r\nFather process:after fork pid is ");
		printInt( pid);
		printf( "\r\nFather process:running...");
		printf( "\r\nFather process:blocked \r\n\r\n");

		ch = wait();
		printf( "\r\nFather process:running...");
		printf( "\n\rFather process:LetterNr=");
		ntos( LetterNr);
		printf( "\r\nFather process:exit");
		exit(0);
	}
	else{
		printf( "\r\nSub process:after fork pid is ");
		printInt( pid);
		printf( "\r\nSub process:running...");

		CountLetter( str);
		printf( "\r\nSub process:exit\r\n\r\n");
		exit( 0);
	}
}



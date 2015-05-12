#include "muti_process.h"

char str[ 80] = "129djwqhdsajd128dw9i39ie93i8494urjoiew98kdkd";
int LetterNr = 0;
void main() {
	__asm__( "sti");
	int pid;
	char ch;
	printf( "\r\nprocess_counter:Before fork \r\n");
	printf( "fork start");
	pid = fork();
	printf( "\r\nafter fork; my pid is ");
	if ( pid == -1) printf( "error in fork!\0");
	if ( pid){
		ch = wait();
		printf( "LetterNr=");
		ntos( LetterNr);
		exit(0);
	}
	else{
		CountLetter( str);
		exit( 0);
	}
}



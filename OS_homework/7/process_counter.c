#include "muti_process.h"

char str[ 80] = "129djwqhdsajd128dw9i39ie93i8494urjoiew98kdkd";
int LetterNr = 0;
void main() {
	__asm__("sti");
	int pid;
	char ch;
	pid = fork();
	while(1);
	if ( pid == -1) printf( "error in fork!\0");
	if ( pid){
		ch = wait();
		printf( "LetterNr=");
		ntos( LetterNr);
	}
	else{
		CountLetter( str);
		exit( 0);
	}
}



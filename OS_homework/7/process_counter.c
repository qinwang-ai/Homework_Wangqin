#include "muti_process.h"

char str[ 80] = "129djwqhdsajd128dw9i39ie93i8494urjoiew98kdkd";
int LetterNr = 0;
void main() {
	while(1);
	int pid;
	char ch;
	pid = fork();
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



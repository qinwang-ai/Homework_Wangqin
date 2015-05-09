#ifndef _muti_process_H
#define _muti_process_H
__asm__(".code16gcc");

extern char return_ax_Tpid();
char pid;
char fork(){
	__asm__("mov $6,%ah");
	__asm__("int $0x80");

	pid = return_ax_Tpid();
	__asm__("pop %cx");
	return pid;	
}

void ntos( short int value ){
	char *str = itoa( value);
	print_str( str, strlen( str));
}

extern int LetterNr;
void inline CountLetter( char *str){
	char i;
	for (i = 0;i<80;i++){
		if( str[ i] <='z' && str[ i] >='a'){
			LetterNr++;
		}
	}
}

char flag_len = 17;
void inline printf( char *str){
	print_str( str, strlen( str));
}

#endif



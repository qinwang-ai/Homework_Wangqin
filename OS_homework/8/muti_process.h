#ifndef _muti_process_H
#define _muti_process_H
__asm__(".code16gcc");


__asm__("pushw %ds;");
__asm__("pushw %es;");
__asm__("mov %cs, %ax\n");
__asm__("mov %ax, %ds\n");
__asm__("mov %ax, %es\n");
__asm__("call main\n");
__asm__("popw %es;");
__asm__("popw %ds;");


char flag_len = 17;
void inline printf( char *str){
	print_str( str, strlen( str));
}


void inline ntos( short int value ){
	char *str = itoa( value);
	print_str( str, strlen( str));
}

void printInt( char s){
	printToscn( s+'0');
}

extern char return_ax_Tpid();
char pid;
char fork(){
	__asm__("cli");
	__asm__("mov $6,%ah");
	__asm__("int $0x80");

	pid = return_ax_Tpid();
	__asm__("pop %cx");
	__asm__("sti");
	return pid;
}


char wait(){
	__asm__("cli");
	__asm__("mov $7,%ah");
	__asm__("int $0x80");
	__asm__("sti");
	return pid;	
}

void exit( char x){
	__asm__("cli");
	__asm__("mov $8,%ah");
	__asm__("int $0x80");
	__asm__("sti");
	while(1);
}
char GetSem( char value ){
	__asm__("cli");
	__asm__("mov $9,%ah");
	__asm__("int $0x80");
	__asm__("pop %ebx");
	__asm__("pop %ebx");
	__asm__("pop %bx");
	__asm__("sti");
	__asm__("jmp *%bx");
}
void sema_P( int s){
	__asm__("cli");
	stosi( s);
	__asm__("pop %cx");
	__asm__("mov $10,%ah");
	__asm__("int $0x80");
	__asm__("pop %ebx");
	__asm__("pop %ebx");
	__asm__("pop %bx");
	__asm__("sti");
	__asm__("int $0x1c");
	__asm__("jmp *%bx");
}
void sema_V( int s){
	__asm__("cli");
	stosi( s);
	__asm__("pop %cx");
	__asm__("mov $11,%ah");
	__asm__("int $0x80");
	__asm__("pop %ebx");
	__asm__("pop %ebx");
	__asm__("pop %bx");
	__asm__("sti");
	__asm__("int $0x1c");
	__asm__("jmp *%bx");
}
void ReleaseSem( char value ){
	__asm__("cli");
	__asm__("mov $12,%ah");
	__asm__("int $0x80");
	__asm__("sti");
}

void myprintf( char *str){
	printf( str);
	printf( "AND father enjoy fruit\n\r\n\r");
}
extern char words[60];
void putwords( char *str){
	char i = 1;
	while( *str!='\0'){
		words[ i-1] = *str;
		i++;
		str++;
	}
	printf( "put words complete!\n\r");
}
extern char fruit_disk;
void putfruit(){
	fruit_disk = rdtsc_ax()%2+1;
	printf( "put fruit complete! fruit is ");
	printToscn( fruit_disk + 48);
	printToscn( '\r');
	printToscn( '\n');
}

#endif




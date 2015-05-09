__asm__(".code16gcc");


extern void screen_init();
extern void printToscn( char); 

extern char input_char();  //return type char
extern char gets();  //return type char
extern unsigned short int get_pointer_pos();
extern screen_sc_T;
extern strcmp( char*, char*);
extern void ifscroll();
extern char strpos( char*, char);

extern char flag_len;
extern unsigned short int atoi( char *);
extern char * itoa( short int ); 

char key_python[20];
char input_1[10];
char input_2[10];
char negative_flag;  //if positive
void python(){
	key_python[0]='\0';

	while( 1){
		if_screen_scroll(); //bottom of screen	
		flag_scroll();
		set_pointer_pos();
		print_str(" >>> ", 5);
		screen_sc_T = 2;
		flag_len=6;
		gets( key_python);
		if( strcmp( key_python, "exit\0")){	//export
			break;
		}
		char i=0;
		char flag=0;

		flag_scroll();
		set_pointer_pos();

		while( key_python[i]!='\0'){
			if( (key_python[i]<'0'|| key_python[i]>'9')&& key_python[i] != '+'&& key_python[i] != '-'){
				flag = 0;
				break;
			}
			if(key_python[i] == '+' || key_python[i] == '-'){
				flag = i;
			}
			i++;
		}
		char len = i;
		if(flag == 0){
			char *p = " Input format error";
			print_str( p, strlen( p));
			continue;
		}
		i=0;
		while(i<flag){
			input_1[i] = key_python[i];
			i++;
		}
		input_1[i] = '\0';
		i = flag+1;
		char j=0;
		while( i<len){
			input_2[j] = key_python[i];
			i++;
			j++;
		}
		input_2[j] = '\0';
		short int a = atoi( input_1);
		short int b = atoi( input_2);
		if( key_python[ flag]=='+'){
			a+=b;
		}
		negative_flag=0;
		if( key_python[ flag]=='-'){
			a-=b;
			if(a<0) {
				negative_flag = 1;
				a=-a;
			}
		}
		char *str = itoa( a);
		if( a == 0){
			str[0]='0';
			str[1]='\0';
		}
		printToscn( ' ');
		if( negative_flag)
			printToscn( '-');
		print_str( str ,strlen( str));
	}
//	int len = 
	flag_scroll();
	set_pointer_pos();
}



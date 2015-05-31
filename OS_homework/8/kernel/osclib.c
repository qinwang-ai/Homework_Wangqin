__asm__(".code16gcc");
extern void printToscn( char);
extern void init_flag_position();
extern void flag_scroll();
extern void set_pointer_pos();
extern void clear();
extern void flag_scroll_up();
extern void load_user( char, unsigned short int );
extern void run_user(); 
extern void init_ss();
extern char screen_sc_T; 
extern char flag_len; 
extern char * key; 
extern void Schedule();

//ing
char * itoa( short int);



//---------------------------------------------------
char ans[20];
char * strcpy( char *p, char src,char len){
	char i =1;
	p+=src;
	while(*p!='\0'&&i<=len){
		ans[ i-1]	= *p;
		i++;
		p++;
	}	
	return ans;
}

void if_screen_scroll(){
	unsigned short int now_row = get_pointer_pos()/256;
	__asm__("pop %si");
	if( now_row >23){			// 0~24   24 is deeplist line
		while( screen_sc_T--){
			scroll_screen();
			__asm__("pop %si");
			flag_scroll_up();
			__asm__("pop %si");
		}
	}
}

char strpos( char*p, const char dst){
	char i=0;
	while(*p!='\0'){
		if(*p==' '){
			return i;
		}
		p++;
		i++;
	}
	return '\0';
}


char strcmp( char *a, const char *b){
	while( (*a!='\0')&& (*b!='\0')&& (*b==*a)){
		b++;
		a++;
	}
	if( *a==*b){
		return 1;
	}else{
		return 0;
	}
}

char synCheck( char * str, const char * dst){		//str is key
//	char *str="adsa ";
	char pos = strpos( str, ' ');		//pos is ' ' position
	if(pos == '\0'){
		return 0;
	}

	char *prompt = strcpy( str, 0, pos );	//pos is times
//	print_str( prompt, 3);					//for debug
	if( !strcmp( prompt, dst)){
		return 0;	
	}

	if( strcmp( prompt, "asc")){		//check asc
		if ( str[5] != '\0'){
			return 0;	
		}
	}
	
	return 1;
}

extern char Usr_num;
void run_error(){
	flag_scroll();
	__asm__("pop %si");
	set_pointer_pos();
	__asm__("pop %si");
	screen_sc_T = 2;
	char *p = " Run error.Note: each num should be 0<x<";
	print_str( p, strlen( p));
	printToscn( Usr_num);
}


//-------------------------------atoi

unsigned short int atoi( char * str_atoi){
	char i_syscall=0;
	short int sum_syscall_ai=0;
	
	while( str_atoi[i_syscall]!='\0'){
		sum_syscall_ai *= 10;
		sum_syscall_ai += (str_atoi[ i_syscall] - '0');
		i_syscall++;
	}
	return sum_syscall_ai;
}



//-------------------------------itoa
//itoa function in osclib_share.c


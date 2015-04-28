__asm__(".code16gcc");
extern void printToscn( char);
extern void init_flag_position();
extern void flag_scroll();
extern void set_pointer_pos();
extern void clear();
extern void flag_scroll_up();
extern unsigned short int get_time();		//h+m
extern unsigned short int get_second();

extern unsigned short int get_year();		
extern unsigned short int get_date();		//m+d
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



void time(){
	unsigned short int now_row = get_pointer_pos()/256;
	/*
	if( now_row>21){			// 0~24   24 is deeplist line
		clear();
	}else{
		flag_scroll();
	}
	set_pointer_pos();
	*/
	
	flag_scroll();
	__asm__("pop %si");
	set_pointer_pos();
	__asm__("pop %si");
	screen_sc_T = 2;

	unsigned short int h_m,second;
    char h, m, sec, ds;
	h_m = get_time();
	__asm__("pop %si");
	second = get_second();
	__asm__("pop %si");

    h = (h_m & 0xff00) >> 8;
    m = h_m & 0xff;
    sec = (second & 0xff00) >> 8;

    print_str(" Now time is: ", 15);
    printToscn(((h & 0xf0) >> 4) + '0');
	__asm__("pop %si");
    printToscn((h & 0xf) + '0');
	__asm__("pop %si");
    printToscn(':');
	__asm__("pop %si");
    printToscn(((m & 0xf0) >> 4) + '0');
	__asm__("pop %si");
    printToscn((m & 0xf) + '0');
	__asm__("pop %si");
    printToscn(':');
	__asm__("pop %si");
    printToscn(((sec & 0xf0) >> 4) + '0');
	__asm__("pop %si");
    printToscn((sec & 0xf) + '0');
	__asm__("pop %si");
}

void date(){
	/*
	unsigned short int now_row = get_pointer_pos()/256;
	if( now_row>21){			// 0~24   24 is deeplist line
		clear();
	}else{
		flag_scroll();
	}
	*/
	flag_scroll();
	__asm__("pop %si");
	set_pointer_pos();
	__asm__("pop %si");
	screen_sc_T = 2;


	unsigned short int year,m_d;
	year = get_year();
	__asm__("pop %si");
	m_d = get_date();
	__asm__("pop %si");

    print_str(" Now Date is: ", 15);
   	printToscn(((year & 0xf000) >> 12) + '0');
	__asm__("pop %si");
	printToscn(((year & 0xf00) >> 8) + '0');
	__asm__("pop %si");
	printToscn(((year & 0xf0) >> 4) + '0');
	__asm__("pop %si");
	printToscn((year & 0xf) + '0');
	__asm__("pop %si");
	printToscn(' ');
	__asm__("pop %si");
	printToscn(((m_d & 0xf000) >> 12) + '0');
	__asm__("pop %si");
	printToscn(((m_d & 0xf00) >> 8) + '0');
	__asm__("pop %si");
	printToscn('-');
	__asm__("pop %si");
	printToscn(((m_d & 0xf0) >> 4) + '0');
	__asm__("pop %si");
	printToscn((m_d & 0xf) + '0');
	__asm__("pop %si");
	
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

	if( strcmp( prompt, "man")){				//check man
		if( !strcmp( str, "man clear\0")&&
			!strcmp( str, "man date\0")&&
			!strcmp( str, "man time\0")&&
			!strcmp( str, "man asc\0")&&
			!strcmp( str, "man help\0")&&
			!strcmp( str, "man syscall\0")&&
			!strcmp( str, "man python\0")&&
			!strcmp( str, "man start\0")&&
			!strcmp( str, "man run\0")){
			return 0;
		}
	}

	if( strcmp( prompt, "int")){				//check man
		if( !strcmp( str, "int 33h\0")&&
			!strcmp( str, "int 34h\0")&&
			!strcmp( str, "int 35h\0")&&
			!strcmp( str, "int 36h\0")
			){
			return 0;
		}
	}

	if( strcmp( prompt, "syscall")){				//check man
		if( '0'>str[ 8] || str[ 8]>'5'){	
			flag_scroll();
	__asm__("pop %si");
			set_pointer_pos();
	__asm__("pop %si");
			screen_sc_T = 2;
			char *p = " Run error.Note: ah should be -1<x<6";
			print_str( p, strlen( p));
			return 1;		//don't display no such file or 
		}
	}

	return 1;
}




void asc( char *str){
	flag_scroll();
	__asm__("pop %si");
	set_pointer_pos();
	__asm__("pop %si");
	screen_sc_T = 2;
	unsigned int short ascii = str[4] - 'A' + 65;
	char *ascii_str = itoa( ascii);
	printToscn(' ');
	__asm__("pop %si");
	print_str( ascii_str, strlen( ascii_str));
}

void man( char *str){
	flag_scroll();
	__asm__("pop %si");
	set_pointer_pos();
	__asm__("pop %si");
	screen_sc_T = 2;

	if( strcmp( str, "man clear\0")){
		char *p = " NAME clear - clear the terminal screen\0";
		print_str( p, strlen( p));
		return;
	}
	if( strcmp( str, "man run\0")){
		char *p = " NAME run - [run squence] run user's program accord squence Ex: run 123\0";
		print_str( p, strlen( p));
		return;
	}
	if( strcmp( str, "man asc\0")){
		char *p = " NAME asc - [asc char] return the ascii of char\0";
		print_str( p, strlen( p));
		return;
	}
	if( strcmp( str, "man date\0")){
		char *p = " NAME date - return the today's date\0";
		print_str( p, strlen( p));
		return;
	}
	if( strcmp( str, "man time\0")){
		char *p = " NAME time - return the now time\0";
		print_str( p, strlen( p));
		return;
	}
	if( strcmp( str, "man help\0")){
		char *p = " NAME help - display help message\0";
		print_str( p, strlen( p));
		return;
	}
	if( strcmp( str, "man syscall\0")){
		char *p = " NAME syscall - to test syscall.Type <syscall num> to test. -1<num<6\0";
		print_str( p, strlen( p));
		return;
	}
	if( strcmp( str, "man python\0")){
		char *p = " NAME python - a math CLI tool.Only support +,- Operation Ex:12-1\0";
		print_str( p, strlen( p));
		return;
	}

	if( strcmp( str, "man start\0")){
		char *p = " NAME start - Create all processes and start process scheduling\0";
		print_str( p, strlen( p));
		return;
	}

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

char *atoi_temp;
unsigned short int atoi_ans;
unsigned short int atoi( char * str){
	atoi_temp = str;
	__asm__("mov $3,%ah");  //123
	__asm__("int $0x80");
	return atoi_ans;
}

char *str_atoi;
char i_syscall;
unsigned short int sum_syscall_ai;
void atoi_syscall(){

	i_syscall=0;
	sum_syscall_ai=0;
	str_atoi=atoi_temp;
	
	while( str_atoi[i_syscall]!='\0'){
		sum_syscall_ai *= 10;
		sum_syscall_ai += (str_atoi[ i_syscall] - '0');
		i_syscall++;
	}
	atoi_ans = sum_syscall_ai;
	__asm__("pop %ax");
	__asm__("pop %ax");
	__asm__("pop %ax");
	__asm__("jmp *%ax");
}

//---------------------------------


//-------------------------------itoa

unsigned short int itoa_temp;
char * itoa_ans;
char * itoa( short int x){
	itoa_temp = x;
	__asm__("mov $4,%ah");  //123
	__asm__("push %bp");
	__asm__("int $0x80");
	__asm__("pop %bp");
	return itoa_ans;
}

int i,j; 
char str[10];
short int value;
void itoa_syscall()
{
	for(i=0;i<10;i++){
		str[i]='\0';
	}
	value = itoa_temp;
	if (value < 0) //如果是负数,则str[0]='-',并把value取反(变成正整数)
	{
		str[0] = '-';
		value = 0-value;
	}
	for(i=1; value > 0; i++,value/=10) //从value[1]开始存放value的数字字符，不过是逆序，等下再反序过来
	  str[i] = value%10+'0'; //将数字加上0的ASCII值(即'0')就得到该数字的ASCII值

	for(j=i-1,i=1; j-i>=1; j--,i++) //将数字字符反序存放
	{
		str[i] = str[i]^str[j];
		str[j] = str[i]^str[j];
		str[i] = str[i]^str[j];
	}

	if(str[0] != '-') //如果不是负数，则需要把数字字符下标左移一位，即减1
	{
		for(i=0; str[i+1]!='\0'; i++)
		  str[i] = str[i+1];
		str[i] = '\0';
	}

	itoa_ans = str;


	__asm__("mov %sp,%bp");
	__asm__("pop %eax");
	__asm__("pop %ax");
	__asm__("pop %ax");
	__asm__("pop %ax");
	__asm__("jmp *%ax");
}


void syscall_test(){
	switch( key [8]){
		case '0':{
			__asm__("mov $0,%ah");  //012
			__asm__("int $0x80");
			break;
		}
		case '1':{
			__asm__("mov $0xb800,%ax");
			__asm__("mov %ax,%es");
			__asm__("mov $542,%dx");	// 542 548 576
			__asm__("mov $1,%ah");  //123
			__asm__("int $0x80");
			break;
		}
		case '2':{
			__asm__("mov $0xb800,%ax");
			__asm__("mov %ax,%es");
			__asm__("mov $548,%dx");	// 542 548 576
			__asm__("mov $2,%ah");  //123
			__asm__("int $0x80");
			break;
		}

		default:return;
	}
}



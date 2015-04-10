__asm__(".code16gcc");
extern void printToscn( char);
extern void screen_init();
extern void init_flag_position();
extern void flag_scroll();
extern void set_pointer_pos();
extern void clear();
extern void flag_scroll_up();
extern unsigned short int get_time();		//h+m
extern unsigned short int get_second();

extern unsigned short int get_year();		
extern unsigned short int get_date();		//m+d
extern void load_user( unsigned short int); 
extern void run_user(); 

extern char screen_sc_T; 



//shegnming



//---------------------------------------------------
char ans[20];
inline char * strcpy( char *p, char src,char len){
	char i =1;
	p+=src;
	while(*p!='\0'&&i<=len){
		ans[ i-1]	= *p;
		i++;
		p++;
	}	
	return ans;
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
char strlen( char*p){
	char i=0;
	while(*p!='\0'){
		p++;
		i++;
	}
	return i;
}

inline void print_str( const char *p , unsigned short int l){
	while(l>0){
		printToscn( *p);
		p++;
		l--;
	}
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

char str[10];
char* itoa(	unsigned short int value)
{
	if (value < 0) //如果是负数,则str[0]='-',并把value取反(变成正整数)

	{
		str[0] = '-';
		value = 0-value;
	}
	int i,j;
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
	return str;
}



inline void time(){
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
	set_pointer_pos();
	screen_sc_T = 2;

	unsigned short int h_m,second;
    char h, m, sec, ds;
	h_m = get_time();
	second = get_second();

    h = (h_m & 0xff00) >> 8;
    m = h_m & 0xff;
    sec = (second & 0xff00) >> 8;

    print_str(" Now time is: ", 15);
    printToscn(((h & 0xf0) >> 4) + '0');
    printToscn((h & 0xf) + '0');
    printToscn(':');
    printToscn(((m & 0xf0) >> 4) + '0');
    printToscn((m & 0xf) + '0');
    printToscn(':');
    printToscn(((sec & 0xf0) >> 4) + '0');
    printToscn((sec & 0xf) + '0');
}

inline void date(){
	/*
	unsigned short int now_row = get_pointer_pos()/256;
	if( now_row>21){			// 0~24   24 is deeplist line
		clear();
	}else{
		flag_scroll();
	}
	*/
	flag_scroll();
	set_pointer_pos();
	screen_sc_T = 2;


	unsigned short int year,m_d;
	year = get_year();
	m_d = get_date();

    print_str(" Now Date is: ", 15);
   	printToscn(((year & 0xf000) >> 12) + '0');
	printToscn(((year & 0xf00) >> 8) + '0');
	printToscn(((year & 0xf0) >> 4) + '0');
	printToscn((year & 0xf) + '0');
	printToscn(' ');
	printToscn(((m_d & 0xf000) >> 12) + '0');
	printToscn(((m_d & 0xf00) >> 8) + '0');
	printToscn('-');
	printToscn(((m_d & 0xf0) >> 4) + '0');
	printToscn((m_d & 0xf) + '0');
	
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
			!strcmp( str, "man run\0")){
			return 0;
		}
	}

	return 1;
}








void asc( char *str){
	flag_scroll();
	set_pointer_pos();
	screen_sc_T = 2;
	unsigned int short ascii = str[4] - 'A' + 65;
	char *ascii_str = itoa( ascii);
	printToscn(' ');
	print_str( ascii_str, strlen( ascii_str));
}

void man( char *str){
	flag_scroll();
	set_pointer_pos();
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
}

void run_error(){
	flag_scroll();
	set_pointer_pos();
	screen_sc_T = 2;
	char *p = " Run error.Note: each num should be 0<x<4";
	print_str( p, strlen( p));
}
void run( char *str){
	str += 4;
	
	while( *str != '\0'){
		if('0'<*str && *str<'4'){
			load_user( *str-'0'+15);	//in oslib.asm	
			run_user();
			init_flag_position();	
			screen_init();
			print_welcome_msg();
			print_message();
			print_flag(); //root@wangqin4377@:   position

			}else{
				run_error();
			}
		str++;
	}
}




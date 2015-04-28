__asm__(".code16gcc");
extern void printToscn( char);
extern void screen_init();
extern char flag_len;
extern unsigned short int get_pointer_pos();


char strlen( char*);
char gets( char *);
unsigned short int atoi( char * );
char * itoa_without_sys( int );
void print_str( const char * , unsigned short int );
void putch( char );
//----------------shengming  end

//------------------------------lab 5--------------
void getch( char* ch){
	char chtemp = '0';
	while (chtemp!=0x0d){
		*ch=chtemp;
		chtemp = input_char();
		if(chtemp!=0x0d)
			putch( chtemp);
		else{
			putch('\r');
			putch('\n');
		}
	}
	//printToscn( ch);
}


void puts(char *key){
	print_str( key ,strlen( key));	
}

void putch( char ch){
	printToscn( ch);
}

char scanftmp[5];
void scanf( char * str, int *a){
	char len=strlen( str);
	str[ len-2]='\0';
	puts( str);
	gets( scanftmp);
	putch('\r');
	putch('\n');

	char i=0;
	int sum=0;
	while( scanftmp[i]!='\0'){
		sum *= 10;
		sum += (scanftmp[ i] - '0');
		i++;
	}
	*a=sum;
}
void printint( char * str, char ch,int a,char* str1){
	char i=0;
	while(str[i]!='\0'){
		if(str[i]=='%'){
			i++;
			if(str[i]=='c'){
				putch(ch);
			}
			if(str[i]=='d'){
				puts( itoa_without_sys( a));
			}
			if(str[i]=='s'){
				puts( str1);
			}
		}else{
			putch( str[i]);
		}
		i++;
	}
}
wait_key(){
	puts("\r\n\r\n  press any key to exit...");
	char a=input_char();
}

char gets( char *key){

	char temp;
	char i=0;
	while( ( temp=input_char())!=0x0d ){
			if( temp == '\b'){				// delete a word
				unsigned short int now_pos = get_pointer_pos();
				if( (now_pos&0x00ff) < flag_len){	//dont delete flag
					continue;
				}
				printToscn('\b');
				printToscn(' ');
				printToscn('\b');
				i--;
				continue;
			}
			key[i] = temp;	
			if(i<63)i++;
			printToscn( temp);
	}
	key[i] = '\0';
	return i;
}

void print_str( const char *p , unsigned short int l){
	while(l>0){
		printToscn( *p);
		p++;
		l--;
	}
}



//--------------------------------lab5 end------
int i,j; 
char str[10];
int value;

char * itoa_without_sys( int value)
{	
	for(i=0;i<10;i++){
		str[i]='\0';
	}

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

	return str;
}

char strlen( char*p){
	char i=0;
	while(*p!='\0'){
		p++;
		i++;
	}
	return i;
}




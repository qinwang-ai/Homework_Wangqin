__asm__(".code16gcc");
extern void printToscn( char);
extern void screen_init();
extern char flag_len;
extern unsigned short int get_pointer_pos();


char strlen( char*);
void print_str( const char * , unsigned short int );
//----------------shengming  end

char str[10];
char * itoa( short int value){
	int i,j; 
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

char strlen( char*p){
	char i=0;
	while(*p!='\0'){
		p++;
		i++;
	}
	return i;
}





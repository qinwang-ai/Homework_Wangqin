#ifndef _OS_H
#define _OS_H
__asm__(".code16gcc");

extern void interrupt_init();
extern void syscall_init();
extern void print_message();
extern void print_welcome_msg();
extern char listen_key();
extern void print_flag();
extern void loader_user( char , unsigned short int);

extern char Print_flag_mark;
//extern fcb *FCB_array;

#endif

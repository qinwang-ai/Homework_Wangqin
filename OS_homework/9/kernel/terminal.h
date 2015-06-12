#ifndef _TERMINAL_H
#define _TERMINAL_H

__asm__(".code16gcc");

extern char gets( char *);
extern char strcmp( char *, const char *);
extern void clear();
extern void run( char *);

extern void syscall_test();
extern void Process();

extern void flag_scroll();
extern void set_pointer_pos();
extern void clear();
extern void init_flag_position();
extern void printToscn( char);
extern void print_message();
extern void print_welcome_msg();

#endif

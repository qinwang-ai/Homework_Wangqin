__asm__(".code16gcc");
__asm__("pushw %ds;");                                                 
__asm__("pushw %es;");
__asm__("mov %cs, %ax\n");
__asm__("mov %ax, %ds\n");
__asm__("mov %ax, %es\n");
__asm__("call main\n");
__asm__("popw %es;");
__asm__("popw %ds;");
__asm__("retw\n");


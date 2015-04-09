#ld -o test test.o -arch i386 -lc -macosx_version_min 10.6
from os import *
asm_file = "test"
c_file = "test"
out_type = "r"

system( "gcc -c %s.c -m32 -o %sc.o"%(c_file,c_file))
system( "nasm -f macho %s.asm"%asm_file)
system( "ld -o %s %s.o %sc.o -arch i386 -lc -macosx_version_min 10.6 -%s"%( asm_file, asm_file, c_file, out_type))
system("echo '%s created successful!'"%asm_file);





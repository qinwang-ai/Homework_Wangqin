LD_flags=-m elf_i386
C_flags=-m32 -mpreferred-stack-boundary=2 -ffreestanding

disk.img: boot.bin os.bin process1.com process2.com process3.com process4.com process_wait_key.com usr1.com usr2.com
	dd if=/dev/zero of=disk.img count=2880 bs=512
	dd if=boot.bin of=disk.img
	dd if=os.bin of=disk.img seek=1
#	dd if=usr1.com of=disk.img seek=1
	dd if=process1.com of=disk.img bs=512 seek=36
	dd if=process2.com of=disk.img bs=512 seek=72 
	dd if=process3.com of=disk.img bs=512 seek=108
	dd if=process4.com of=disk.img bs=512 seek=144
	dd if=process_wait_key.com of=disk.img bs=512 seek=180
	dd if=usr1.com of=disk.img bs=512 seek=216
	dd if=usr2.com of=disk.img bs=512 seek=252

boot.bin: boot.asm 
	nasm -f bin boot.asm -o boot.bin

os.bin: os.o osc.o oslib.o  osclib.o os_syscall.o python.o oslib_share.o osclib_share.o terminal.o process.o
	ld $(LD_flags) -Ttext 0x7e00 --oformat binary $^ -o $@ -e main

os.o: kernel/os.asm
	nasm -f elf $^ -o $@

oslib.o: kernel/oslib.asm
	nasm -f elf $^ -o $@

oslib_share.o: oslib_share.asm
	nasm -f elf $^ -o $@

os_syscall.o: kernel/os_syscall.asm
	nasm -f elf $^ -o $@

osc.o: kernel/os.c
	gcc $(C_flags) -c $^ -o $@

terminal.o: kernel/terminal.c
	gcc $(C_flags) -c $^ -o $@

process.o: kernel/process.c
	gcc $(C_flags) -c $^ -o $@

python.o: python_extension.c 
	gcc $(C_flags) -c $^ -o $@

osclib.o: kernel/osclib.c
	gcc $(C_flags) -c $^ -o $@

osclib_share.o: osclib_share.c
	gcc $(C_flags) -c $^ -o $@

process1.com:process1.asm 
	nasm -f bin $^ -o $@

process2.com:process2.asm 
	nasm -f bin $^ -o $@

process3.com:process3.asm 
	nasm -f bin $^ -o $@

process4.com:process4.asm 
	nasm -f bin $^ -o $@

process_wait_key.com:process_wait_key.asm 
	nasm -f bin $^ -o $@

usr1.com:usr1.asm 
	nasm -f bin $^ -o $@

usr2.com:usr2.asm 
	nasm -f bin $^ -o $@

clean:
	rm *.o *.bin *.com





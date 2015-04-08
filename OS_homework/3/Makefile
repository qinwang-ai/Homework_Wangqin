LD_flags=-m elf_i386
C_flags=-m32 -mpreferred-stack-boundary=2 -ffreestanding

disk.img: boot.bin os.bin usr1.com usr2.com usr3.com
	dd if=/dev/zero of=disk.img count=2880 bs=512
	dd if=boot.bin of=disk.img
	dd if=os.bin of=disk.img seek=1
	dd if=usr1.com of=disk.img bs=512 seek=15
	dd if=usr2.com of=disk.img bs=512 seek=16
	dd if=usr3.com of=disk.img bs=512 seek=17

boot.bin: boot.asm 
	nasm -f bin boot.asm -o boot.bin

os.bin: os.o osc.o oslib.o  osclib.o
	ld $(LD_flags) -Ttext 0x7e00 --oformat binary $^ -o $@ -e main

os.o: os.asm
	nasm -f elf $^ -o $@

oslib.o: oslib.asm
	nasm -f elf $^ -o $@

osc.o: os.c
	gcc $(C_flags) -c $^ -o $@

osclib.o: osclib.c
	gcc $(C_flags) -c $^ -o $@

usr1.com:usr1.asm 
	nasm -f bin $^ -o $@

usr2.com:usr2.asm 
	nasm -f bin $^ -o $@

usr3.com:usr3.asm 
	nasm -f bin $^ -o $@

clean:
	rm *.o *.bin *.com





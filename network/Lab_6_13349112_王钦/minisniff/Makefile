CC= gcc
CFLAGS= -g -Wall -DDEBUG
INCLUDES= -I. -I/usr/include/pcap/ #make sure you got the right path of pcap.h on your machine
LIBS= -lpcap #again, this is usually -lpcap unless you installed it under different name
#if the linker gives an error (or a whole bunch of them) then you probably
#don't have libpcap.so to fix the problem make the above line
#LIBS= /usr/lib/libpcap.a instead

OBJS= buffer.o capture.o
EXEC= minisniff

all: buffer.o capture.o main.c Makefile
	$(CC) $(CFLAGS) $(INCLUDES) main.c $(OBJS) $(LIBS) -o $(EXEC)

buffer.o: buffer.h buffer.c Makefile
	$(CC) $(CFLAGS) $(INCLUDES) -c buffer.c

capture.o: capture.c capture.h Makefile
	$(CC) $(CFLAGS) $(INCLUDES) -c capture.c
	
clean:
	rm -rf *.o *~ $(EXEC) core

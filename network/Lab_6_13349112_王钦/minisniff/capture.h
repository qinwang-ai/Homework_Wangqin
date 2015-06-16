#ifndef __CAPTURE_H
#define __CAPTURE_H

#include <pcap.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netinet/if_ether.h>
#include <netinet/ip.h>
#include <time.h>

#include <buffer.h>


/* callback foo for the capture library */
void pcap_callback(u_char *, const struct pcap_pkthdr *, const u_char *);

#endif


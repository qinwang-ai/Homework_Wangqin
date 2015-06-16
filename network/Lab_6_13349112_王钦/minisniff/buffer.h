#ifndef __BUFFER_H
#define __BUFFER_H

#include <string.h>
#include <pcap.h>
#include <stdlib.h>

#define DEFAULT_CAPACITY 65536
#define GARBAGE_SIZE (DEFAULT_CAPACITY/2)

/* an item in buffer contains packet header
 * and the full packet with additional info
 */
typedef struct  __item{

  struct pcap_pkthdr* packet_header;
  u_char* full_packet;  
  short int garbage; /* marked for collection */
  struct __item* prev; /* item in front */
  struct __item* next; /* next item */

}item;

/* buffer contains a doubly-linked list of items
 * and additional info
 */
typedef struct __buffer{

  long long int items; /* number of items currently in the list */
  long long int capacity; /* maximum capacity */
  long long int garbage_size; /* collect garbage when we hit this limit */

  item* header; /* head of the list */
  item* tail; /* tail of the list */

}buffer;

/* initialize the buffer */
int create_buffer(buffer*, long long int, long long int);

/* insert an item into the buffer */
int append_item(buffer*, const struct pcap_pkthdr*, const u_char*);

/* run garbage collection returns freed items */
int gc(buffer*);

#endif

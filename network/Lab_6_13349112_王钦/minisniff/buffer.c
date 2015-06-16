#include <buffer.h>
/* this file has nothing to do with pcap and sniffing so you can skip reading this
 * so not a lot of comments here, most things are straight forward. this basically
 * implements a very simple memory buffer to store all the packets we collect.
 */


/* do some sanity checks and initialize the buffer */
int create_buffer(buffer* buf, long long int capacity, long long garbage){

  if(buf == NULL) return -1;
  
  buf->items=0;
  buf->garbage_size= (garbage<=0)?GARBAGE_SIZE:garbage;
  buf->capacity= (capacity<=0)?DEFAULT_CAPACITY:capacity;
  buf->header=NULL;
  buf->tail=NULL;

  return 0; 
}

/* append the packet to the buffer avoid sanity checks, we want to be done quickly here */
int append_item(buffer* buf, const struct pcap_pkthdr* packet_header, const u_char* full_packet){

  item* tmp;

#ifdef DEBUG
  /* if already full run garbage collector and see */
  if(buf->items >= buf->capacity){
    gc(buf);
    if(buf->items >= buf->capacity)
      return -1;
  }
#endif

  /* first item */
  if(buf->items==0){
    /* allocate space for new item */
    if((tmp= (item *)malloc(sizeof(item)))==NULL){
      fprintf(stderr, "could not allocate memory for an item\n");
      exit(-1);
    }

    /* allocate space for packet header and set it */
    if((tmp->packet_header= (struct pcap_pkthdr *) malloc(sizeof(struct pcap_pkthdr)))==NULL){
      fprintf(stderr, "could not allocate memory for packet header\n");
      exit(-1); 
    }
    memcpy(tmp->packet_header, packet_header, sizeof(struct pcap_pkthdr));

    /* allocate space for full packet and set it */
    if((tmp->full_packet= (u_char *)malloc((packet_header->caplen)))==NULL){
      fprintf(stderr, "could not allocate memory for full packet\n");
      exit(-1);
    }
    memcpy(tmp->full_packet, full_packet, packet_header->caplen);
  
    tmp->garbage=0;
    tmp->next=NULL;
    tmp->prev=NULL;

    /* set header etc. properly */
    buf->header= tmp;
    buf->tail= tmp;
    buf->items++;
  }else{
    /* has one or more items */
    if((tmp= (item *)malloc(sizeof(item)))==NULL){
      fprintf(stderr, "could not allocate memory for an item\n");
      exit(-1);
    }

    /* allocate space for packet header */
    if((tmp->packet_header= (struct pcap_pkthdr *) malloc(sizeof(struct pcap_pkthdr)))==NULL){
      fprintf(stderr, "could not allocate memory for packet header\n");
      exit(-1);
    }
    memcpy(tmp->packet_header, packet_header, sizeof(struct pcap_pkthdr));

    /* allocate space for full packet */
    if((tmp->full_packet= (u_char *)malloc(packet_header->caplen))==NULL){
      fprintf(stderr, "could not allocate memory for full packet\n");
      exit(-1);
    }
    memcpy(tmp->full_packet, full_packet, packet_header->caplen);

    tmp->garbage=0;

    /* set header etc. properly */
    /* for the new node, next is current header
     * prev is NULL
     */
    tmp->next= buf->header;
    tmp->prev= NULL;

    /* for the current header,
     * prev is new node
     */
    (buf->header)->prev= tmp;

    /* header is new node */
    buf->header= tmp;
    buf->items++;
  }

  /* signal the garbage collector here */
  gc(buf);

#ifdef DEBUG
  fprintf(stderr, ".");
#endif

  return 0;
}

/* a stupid mark and sweep approach */
int gc(buffer* buf){

  item* tail;
  item* tmp;
  long long int i;
  long long int half_i;
  long long int removed=0;

  /* start collection only if more than GARBAGE_SIZE items present in the buffer */
  if(buf->items <= buf->garbage_size) return 0;

  /* sweep half the buffer (minus the first two elements)
   * from tail and delete them if they are ready for collection
   */
  tail= buf->tail;
  half_i= buf->items/2;
  i=0;


  /* do a simple sweep from behind and remove items marked for collection */

  /* case 1: remove all tail items that are marked for deletion 
   * most likely all the items in the back of the buffer are marked
   * for collection, so from tail we expect a long continous list
   * available for collection. let us cycle thru them first
   */
  while((i < half_i) && (tail->garbage)){
    tail= tail->prev;/* move one ahead */
    free(tail->next);/* free the follower */
    tail->next=NULL; /* follower is NULL */

    /* update the items at the end, so that apend
     * doesn't need to wait very often for the lock]
     */
    /* buf->items--;*/ /* one less item */
    ++removed;
    ++i;
  }
  buf->items -= removed;
  
  /* case 2: we would get out of the above loop when either all garbage
   * is collected (i >= half_i) or there was an item found that's not 
   * ready for collection. in this case we may end up removing stuff from
   * the middle of the buffer. so lets do that next.
   */

  /* Houston we have a problem! we are running out of battery power!*/

  removed=0;
  /* get in here only if we need to remove something in the middle */
  while((i < half_i)&&(tail!=NULL)){
    
    /* in the middle */
    if(tail->garbage){
      (tail->prev)->next= tail->next;
      (tail->next)->prev= tail->prev;/* expect a bark for last item */
      tmp= tail;
      tail= tail->prev;
      free(tmp);

      /* update the items at the end so that append doesn't have to
       * wait for lock very often
       */
      /* buf->items--;*/ /* one less item */
      ++i;
    }else{
      tail= tail->prev;
      ++i;
    }
  }
  buf->items-=removed;
  
  return 0;
}

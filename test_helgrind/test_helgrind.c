#include <pthread.h> 
int var = 0; 
void* child_fn ( void* arg ) { var++;
 return NULL; 
}

 int main ( void ) { 
pthread_t child;
 pthread_create(&child,NULL, child_fn, NULL); 
var++;  pthread_join(child, NULL); return 0;
 }


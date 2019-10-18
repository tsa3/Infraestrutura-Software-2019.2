#include <pthread.h>
#include <stdio.h>
long long count = 0;
pthread_mutex_t mymutex = PTHREAD_MUTEX_INITIALIZER;

void *inc(void *threadid){
    int i;
    for(int i=0; i<1000000;i++){
    pthread_mutex_lock(&mymutex);
    if(count==1000000){
        count = 1000000;
    }
    else{
        count++;
    }
    pthread_mutex_unlock(&mymutex);
    }
}

int main(int argc, char *argv[]){
    pthread_t thread1, thread2;
    pthread_create(&thread1, NULL, inc, NULL);
    pthread_create(&thread2, NULL, inc, NULL);
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    if(count == 1000000){
    printf("O valor %lld foi alcancado\n", count);
    printf("a Execucao terminou\n");
    }
    pthread_exit(NULL);
    return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h> 
#include <stdbool.h>
#define BUFFER_SIZE 10
#define NUM_ITEMS 200

typedef struct parameters{
    int id;
    bool status = false;
}parameters;

int buff[BUFFER_SIZE];  /* buffer size = 10; */
int itens = 0; // number of items in the buffer.
int first = 0;
int last = 0; 
parameters execs[BUFFER_SIZE];

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t empty = PTHREAD_COND_INITIALIZER;
pthread_cond_t fill = PTHREAD_COND_INITIALIZER;
 
void *producer();
void *consumer();
int agendarexec();


main() {
    pthread_t consumer_thread; 
    pthread_t producer_thread; 
    int escolha;
    int resposta;
    int search;
    pthread_create(&consumer_thread,NULL,consumer,NULL);
    pthread_create(&producer_thread,NULL,producer,NULL);
    pthread_join(producer_thread,NULL);  
    pthread_join(consumer_thread,NULL);
    do{
        printf("O que deseja fazer?\n"); // menu para auxiliar a organizaçao
        printf("1 - Agendar Execucao\n");
        printf("2 - Conferir Status da execucao\n");
        printf("3 - Sair\n");
        scanf("%d", &escolha);
        if(escolha == 1){
           resposta=agendarexec(); //chama a funcao de agendar e recebe o valor da id
           printf("O id para acompanhamento da sua execucao eh %d\n", resposta);
        }
        else if(escolha == 2){
            printf("digite o id da sua execucao\n"); //recebe o valor da id de execuçao e verifica o status da execucao
            scanf("%d", &search);
            if(execs[search].status == false){
                printf("ainda nao processado\n");
            }
            else(printf("processo finalizado\n"));
        }
        else if(escolha == 3){
            break;
        }
    }while(escolha != 3);
}
int agendaexec(){
    execs[itens].status = false; //garante que o status vai estar em false inicialmente
    producer(); //chama a funçao de produtor
    execs[itens].id = itens;
    return execs[itens].id; //retorna o id da execuçao
}

void put(int i){
    pthread_mutex_lock(&mutex);
    while(itens == BUFFER_SIZE) {
        pthread_cond_wait(&empty, &mutex);
    }
    buff[last] = i;
    itens++; 
    last++;
    if(last==BUFFER_SIZE) { 
        last = 0;
    } 
    if(itens == 1) { 
        pthread_cond_signal(&fill); 
    }
    pthread_mutex_unlock(&mutex); 
}
void *producer() {
  int i = 0;
  for(i=0;i<NUM_ITEMS; i++) {
    put(i);
  }
  pthread_exit(NULL);
}

int get(){
  int result;
  pthread_mutex_lock(&mutex);
 while(itens == 0){
    pthread_cond_wait(&fill, &mutex);
  }
  result = buff[first];
  itens--; 
  first++;
  if(first==BUFFER_SIZE) { 
      first = 0; }
  if(itens == BUFFER_SIZE - 1){
    pthread_cond_signal(&empty);}
  pthread_mutex_unlock(&mutex);
  return result;
}
void *consumer() {
  int i,v;
  for (i=0;i<NUM_ITEMS;i++) {
    v = get();
  }
  pthread_exit(NULL);
}

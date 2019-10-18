/*
Nesta questão, o  objetivo  é quebrar a execução seqüencial em threads, na qual o valor de cada incógnita xi  pode ser calculado de forma concorrente em relação às demais incógnitas (Ex: x1(k+1) 
pode ser calculada ao mesmo tempo que x2(k+1)). A quantidade de threads a serem criadas vai depender de um parâmetro N passado pelo usuário durante a execução do programa, e N deverá ser equivalente à quantidade de processadores (ou núcleos) que a máquina possuir.
No início do programa, as N threads deverão ser criadas, I incógnitas igualmente associadas para thread, e nenhuma thread poderá ser instanciada durante a execução do algoritmo. Dependendo do número N de threads, alguma thread poderá ficar com menos incógnitas assoicadas à ela.

Para facilitar a construção do programa e a entrada de dados, as matrizes não precisam ser lidas do teclado, ou seja, podem ser inicializadas diretamente dentro do programa (ex: inicialização estática de vetores). 
Ademais, os valores iniciais de xi(0) deverão ser iguais a 1, e adote um mecanismo (ex: barriers) para sincronizar as threads depois de cada iteração.
Faça a experimentação executando o programa em uma máquina com 4 processadores/núcleos, demostrando a melhoria da execução do  programa com 1, 2 e 4 threads.

ATENÇÃO: apesar de x1(k+1) pode ser calculada ao mesmo tempo que x2(k+1),, xi(k+2)  só poderão ser calculadas quando todas incógnitas xi(k+1) forem calculadas. Barriers são uma excelente ferramenta para essa questão.
*/

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>

#define QTD_VAR 2
#define P 20
#define PALMEIRAS_SEM_MUNDIAL 1
#define FIM -1

// É um sistema de equações lineares no formato Ax = b
// A quantidade de colunas de A deve ser a mesma que a quantidade de linhas de X.

int                 QTD_THREADS;
int                 **BANCO;
double              MATRIZ_A[QTD_VAR][QTD_VAR] = {1,2,3,4,5};   // Variável responsável pela matriz A
double              MATRIZ_B[QTD_VAR] = {5, 9};                 // Variável responsável pela matriz B
double              MATRIZ_X[QTD_VAR][P];                       // Essa aqui é a variável responsável pela matriz X
pthread_barrier_t   Buffon;                                     // Sim, buffon é um muro

void *operation(void *threadid)
{
    int k   = 0;
    int ID  = *(int*)threadid;
    while(k < P)                                                // Algoritmo usado no enunciado da questão, sendo P a quantidade de iterações
    {
        int CNT = 0;
        int MATRIZ_AUX = BANCO[ID][CNT];
        while(PALMEIRAS_SEM_MUNDIAL)
        {
            double E = 0;                                       // E = símbolo de somatório
            int i;
            for(i = 0 ; i < QTD_VAR; i++)
            {
                if(i != MATRIZ_AUX)
                {
                    E += MATRIZ_A[ID_Aux][i]*MATRIZ_X[i][k];
                }
            }
            MATRIZ_X[ID_Aux][k+1] = (1/a[MATRIZ_AUX][MATRIZ_AUX])*(MATRIZ_B[MATRIZ_AUX] - E);   // Novo valor da variável
            CNT++;
            if(CNT > QTD_VAR)                                   // Se quantidade de variáveis já foi atingida, passamos para próxima iteração
            {
                break;
            }
            MATRIZ_AUX = BANCO[ID][CNT];                        // Nova variável
            if(MATRIZ_AUX == FIM)                               // Se o valor da variável for FIM (-1) a operação já terminou e o deve ser calculado o resultado
            {
                break;
            }
        }
        k++;
        pthread_barrier_wait(&Buffon);                          // Esperamos para nivelar todas as threads
    }
}

int main(){
    int i, j, *referencial,aux;
    int count = 0;
    int organizador = 0;
    pthread_t *threads;
    scanf(%d, &QTD_THREADS);

    pthread_barrier_init(&Buffon, NULL,QTD_THREADS);            // Inicialização da barreira
    
    threads = (*threads)malloc(QTD_THREADS*sizeof(pthread_t));
    referencial = (*int)malloc(QTD_THREADS*sizeof(int));

    if(QTD_THREADS > QTD_VAR)                                   // Não podemos ter mais threads que variáveis, então igualamos caso seja maior
    {
        QTD_THREADS = QTD_VAR;
    }
    
    BANCO = (int**) malloc(QTD_VAR * sizeof(int*));             // Alocar o vetor de valores
    
    for(i = 0; i < QTD_THREADS; i++)                            // Aloca cada setor do vetor Bidimensional
    {
        BANCO[i] = (int*)malloc(QTD_VAR*sizeof(int*));
        for(j = 0; j < QTD_VAR; j++)
        {
            BANCO[i][j] = -1;
        }
    }
    for(i = 0; i < QTD_VAR; i++)                                
    {
        count = i%QTD_THREADS;                                  // Dividindo pela quantidade de threads teremos a thread que será responsável por essa variável
        organizador = floor(i/QTD_THREADS);                     // Aqui tentamos dividir pra designar uma segunda dimensão pra matriz, de forma que fique mais organizado
        BANCO[count][organizador] = i;
    }

    for(i = 0; i < QTD_THREADS; i++)
    {
        referencial[i] = i;
        pthread_create(&thread[i], NULL, operation, (*void)referencial[i]);
    }

    for(i = 0; i < QTD_THREADS; i++)
    {                          // Esperando o fim das threads
        printf("Esperando threads...");
        if(i > 0){
            printf("Thread %d pronta." i-1);
        }
        pthread_join(thread[i],NULL);
    }
    
    printf("Ultima thread pronta. Seguindo o programa...\n");
    
    for(i = 0; i < QTD_VAR; i++)
    {
        printf("%lf ", MATRIZ_X[i][P-1]);                       // Printando resposta
    }

    printf("\n");
    pthread_barrier_destroy(&Buffon);                           // Adeus buffon
    pthread_exit(NULL);
    
    free(threads);
    free(referencial);
}
/*
Questão 2:
Para uma nova política de armazenamento de dados, uma empresa solicitou a eliminação de seus usuários considerados inativos do banco de dados de seu sistema.
Para isso, as informações de cada usuário estão inclusas em arquivos de tamanhos indeterminados. 
Faça um programa que receba, respectivamente, um número N de usuários, um número A ≥ 2 de arquivos e um número T ≤ ⌊A/2⌋ de threads para o acesso aos arquivos.
Todos os arquivos devem ser analisados e cada um é nomeado “bancoX.txt”, onde 1 ≤ X ≤ A.

Cada linha do arquivo deverá conter os dados de apenas um usuário, que consiste em, nesta ordem:
nome: Nome do usuário
id: Identificação exclusiva do usuário
ultimo_Acesso: A quantidade de dias no qual o usuário está inativo 
pontuacao: A pontuação de atividade do usuário. 0 ≤pontuacao ≤1
Após a leitura de todos os arquivos e o armazenamento dos dados em arrays, deve-se calcular a média do grau de inatividade do banco, cuja média igual a:

media[i] = (ultimo_acesso[i]/(pontuacao[i]*pontuacao[i])/N);

onde i é um usuário. Com isso, os usuários em que o seu grau de inatividade é, no mínimo, duas vezes maior que a média devem ter os seus dados
apagados de seu respectivo arquivo e os seus nomes impressos no terminal (não precisa ser em uma ordem específica).

Para as leituras e a escrita dos arquivos, é necessário que apenas uma thread acesse um arquivo de cada vez,
com o intuito de garantir a exclusão mútua e a prevenção de deadlocks. Além disso, como o número de threads é fornecido pelo usuário,
não podemos determinar qual thread acessa qual arquivo, assim, o acesso a qualquer arquivo pode ser feito por qualquer thread e,
quando uma thread acabar de acessar um arquivo, se ainda existir algum arquivo não acessado, a thread deve acessar este arquivo. Ademais,
cada usuário aparece pelo menos uma vez em cada arquivo e somente em um arquivo.

*/

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>

#define TRUE 1
#define FALSE 0
#define MAX_ARQUIVOS "8"
#define QTD_USERS "4"

int                 N, A, T;                                                                            //  A = Arquivos, N = Número de usuários, T = Threads    
FILE                *arquivo;
pthread_mutex_t     MEU_MUTEX = PTHREAD_MUTEX_INITIALIZER;                                              // Mutex único
bool                *ALREADY_READ;                                                                      // Pra saber se o arquivo[i] já foi lido ou não.
char                banco[10] = "banco";

typedef struct persona                                                                                  // Estrutura padrão pra cada usuário
{   
    char    NOME[50];
    char    ID[10];    
    int     ULTIMO_ACESSO;
    double  PONTUACAO;
}persona;

persona *DADOS;

void *inc(void *threadid)
{                                                                                                       // Thread geral de leitura de arquivo
    int i = 0;                                      
    int j = 1;                                      
    while(1)
    {
        if(ALREADY_READ[j] == FALSE && j <= A)                                                              // Se arquivo não tiver sido lido ainda
        {
            ALREADY_READ[j] = TRUE;

        }
        else if (j<A) j++;
    }
    
}


int main(){
    
    // Sessão de vetores
    pthread_t   *VETOR_THREADS;
    double      MEDIA_INAT;
    
    // Sessão de contadores
    int         i;
    
    // Começando os trabalhos
    
    
    printf("Colocamos "MAX_ARQUIVOS" arquivos para serem lidos, cada um deles com "QTD_USERS" usuarios distintos, ja que nao foram dadas informacoes sobre isso.\n");
    printf(" O que te da uma quantidade de 8x4 usuarios para serem lidos.\n");
    printf("Digite a quantidade de Usuarios:");
    scanf("%d", &N);
    printf("\n");
    printf("Digite a quantidade de arquivos:");
    scanf("%d", &A);
    printf("\n");

    while(A<2)
    {                                                                                                   //  Tratamento da regra 1 (A >= 2)
        printf("Valor de A deve ser maior ou igual a dois\n");
        scanf("%d", &A);
    }
    scanf("%d", &T);
    while(T > floor(A/2))
    {                                                                                                   // Tratamento da quantidade de Threads
        printf("Quantidade de threads tem que ser menor que o piso de número de arquivos/2");
        scanf("%d", &T);
    }

    ALREADY_READ    = (bool*)malloc(A * sizeof(bool));
    VETOR_THREADS   = (pthread_t*)malloc(T * sizeof(pthread_t));
    DADOS           = (persona*)malloc(A*sizeof(persona));
    
    for(i = 0; i < T ; i++)
    {
        pthread_create(&VETOR_THREADS[i], NULL, inc, NULL);
    }

    free(ALREADY_READ);
    free(VETOR_THREADS);
    free(DADOS);
    return 0;
}

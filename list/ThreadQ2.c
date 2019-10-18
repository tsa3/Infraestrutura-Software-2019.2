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

#define PALMEIRAS_SEM_MUNDIAL 1
#define TRUE    1
#define FALSE   0
#define NAO_DEFINIDO -1
#define READ    0
#define WRITE   1

int                 N, A, T;                                            //  A = Arquivos, N = Número de usuários, T = Threads
double              soma;
FILE                *arquivo;
bool                *ALREADY_READ;                                      // Pra saber se o arquivo[i] já foi lido ou não.
pthread_mutex_t     check_files         = PTHREAD_MUTEX_INITIALIZER;    // Mutex para escolher arquivo a ser lido 
pthread_mutex_t     Somador             = PTHREAD_MUTEX_INITIALIZER;    // Mutex para soma
char                extension[5]        = ".txt";                       
bool                operation;                                          // Operação que será realizada pela thread, 0 para apenas ler, 1 para escrever

typedef struct persona                                                  // Estrutura padrão pra cada usuário
{   
    char    NOME[50];
    char    ID[100];    
    int     ULTIMO_ACESSO;
    double  PONTUACAO;
}persona;

persona *DADOS;

void *thread(){
    double Somatorio = 0;                                                                                   // Recebe a soma dos arquivos
    while(PALMEIRAS_SEM_MUNDIAL)
    {
        int cnt;
        int SELETOR_ARQUIVO = NAO_DEFINIDO;
        FILE *arquivo, arquivo_saida;
        for(cnt = 0; i < A; i++)
        {                                                                                                   // Procurar arquivo ainda não lido
            pthread_mutex_lock(&check_files);
            if(ALREADY_READ[cnt] == FALSE)
            {
                ALREADY_READ[cnt]   == TRUE;
                SELETOR_ARQUIVO     = j+1;
                break;
            }
            pthread_mutex_unlock(&check_files);
        }

        if(SELETOR_ARQUIVO == NAO_DEFINIDO)
        {                                                                                                   // Já não há arquivos para serem lido
            pthread_mutex_lock(&Somador);                                                                   // Travamos o mutex para que possamos somar na variavel de soma global
            soma += Somatorio;
            pthread_mutex_unlock(&Somador);
            pthread_exit(NULL);                                                                             // Terminamos a busca
        }
        
        snprintf(aux, "banco%d.%s",SELETOR_ARQUIVO,extension);                                              // Colocar na variavel aux a seguinte forma: bancoX.txt
        arquivo     = fopen(aux, "r+");                                                                     // Abrimos o arquivo de leitura e escrita
        snprintf(aux,"banco%d_saida.%s",SELETOR_ARQUIVO,extension); 
        arquivo_saida   = fopen(aux, "r+");                                                                 // Aqui é onde fica salva a saída do arquivo, com os devidos usuários apagados

        if(arquivo == NULL || arquivo_saida == NULL)
        {
            printf("O arquivo %d base ou o de saída não foi aberto\n", SELETOR_ARQUIVO);
            pthread_exit(NULL);
        }

        while(fscanf(arq, " %s %s %i %lf", DADOS[SELETOR_ARQUIVO].NOME, DADOS[SELETOR_ARQUIVO].ID, &DADOS[SELETOR_ARQUIVO].ULTIMO_ACESSO, &DADOS[SELETOR_ARQUIVO].PONTUACAO) != EOF)    // Ler enquanto não for fim de arquivo (End Of File)
        {                                                                                                   
            if(operation == READ)                                                                                           // Se o operation for READ, iremos apenas ler os valores e somar à variável local
            {                                                                                                       
                Somatorio += DADOS[SELETOR_ARQUIVO].ULTIMO_ACESSO/pow(DADOS[SELETOR_ARQUIVO].PONTUACAO,2);                  // Fórmula da média é media[i] = (ultimo_acesso[i]/(pontuacao[i]*pontuacao[i])/N);
            }
            else                                                                                                            // Se for WRITE, o usuário será avaliado
            {                                                                                               
                if((double)DADOS[SELETOR_ARQUIVO].ULTIMO_ACESSO/(pow(DADOS[SELETOR_ARQUIVO].PONTUACAO,2)) > soma*2)         // Se a média for maior, significa que está ausente demais e que deve ser excluído
                {                                                                                           
                    printf("%s\n", DADOS[SELETOR_ARQUIVO].NOME);
                }
                else{                                                                                                       // Escrevemos o usuário no bancoX_saida
                    fprintf(arq2,"%s %s %i %.2lf\n", DADOS[SELETOR_ARQUIVO].NOME, DADOS[SELETOR_ARQUIVO].ID, DADOS[SELETOR_ARQUIVO].ULTIMO_ACESSO, DADOS[SELETOR_ARQUIVO].PONTUACAO);
                }
            }
        }
        fclose(arquivo);                                                                                                    // Arquivos são fechados
        fclose(arquivo_saida);
    }
}

int main(){
    printf("AVISO: Os arquivos de RESPOSTA são os arquivos no formato bancoX_saida.txt!\n");
    int         i,j, aux;
    printf("Digite a quantidade de Usuarios:");
    scanf("%d", &N);
    printf("\n");
    printf("Digite a quantidade de arquivos:");
    scanf("%d", &A);
    printf("\n");
    
    while(A<2)                                                  //  Tratamento da regra 1 (A >= 2)
    {                                                           
        printf("Valor de A deve ser maior ou igual a dois\n");
        scanf("%d", &A);
    }

    scanf("%d", &T);
    while(T > floor(A/2))                                       // Tratamento da quantidade de Threads
    {                                                           
        printf("Quantidade de threads tem que ser menor que o piso de número de arquivos/2");
        scanf("%d", &T);
    }

    pthread_t *threads;                                         // Variável thread
    threads         = (pthread*)malloc(T * sizeof(pthread));    // Vetor de threads
    ALREADY_READ    = (bool*)malloc(A * sizeof(bool));          // Vetor booleano para arquivos já lidos
    DADOS           = (persona*)malloc(A*sizeof(persona));      // Vetor de estrutura com nome, pontuacao, etc
    
    pthread_attr_t atributes;                                   //Atributos de thread
    pthread_attr_init(&atributes);                              
    pthread_attr_setdetachstate(&atributes, PTHREAD_CREATE_JOINABLE);

    for(i = 0; i < T; i++)                                      // Criação das threads
    {
        int thread_boy = pthread_create(&threads[i], &atributes, thread, NULL);
    }

    for(i = 0; i < T; i++)                                      // Esperar as threads terminarem, para não usar informações erradas
    {
        pthread_join(threads[i], NULL);
    }

    soma = soma/N;                                              // Última parte do cálculo da média

    for(i = 0; i < A; i++)                                      // Todos os arquivos serão re-operados, então deve-se zerar o vetor de operados
    {
        ALREADY_READ[i] = 0;
    }

    operation = 1;

    for(i = 0; i < T; i++)                                      // Recriação das threads para modo WRITE
    {
        int thread_boy = pthread_create(&threads[i], &atributes, thread, NULL);
    }
    
    for(i = 0; i < T; i++)                                      // Esperar as threads terminarem, para não usar informações erradas
    {
        pthread_join(threads[i], NULL);
    }  

    free(ALREADY_READ);
    free(DADOS);
    pthread_exit(NULL);

    printf("%lf\n", soma);
    return 0;
}

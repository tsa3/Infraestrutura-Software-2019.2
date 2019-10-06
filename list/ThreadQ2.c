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

#define TRUE 1
#define FALSE 0
#define MAX_ARQUIVOS "8"
#define QTD_USERS "4"

int                 N, A, T;                                                                            //  A = Arquivos, N = Número de usuários, T = Threads    
FILE                *arquivo_1, *arquivo_2, *arquivo_3, *arquivo_4, *arquivo_5, *arquivo_6, *arquivo_7, *arquivo_8;
pthread_mutex_t     MEU_MUTEX = PTHREAD_MUTEX_INITIALIZER;                                              // Mutex único
bool                *ALREADY_READ;                                                                      // Pra saber se o arquivo[i] já foi lido ou não.

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
            ALREADY_READ[j] = 1;
            pthread_mutex_lock(&MEU_MUTEX);
            switch (j)
            {
                case 1:
                    fscanf(arquivo_1,"nome: % [^\n]s", DADOS[1].NOME);
                    fscanf(arquivo_1,"id: % [^\n]s", DADOS[1].ID);
                    fscanf(arquivo_1,"ultimo_acesso: % [^\n]s",DADOS[1].ULTIMO_ACESSO);
                    fscanf(arquivo_1, "pontuacao = % [^\n]", DADOS[1].PONTUACAO);
                    break;

                case 2:
                    fscanf(arquivo_2,"nome: %[^\n]s", DADOS[2].NOME);
                    fscanf(arquivo_2,"id: %[^\n]s", DADOS[2].ID);
                    fscanf(arquivo_2,"ultimo_acesso: % [^\n]s",DADOS[2].ULTIMO_ACESSO);
                    fscanf(arquivo_2, "pontuacao = % [^\n]", DADOS[2].PONTUACAO);
                    break;

                case 3:
                    fscanf(arquivo_3,"nome: %[^\n]s", DADOS[3].NOME);
                    fscanf(arquivo_3,"id: %[^\n]s", DADOS[3].ID);
                    fscanf(arquivo_3,"ultimo_acesso: % [^\n]s",DADOS[3].ULTIMO_ACESSO);
                    fscanf(arquivo_3, "pontuacao = % [^\n]", DADOS[3].PONTUACAO);
                    break;

                case 4:
                    fscanf(arquivo_4,"nome: %[^\n]s", DADOS[4].NOME);
                    fscanf(arquivo_4,"id: %[^\n]s", DADOS[4].ID);
                    fscanf(arquivo_4,"ultimo_acesso: % [^\n]s",DADOS[4].ULTIMO_ACESSO);
                    fscanf(arquivo_4, "pontuacao = % [^\n]", DADOS[4].PONTUACAO);
                    break;

                case 5:
                    fscanf(arquivo_5,"nome: %[^\n]s", DADOS[5].NOME);
                    fscanf(arquivo_5,"id: %[^\n]s", DADOS[5].ID);
                    fscanf(arquivo_5,"ultimo_acesso: % [^\n]s",DADOS[5].ULTIMO_ACESSO);
                    fscanf(arquivo_5, "pontuacao = % [^\n]", DADOS[5].PONTUACAO);
                    break;

                case 6:
                    fscanf(arquivo_6,"nome: %[^\n]s", DADOS[6].NOME);
                    fscanf(arquivo_6,"id: %[^\n]s", DADOS[6].ID);
                    fscanf(arquivo_6,"ultimo_acesso: % [^\n]s",DADOS[6].ULTIMO_ACESSO);
                    fscanf(arquivo_6, "pontuacao = % [^\n]", DADOS[6].PONTUACAO);
                    break;

                case 7:
                    fscanf(arquivo_7,"nome: %[^\n]s", DADOS[7].NOME);
                    fscanf(arquivo_7,"id: %[^\n]s", DADOS[7].ID);
                    fscanf(arquivo_7,"ultimo_acesso: % [^\n]s",DADOS[7].ULTIMO_ACESSO);
                    fscanf(arquivo_7, "pontuacao = % [^\n]", DADOS[7].PONTUACAO);
                    break;

                case 8:
                    fscanf(arquivo_8,"nome: %[^\n]s", DADOS[8].NOME);
                    fscanf(arquivo_8,"id: %[^\n]s", DADOS[8].ID);
                    fscanf(arquivo_8,"ultimo_acesso: % [^\n]s",DADOS[8].ULTIMO_ACESSO);
                    fscanf(arquivo_8, "pontuacao = % [^\n]", DADOS[8].PONTUACAO);
                    break;

                default:
                    break;
            }
        pthread_mutex_unlock(&MEU_MUTEX);
        }
        else if (j<A) j++;

    }
    
}

void gotta_open_them_all(FILE *arquivo_1, FILE *arquivo_2,FILE *arquivo_3, FILE *arquivo_4, FILE *arquivo_5, FILE *arquivo_6, FILE *arquivo_7, FILE *arquivo_8)
{
    arquivo_1 = fopen("./files/banco1.txt", "r+");
    arquivo_2 = fopen("./files/banco2.txt", "r+");
    arquivo_3 = fopen("./files/banco3.txt", "r+");
    arquivo_4 = fopen("./files/banco4.txt", "r+");
    arquivo_5 = fopen("./files/banco5.txt", "r+");
    arquivo_6 = fopen("./files/banco6.txt", "r+");
    arquivo_7 = fopen("./files/banco7.txt", "r+");
    arquivo_8 = fopen("./files/banco8.txt", "r+");
}

void gotta_close_them_all(FILE *arquivo_1, FILE *arquivo_2,FILE *arquivo_3, FILE *arquivo_4, FILE *arquivo_5, FILE *arquivo_6, FILE *arquivo_7, FILE *arquivo_8)
{
    fclose(arquivo_1);
    fclose(arquivo_2);
    fclose(arquivo_3);
    fclose(arquivo_4); 
    fclose(arquivo_5);
    fclose(arquivo_6); 
    fclose(arquivo_7);
    fclose(arquivo_8); 
}

int main(){
    
    // Sessão de arquivos
    gotta_open_them_all(&arquivo_1, &arquivo_2, &arquivo_3, &arquivo_4, &arquivo_5, &arquivo_6, &arquivo_7, &arquivo_8);
    
    // Sessão de vetores
    pthread_t   *VETOR_THREADS;
    double      MEDIA_INAT;
    
    // Sessão de contadores
    int         i;
    
    // Começando os trabalhos
    
    
    printf("Como numero maximo, colocamos "MAX_ARQUIVOS" arquivos para serem lidos, cada um deles com "QTD_USERS" usuarios distintos, ja que nao foram dadas informacoes sobre isso.\n");
    printf(" O que te da uma quantidade de 8x4 usuarios para serem lidos.");
    printf("Utilize essa informacao pra definir a quantidade de arquivos a serem lidos, pra nao passar do numero max.");
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

    gotta_close_them_all(&arquivo_1, &arquivo_2, &arquivo_3, &arquivo_4, &arquivo_5, &arquivo_6, &arquivo_7, &arquivo_8);
    free(ALREADY_READ);
    free(VETOR_THREADS);
    free(DADOS);
    return 0;
}
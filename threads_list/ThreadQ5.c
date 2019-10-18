#include <pthread.h>
#include <stdio.h>
#include <string.h>
#define number 4

//Variaveis globais
float vet_normal[number]; 
float matriz_normal[number][number]; 
float matriz_esparsa[number][number], matriz_esparsa1[number][number], matriz_esparsa2[number][number];
float result_1[number][1], result_2[number][number], result_3[number][number];
long *taskid[number];

//Funções
void multiplica_vet();
void *multiplica_mat_esparsa(void *tid);
void *multiplica_mat_normal(void *tid);

int main(int argc, char *argv[])
{
    int i, j, k;
    pthread_t threads[number];
    //Zera matriz esparas e vetor esparso
    for(i = 0; i < number; i++)
    {
        for(j = 0; j < number; j++)
        {
            result_1[i][j] = 0;
            result_2[i][j] = 0;
            result_3[i][j] = 0;
            matriz_esparsa[i][j] = 0;
            matriz_esparsa1[i][j] = 0;
            matriz_esparsa2[i][j] = 0;
            matriz_normal[i][j] = 0;
        }
    }
    //Leitura do vetor denso
    printf("Preencha um vetor de 4 posicoes.\n");
    for(i = 0; i < number; i++)
    {
        printf("Valor na posicao %d: ", i);
        scanf("%f:", &vet_normal[i]);
    }
    printf("\n");
    //Leitura da matriz densa
    printf("Preencha uma matriz 4x4.\n");
    for(i = 0; i < number; i++)
    {
        for(j = 0; j < number; j++)
        {
            printf("Valor na posicao %dx%d: ", i, j);
            scanf("%f:", &matriz_normal[i][j]);
        }
    }
    printf("\n");
    //Leitura da matriz esparsa
    printf("Preencha uma matriz esparsa. A matriz sera transformada em esparsa.\n");
    //A matriz esparsa não vai considerar as posições que tiverem valor zero
    for(i = 0; i < number; i++)
    {
        for(j = 0; j < number; j++)
        {
            printf("Valor na posicao %dx%d: ", i, j);
            scanf("%f", &matriz_esparsa[i][j]);
            matriz_esparsa1[i][j] = matriz_esparsa[i][j];
        }
    }
    //Leitura da matriz esparsa
    printf("Preencha uma matriz esparsa. A matriz sera transformada em esparsa.\n");
    //A matriz esparsa não vai considerar as posições que tiverem valor zero
    for(i = 0; i < number; i++)
    {
        for(j = 0; j < number; j++)
        {
            printf("Valor na posicao %dx%d: ", i, j);
            scanf("%f", &matriz_esparsa2[i][j]);
        }
    }
    //Multiplicação da matriz esparsa pelo vetor denso
    multiplica_vet();
    //Aloca o ponteiro com a quantidade de threads
    for(i = 0; i < number; i++)
    {
        taskid[i] = (long *) malloc(sizeof(long));
        *taskid[i] = i;
        //Multiplicação de uma matriz esparsa por uma matriz esparsa
        pthread_create(&threads[i], NULL, multiplica_mat_esparsa, (void *) taskid[i]);
        //Multiplicação de um matriz esparsa por uma matriz densa       
        pthread_create(&threads[i], NULL, multiplica_mat_normal, (void *) taskid[i]);
    }

    //Imprime o resultado 1
    printf("Resultado 1\n");
    for(int i = 0; i < number; i++)
    {
        printf("%.2f \n", result_1[i][0]);
    }
    printf("\n");
    //Imprime o resultado 2
    printf("Resultado 2\n");
    for(i = 0; i < number; i++)
    {
        for(j = 0; j < number; j++)
        {
            printf("%.2f ", result_2[i][j]);
        }
        printf("\n");
    }
    printf("\n");
    //Imprime o resultado 3
    printf("Resultado 3\n");
    for(i = 0; i < number; i++)
    {
        for(j = 0; j < number; j++)
        {
            printf("%.2f ", result_3[i][j]);
        }
        printf("\n");
    }
    printf("\n");
    return 0;
}
//Multiplicação da matriz esparsa pelo vetor denso
void multiplica_vet()
{
    int i, j;
    for(j = 0; j < number; j++)
    {
        for(i = 0; i < number; i++)
        {
            if(matriz_esparsa[i][j] != 0)
                matriz_esparsa[i][j] *= vet_normal[j];
        }
    }
    for(i = 0; i < number; i++)
    {
        result_1[i][0] = 0;
        for(j = 0; j < number; j++)
        {
            result_1[i][0] += matriz_esparsa[i][j];
        }
    }
}
//Multiplicação de uma matriz esparsa por uma matriz esparsa
void *multiplica_mat_esparsa(void *tid)
{
    int h, i, j, k;
    long threadId = (*(long *)tid);
    for(i = threadId; i < number; i++)
    {
        for(j = 0; j < number; j++)
        {
            result_2[i][j] = 0;
            for(k = 0; k < number; k++)
            {
                if((matriz_esparsa1[i][k] != 0) && (matriz_esparsa2[k][j] != 0))
                    result_2[i][j] += matriz_esparsa1[i][k] * matriz_esparsa2[k][j];
            }
        }
    }
}
//Multiplicação de um matriz esparsa por uma matriz densa
void *multiplica_mat_normal(void *tid)
{
    int h, i, j, k;
    long threadId = (*(long *)tid);
    for(i = threadId; i < number; i++)
    {
        for(j = 0; j < number; j++)
        {
            result_3[i][j] = 0;
            for(k = 0; k < number; k++)
            {
                if(matriz_esparsa1[i][k] != 0)
                    result_3[i][j] += matriz_esparsa1[i][k] * matriz_normal[k][j];
            }
        }
    }
}
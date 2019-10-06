#include <pthread.h>
#include <stdio.h>
#include <string.h>
#define num_threads 4

int a, b, number_primos, numbers[10000];

void *primos(void *threadid);
void *divisores(void *threadid);
void *maior_divisores(void *threadid);
void *num_maior_divisores(void *threadid);

int main(int argc, char *argv[])
{
    pthread_t thread0, thread1, thread2, thread3;
    memset(numbers, 0, sizeof(numbers[0]) * 10000);
    scanf("%d %d", &a, &b);
    pthread_create(&thread0, NULL, primos, NULL);
    pthread_join(thread0, NULL);
    pthread_create(&thread1, NULL, divisores, NULL);
    pthread_join(thread1, NULL);
    pthread_create(&thread2, NULL, maior_divisores, NULL);
    pthread_join(thread2, NULL);
    pthread_create(&thread3, NULL, num_maior_divisores, NULL);
    pthread_join(thread3, NULL);
    pthread_exit(NULL);
    return 0;
}
//Encontra a quantidade de números primos no intervalo
void *primos(void *threadid)
{
    int primo;
    //Intervalo decrescente
    if(a > b)
    {
        for(int i = b; i <= a ; i++)
        {
            primo = 1;
            for(int j = 2; (j < i) && (primo == 1); j++)
            {
                if(i % j == 0)
                    primo = 0;
            }
            if(primo && i != 1)
                number_primos++;
        }
    }   
    //Intervalo crescente
    else if(a < b)
    {
        for(int i = a; i <= b; i++)
        {
            primo = 1;
            for(int j = 2; (j < i) && (primo == 1); j++)
            {
                if(i % j == 0)
                    primo = 0;
            }
            if(primo && i != 1)
                number_primos++;
        }
    }
    //Intervalo inicia e finaliza no mesmo número
    else
    {
        primo = 1;
        if((a == 0) || (a == 1))
            number_primos = 0;
        else if(a == 2)
            number_primos = 1;
        else
        {
            for(int i = 2; (i < a) && (primo == 1); i++)
            {
                if(a % i == 0)
                    primo = 0;
            }
            if(primo)
                number_primos++;
        }
    }
    printf("%d \n", number_primos);
}
//Encontra a maior quantidade de divisores no intervalo
void *divisores(void *threadid)
{
    if(a > b)
    {
        for(int i = b; i <= a; i++)
        {
            for(int j = 1; j <= i; j++)
            {
                if(i % j == 0)
                    numbers[i]++;
            }
        }
    }   
    else if(a < b)
    {
        for(int i = a; i <= b; i++)
        {
            for(int j = 1; j <= i; j++)
            {
                if(i % j == 0)
                    numbers[i]++;
            }
        }
    } 
    else
    {
        for(int i = 1; i <= a; i++)
        {
            if(a % i == 0)
                numbers[a]++;
        }
    }
}
//Verifica o maior número de divisores
void *maior_divisores(void *threadid)
{
    int maior = 0;
    if(a < b)
    {
        for(int i = a; i <= b; i++)
        {
            if(maior < numbers[i])
                maior = numbers[i];
        }
    }
    else if(a > b)
    {
        for(int i = b; i <= a; i++)
        {
            if(maior < numbers[i])
                maior = numbers[i];
        }
    }
    else
        maior = numbers[a];
    printf("%d \n", maior);
}
//Verifica o número que possui maior divisores
void *num_maior_divisores(void *threadid)
{
    int maior = 0, num = 0;
    if(a < b)
    {
        for(int i = a; i <= b; i++)
        {
            if(maior < numbers[i])
            {
                maior = numbers[i];
                num = i;
            }
        }
    }
    else if(a > b)
    {
        for(int i = b; i <= a; i++)
        {
            if(maior < numbers[i])
            {
                maior = numbers[i];
                num = i;
            }
        }
    }
    else
        num = a;
    printf("%d \n", num);
}
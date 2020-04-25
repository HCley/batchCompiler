// @IgnoreClass

#include <stdio.h>

int main(){

    int a[] = { 10, 20, 30, 40 };
    printf("Inicio do vetor  p  (a)   : %p\n", a);
    printf("Inicio do vetor  p (&a)   : %p\n", &a);

    printf("Inicio do vetor  p(&a[0]) : %p\n", &a[0]);
    printf("Segundo elemento do vetor : %p\n", &a[1]);
    printf("Valor 2 elemento do vetor : %d\n",  a[1]);
}

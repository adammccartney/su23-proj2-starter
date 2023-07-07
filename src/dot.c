/*
* dot.c - compute the dot product of two arrays 
* */

#include <stdio.h>

/* Arrays A and B, strides for each and elems is number of elements to be
* multiplied. 
* */
int dot(int* arrA, int strA, int* arrB, int strB, int elems)
{
if (elems < 1)
    return 36;
if ((strA < 1) || (strB < 1))
    return 37;
int result = 0;
int i = 0;
int j = 0;
int count = 0;
do {
    result += arrA[i] * arrB[j];
    i = i + strA;
    j = j + strB;
    count++;
} while (count < elems);
return result;
}


int main(void)
{
int arrA[9] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
int arrB[9] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
int elem = 3;
int result;
result = dot(arrA, 1,  arrB, 2, elem);
printf("%d\n", result);
return 0;
}



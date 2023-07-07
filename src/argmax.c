/*
 * argmax.c - find the index of the largest element in an array
 * */

#include <stdio.h>

int argmax(int* arr, int len)
{
    /**/
    int i, result;
    if (1 > len) {
        return 36;
    }
    for (i = 0; i < len; i++) {
        if (arr[result] < arr[i]) {
            result = i;
        }
    }
    return result;
}


int main(void)
{
    int arr[5] = {0, 2, -4, 6, 3};
    int res;
    res = argmax(arr, 5);
    printf("index: %d\n", res);
    return 0;
}


/*
 * matmul.c - matrix multiplication 
 * */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

struct matrix {
    int cols;
    int rows;
    int* vals; /* variable size so at end */
};

void init_matrix(struct matrix* m, int* vals, int cols, int rows)
{
  m->cols = cols;
  m->rows = rows;
  m->vals = vals;
};

/* Arrays A and B, strides for each and elems is number of elements to be
 * multiplied. 
 * */
int dot(int* arrA, int* arrB, int elems, int strA, int strB)
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


void matmul(int* m0, int m0r, int m0c, int* m1, int m1r, int m1c, int* m2)
{
    /* use dot to multiply each row of m0 by each column of m1 and store
     * result in m2 
     * */
    /* Check if m0 and m1 have dimensions suitable for multiplcation  */
    if (m0c != m1r)
        exit(38);
    /* Check for negative vals */
    if ((0 >= m0r) || (0 >= m1c))
        exit(38);
    /* prepare to call dot
     * m0w is the stride for m0 
     * m0w * m0h is the number of elements in m0 
     * m1w is the stride for m1 
     * m1w * m1h is the number of elements in m1 
     * */
    int i = 0;
    int j = 0;
    int res_size = m0r * m1c; /* number of items in result */
    /* naive algorithm for matrix mutliplication */
    int res_index = 0;
    for (i = 0; i < m0r; i++) {
        for (j = 0; j < m1c; j++) {
            res_index = i * m1c + j;
            int m0str = 1; /* stride of array 0 */
            /* args: *m0, *m1, elems, stride0, stride1 */
            m2[res_index] = dot(m0 + i * m0c, m1 + j, m1r, m0str, m1c);
        }
    }
}

int main(void)
{
    struct matrix* m0 = malloc(sizeof(struct matrix)); /* first matrix */
    struct matrix* m1 = malloc(sizeof(struct matrix)); /* second matrix */ 
    int vals0[6] = {1, 4, 2, 5, 3, 6}; /* test values */ 
    int* v0p = &vals0[0];
    int vals1[6] = {1, 1, 3, 7, 8, 1}; /* test values */
    int* v1p = &vals1[0];
    init_matrix(m0, v0p, 3, 2);
    init_matrix(m1, v1p, 2, 3);
    assert(m0->rows == m1->cols); // check if matrices can be multiplied
    assert(m0->cols == m1->rows); // check if matrices can be multiplied
    int outvals = m0->rows * m1->cols; // num columns in arr0 * num rows in arr1 
    struct matrix* m2 = malloc(sizeof(struct matrix)); /* result matrix */ 
    int vals2[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0}; /* init result matrix with 0*/ 
    int* v2p = &vals2[0];
    init_matrix(m2, v2p, m0->rows, m1->cols);
    
    /* multiply the two */
    matmul(m0->vals, m0->rows, m0->cols, m1->vals, m1->rows, m1->cols, m2->vals);
    
    for (int i = 0; i < outvals; i++)
        printf("%d\n", m2->vals[i]);

    free(m0);
    free(m1);
    free(m2);
    return 0;
}

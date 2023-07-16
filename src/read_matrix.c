/*
 * read_matrix.c - read a matrix from a file 
 *
 * 1. Open file with read permissions. The file is provided as a command line argument. 
 * 2. Use fread to read the number of rows and columns from the file (the first two integers
 * in the file). Store these integers in memory 
 * 3. Allocate memory for the matrix (Row * Column) 
 * 4. Read the matrix from the file and store it in the allocated memory 
 * 5. Close the file 
 * 6. Return the pointer to the allocated memory 
 *
 * */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ERR_MALLOC 26
#define ERR_FOPEN  27
#define ERR_FCLOSE 28
#define ERR_FREAD  29


/* Read a matrix from a file 
 * a matrix file is in binary format the blocks are 4 bytes long 
 * the first two blocks contain row and column infor for matrix
 * */
#define BLOCKSIZE 4 
#define INITIAL_READ 2
int* read_matrix(char* fname)
{
    /* Open file with read permissions */
    FILE* fp = fopen(fname, "r"); 
    if (fp == NULL) {
        printf("Error opening file %s\n", fname);
        exit(ERR_FOPEN);
    }
    /* Read the number of rows and columns from the file (the first two integers
     * in the file). Store these integers in memory */ 

    /* Read matrix info */
    // int* buf_minfo = readnblocks(fp, INITIAL_READ, BLOCKSIZE); 
    int buf_minfo[2];
    if (fread(buf_minfo, BLOCKSIZE, INITIAL_READ, fp) != INITIAL_READ) {
        exit(ERR_FREAD);
    }

    /* Store rows and columns as a record */
    int mdimension =  buf_minfo[0] * buf_minfo[1];

    /* Allocate memory for the matrix (Row * Column) */
    int* matrix = malloc(mdimension * BLOCKSIZE);
    if (matrix == NULL) {
        exit(ERR_MALLOC);
    }
    /* Read mdimension blocks from file, store in buffer */
    // int* buf_matrix = readnblocks(fp, mdimension, BLOCKSIZE);
    if (fread(matrix, BLOCKSIZE, mdimension, fp) != mdimension) {
        exit(ERR_FREAD);
    }

    /* Close the file */
    if (fclose(fp) != 0) {
        exit(ERR_FCLOSE);
    }
    
    /* Return the pointer to the allocated memory */
    return matrix;
} 

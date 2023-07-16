/* runner.c - a main program to get some of the smaller functions running  in
 * gdb 
 * */

#include <stdio.h>
#include <stdlib.h>
#include "read_matrix.c"

int main(int argc, char* argv[])
{
    if (argc < 2) {
        printf("Usage: ./runner <filename>\n");
        return 1;
    }
    char* filename = argv[1];
    int* buf = read_matrix(filename);
    return 0;
}

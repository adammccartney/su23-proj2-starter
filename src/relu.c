/* rectifier function for a neural net 
 * Takes in a 1D vector and applies the rectifier function on each element,
 * modifying it in place. This is equivalent to setting every negative value in
 * the vector to 0. If the length of the vector is less than 1, your should exit
 * the program with error code 32.
 * */

int relu(int* vector, int nelem)
{
    if (1 > nelem)                  /* bgt */
        return 32;
    for (int i = 0; i < nelem; i++) {
        if (0 > vector[i])
            vector[i] = 0;
    }
    return 0;
}

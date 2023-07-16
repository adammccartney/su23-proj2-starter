.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================

read_matrix:
    # Prologue
        addi sp, sp, -32         # allocate space for 7 registers
        sw s0, 0(sp)             # space for local filename 
        sw s1, 4(sp)             # space for local number of rows 
        sw s2, 8(sp)             # space for local number of columns 
        sw s3, 12(sp)            # space for local file descriptor 
        sw s4, 16(sp)            # space for local matrix size 
        sw s5, 20(sp)            # space for checks after reads 
        sw s6, 24(sp)            # space for local matrix pointer
        sw ra, 28(sp)            # space for return address

        # Set locals 
        add s0, a0, zero         # s0 = a0 ... filename 
        add s1, a1, zero         # s1 = pointer to space to store num cols 
        add s2, a2, zero         # s2 = pointer to space to store num rows

        # Read file 
        add     a0, s0, zero       # char* filename 
        add     a1, zero, zero     # int flags
        call    fopen              # fopen(a0, a1) -> returns fd as int  
        addi    t0, zero, -1       # t0 = -1 ... error code
        beq     t0, a0, err_fopen   # if a5 == -1, jump to err_fopen

        add     s3, a0, x0         # s3 = a0 ... file descriptor

        # Read two 4-byte blocks (num rows and num cols)
        add     a0, s3, zero       # a0 = s1 ... file descriptor 
        add     a1, s1, zero       # a0 = s2 ... move in row pointer 
        addi    a2, zero, 4        # read 4 bytes (1 integer) 
        call    fread              # fread(fd: a0, int*: a1, int: a2) -> returns number of bytes read
        addi    t0, zero, 4
        bne     a0, t0, err_fread  # if a0 != a2, jump to err_fread

        lw      t0, 0(s1)
        blt     t0, zero, err_fread  # if cols < 0, jump to err_fread 

        add     a0, s3, zero       # a0 = s3 ... file descriptor 
        add     a1, s2, zero       # a1 = s2 ... move in row pointer 
        addi    a2, zero, 4        # read 4 bytes (1 integer) 
        call    fread              # fread(fd: a0, int*: a1, int: a2) -> returns number of bytes read 
        addi    t0, zero, 4
        bne     a0, t0, err_fread  # if a0 != a2, jump to err_fread 

        lw     t0, 0(s2) 
        blt    t0, zero, err_fread  # if rows < 0, jump to err_fread

        # Allocate memory for matrix
        ebreak
        lw      t0, 0(s1)          # t0 = t0 ... number of rows
        lw      t1, 0(s2)          # t1 = t1 ... number of columns
        mul     a0, t0, t1         # a0 = t0 * t1 ... number of elements 
        add     s5, a0, zero       # save the number of entries 
        addi    t0, zero, 4        # t0 = 4 ... size of an integers
        mul     a0, a0, t0         # a0 = a0 * t0 ... number of bytes
        call    malloc
        beq     a0, zero, err_malloc # if a0 == 0, jump to err_malloc

        add     s6, a0, zero       # s6 = a0 ... pointer to allocated memory

        add     a0, s3, zero       # a1 = s1 ... file descriptor 
        add     a1, s6, zero       # a2 = s2 ... pointer to allocated memory 
        lw      t0, 0(s1)          # t0 = t0 ... number of rows
        lw      t1, 0(s2)          # t1 = t1 ... number of columns 
        mul     a2, t0, t1         # a3 = t0 * t1 ... number of elements 
        addi    t0, zero, 4        # t0 = 4 ... size of an integers 
        mul     a2, a2, t0         # a2 = a2 * t0 ... number of bytes 
        # save this value for check later 
        add     s5, a2, zero       # s6 = a2 ... number of bytes
        call    fread              # fread(fd: a0, void*: a1, size_t: a2) -> returns number of bytes read 
        bne     a0, s5, err_fread  # if a0 != s6, jump to ERR_FREAD 

        add     a0, s3, zero      # a1 = s1 ... file descriptor
        call    fclose            # fclose(a0) -> returns 0 on success, -1 on failure 
        bne     a0, zero, err_fclose # if a0 != 0, jump to err_fclose

        add     a0, s6, zero      # a0 = s2 ... pointer to allocated memory

        # Epilogue
        lw      s0, 0(sp)          # restore s0
        lw      s1, 4(sp)          # restore s1
        lw      s2, 8(sp)          # restore s2
        lw      s3, 12(sp)         # restore s3
        lw      s4, 16(sp)         # restore s4
        lw      s5, 20(sp)         # restore s5
        lw      s6, 24(sp)         # restore s6
        lw      ra, 28(sp)         # restore ra 
        addi    sp,sp,32           # deallocate space for 5 registers
        jr      ra                 # return


err_malloc:
        li      a0,26              # ERR_MALLOC
        call    exit

err_fopen:
        li      a0,27              # ERR_FOPEN
        call    exit 

err_fclose:
        li      a0,28              # ERR_FCLOSE
        call    exit

err_fread:
        li      a0,29              # ERR_FREAD
        call    exit


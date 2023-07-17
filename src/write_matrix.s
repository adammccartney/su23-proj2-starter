.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    ebreak
    addi sp, sp, -24    # Allocate space on the stack for 8 registers
    sw s0, 0(sp)        # space for local filename 
    sw s1, 4(sp)        # space for pointer to local matrix 
    sw s2, 8(sp)        # space for local rows
    sw s3, 12(sp)       # space for local cols 
    sw s4, 16(sp)       # file descriptor
    sw ra, 20(sp)       # space for return address

    # Set locals 
    mv s0, a0   # filename
    mv s1, a1   # matrix 
    mv s2, a2   # rows
    mv s3, a3   # columns 

    # Open file 
    mv a0, s0         # filename
    li a1, 1           # mode = write 
    call fopen          # a0 = file pointer 
    li t0, -1          # check for error 
    beq  t0, a0, err_fopen # if a0 == -1, error
    mv s4, a0          # save file descriptor

    # Write rows to file 
    li a0, 8
    call malloc
    sw s2, 0(a0)        # store rows 
    sw s3, 4(a0)        # store cols
    mv a1, a0           # pointer to num rows and cols 
    mv a0, s4           # file descriptor 
    li a2, 2            # num elements to write 
    li a3, 4            # size of each element 
    call fwrite          # a0 = elements written 
    li t0, 2            # check elements written 
    bne a0, t0, err_fwrite # if a0 != elements written, error

    # Write matrix to file
    mv a0, s4           # file descriptor 
    mv a1, s1           # pointer to matrix 
    mul a2, s2, s3      # number of elements to write 
    li a3, 4            # size of each element 
    call fwrite         # a0 = elements written 
    mul t0, s2, s3      # check elements written 
    bne a0, t0, err_fwrite # if a0 != elements written, error 

    # Close file 
    mv a0, s4           # load file descriptor
    call fclose         # a0 = 0 if success, -1 if error 
    li t0, -1
    beq t0, a0, err_fclose # if a0 == -1, error

    # Epilogue
    lw s0, 0(sp)        # restore registers
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24     # deallocate stack space
    jr ra


err_fopen:
        li   a0,27              
        call exit 

err_fclose:
        li   a0,28              
        call exit 

err_fwrite:
        li   a0,30              
        call exit 


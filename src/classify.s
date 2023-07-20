.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:

    # Check for correct number of command line Args
    li t0, 5 
    bne a0, t0, err_args

    # Prologue 
    addi sp, sp, -48 # Allocate space for 8 words on stack 
    sw s0, 0(sp)     # Save s0
    sw s1, 4(sp)     # Save s1
    sw s2, 8(sp)     # Save s2
    sw s3, 12(sp)    # Save s3
    sw s4, 16(sp)    # Save s4
    sw s5, 20(sp)    # Save s5
    sw s6, 24(sp)    # Save s6
    sw s7, 28(sp)    # Save s7 
    sw s8, 32(sp)    # Save s8
    sw s9, 36(sp)    # Save s9 
    sw s10, 40(sp)   # Save s10
    sw s11, 44(sp)   # Save s11
    

    # Set locals 
    lw s2, 4(a1)     # argv[1] pointer to filepath string of m0 
    lw s3, 8(a1)     # argv[2] pointer to filepath string of m1
    lw s4, 12(a1)    # argv[3] pointer to filepath string of input matrix 
    lw s5, 16(a1)    # argv[4] pointer to filepath string of output file

    # Save s2 and ra 
    addi sp, sp, -8  # Allocate space for 2 words on stack 
    sw a2, 0(sp)     # Save s2  
    sw ra, 4(sp)     # Save ra 


    # Read pretrained m0
    li a0, 8        # size needed to store row & column info 
    jal malloc      # allocate 8 bytes for
    beq zero, a0, err_malloc

    mv s6, a0       # s6 = pointer to allocated memory

    mv a1, a0       # a1 = pointer to memory for rows 
    addi a0, a0, 4  # a0 = pointer to memory for columns
    mv a2, a0       # a2 = pointer to memory for columns
    mv a0, s2       # filepath string of m0
    jal read_matrix # read m0 into memory

    mv s7, a0       # s7 = pointer to m0 matrix

    # Read pretrained m1
    li a0, 8        # size needed to store row & column info
    jal malloc      # allocate 8 bytes for
    beqz a0, err_malloc

    mv s8, a0       # s8 = pointer to allocated memory

    mv a1, a0       # a1 = pointer to memory for rows
    addi a0, a0, 4  # a0 = pointer to memory for columns
    mv a2, a0       # a2 = pointer to memory for columns
    mv a0, s3       # filepath string of m1 
    jal read_matrix # read m1 into memory

    mv s0, a0       # s0 = pointer to m1 matrix


    # Read input matrix
    li a0, 8        # size needed to store row & column info 
    jal malloc      # allocate 8 bytes for 
    beqz a0, err_malloc 

    mv s9, a0       # s9 = pointer to allocated memory 

    mv a1, a0       # a1 = pointer to memory for rows
    addi a0, a0, 4  # a0 = pointer to memory for columns
    mv a2, a0       # a2 = pointer to memory for columns
    mv a0, s4       # filepath string of input matrix 
    jal read_matrix # read input matrix into memory 

    mv s1, a0       # s1 = pointer to input matrix 


    # Compute h = matmul(m0, input)
    lw t0, 0(s6)    # a0 = rows of m0
    lw t1, 4(s9)    # a1 = columns of input matrix 
    mul s2, t0, t1  # t3 = size of h matrix 
    slli a0, s2, 2   # size in bytes of h matrix 
    jal malloc      # allocate memory for m0 matrix 
    beqz a0, err_malloc 

    mv s10, a0       # a6 = pointer to h matrix

    # setup to call matmul 
    mv a0, s7       # a0 = pointer to m0 matrix
    lw a1, 0(s6)    # a1 = rows of m0 
    lw a2, 4(s6)    # a2 = columns of m0 
    mv a3, s1       # a3 = pointer to input matrix 
    lw a4, 0(s9)    # a4 = rows of input matrix 
    lw a5, 4(s9)    # a5 = columns of input matrix 
    mv a6, s10      # a6 = pointer to h matrix
    jal matmul      # compute h = matmul(m0, input) 

    # Compute h = relu(h)
    mv a1, s2       # a2 = size of h matrix
    mv a0, s10      # a0 = pointer to h matrix 
    jal relu        # compute h = relu(h)

    # Compute o = matmul(m1, h)
    lw t0, 0(s8)    # t0 = rows of m1 
    lw t1, 4(s9)    # t1 = columns of h (== columns of input)
    mul s3, t0, t1  # t3 = size of o matrix 
    slli a0, s3, 2  # size in bytes of o matrix 
    jal malloc      # allocate memory for o matrix
    beqz a0, err_malloc

    mv s11, a0      # s11 = pointer to o matrix 


    # setup to call matmul 
    mv a0, s0       # a0 = pointer to m1 matrix 
    lw a1, 0(s8)    # a1 = rows of m1 
    lw a2, 4(s8)    # a2 = columns of m1 
    mv a3, s10      # a3 = pointer to h matrix 
    lw a4, 0(s6)    # a4 = rows of h matrix (== rows m0) 
    lw a5, 4(s9)    # a5 = columns of h matrix (== cols input) 
    mv a6, s11      # a6 = pointer to o matrix 
    jal matmul      # compute o = matmul(m1, h)


    # Write output matrix o
    mv a0, s5       # a0 = pointer to filepath string of output matrix 
    mv a1, s11      # a1 = pointer to o matrix 
    lw a2, 0(s8)    # a2 = rows of o (== rows m1) 
    lw a3, 4(s9)    # a3 = columns of o (== cols h / input) 
    jal write_matrix # write o matrix to file


    # Compute and return argmax(o)
    mv a0, s11      # a0 = pointer to o matrix (array)
    mv a1, s3       # a1 = size of o matrix (array)
    jal argmax      # compute argmax(o)
    mv s4, a0


    ebreak
    # Free heap 
    mv a0, s6       # a0 = pointer to m0 matrix 
    jal free        # free m0 matrix 
    mv a0, s8       # a0 = pointer to m1 matrix 
    jal free        # free m1 matrix 
    mv a0, s9       # a0 = pointer to input matrix 
    jal free        # free input matrix 
    mv a0, s10      # a0 = pointer to h matrix 
    jal free        # free h matrix 
    mv a0, s11      # a0 = pointer to o matrix 
    jal free        # free o matrix 

    # If enabled, print argmax(o) and newline
    lw a2, 0(sp)
    addi sp, sp, 4 

    bne zero, a2, end # if a2 != 0, skip printing argmax(o)
    mv a0, s4       # a0 = argmax(o) 
    jal print_int   # print argmax(o)
    li a0, '\n'      # t1 = newline character 
    jal print_char  # print newline character 

end:
    mv a0, s4       # a0 = argmax(o) 
    lw ra, 0(sp)    # Restore ra 
    addi sp, sp, 4  # Deallocate space for 1 word on stack

    # Epilogue
    lw s0, 0(sp)     # Restore s0
    lw s1, 4(sp)     # Restore s1
    lw s2, 8(sp)     # Restore s2
    lw s3, 12(sp)    # Restore s3
    lw s4, 16(sp)    # Restore s4
    lw s5, 20(sp)    # Restore s5
    lw s6, 24(sp)    # Restore s6
    lw s7, 28(sp)    # Restore s7 
    lw s8, 32(sp)    # Restore s8 
    lw s9, 36(sp)    # Restore s9 
    lw s10, 40(sp)   # Restore s10 
    lw s11, 44(sp)   # Restore s11 
    addi sp, sp, 48  # Deallocate space for 8 words on stack

    jr ra            # return to caller


err_malloc:
    li a0, 26
    call exit

err_args:
    li a0, 31
    call exit


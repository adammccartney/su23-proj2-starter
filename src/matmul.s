.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    # Prologue
    addi  sp, sp, -80   # allocate space for 20 registers
    sw    ra, 76(sp)    # save return address
    sw    s0, 72(sp)    # save s0 
    sw    s1, 68(sp)    # save s1 
    addi  s0, sp, 80    # s0 = sp + 80 
    sw    a0, -52(s0)   # save a0 (int*), start of m0
    sw    a1, -56(s0)   # save a1 (int), # rows of m0
    sw    a2, -60(s0)   # save a2,(int), # cols of m0
    sw    a3, -64(s0)   # save a3,(int*),  start of m1
    sw    a4, -68(s0)   # save a4, (int), # rows in m1
    sw    a5, -72(s0)   # save a5, (int), # cols of m1
    sw    a6, -76(s0)   # save a6, (*int), start of d
    # check that cols of m0 == rows of m1
    lw  a4, -60(s0) # load cols of m0
    lw  a5, -68(s0) # load rows of m1
    beq a4, a5, check_size # chec that cols of m0 == rows of m1
    li a0, 38 # exit code 38
    call exit # exit program

check_size:
    # check if i < width of m0 
    lw  a5, -56(s0) # load rows of m0
    ble a5, zero, error 
    lw  a5, -72(s0) # load cols of m1
    bgt a5, zero, outer_loop_start 

error:
    li  a0,38
    call exit

outer_loop_start:
    sw  zero, -20(s0) # i = 0
    sw  zero, -24(s0) # j = 0 
    lw a4, -56(s0)    # load rows of m0 
    lw a5, -72(s0)    # load cols of m1  
    mul a5,a4,a5      # res_size = m0->rows * m1->cols
    sw  a5, -28(s0)   # save a5, total number of iterations
    sw  zero, -32(s0) # k = 0
    sw  zero, -20(s0) # i = 0
    j outer_loop_end

inner_loop_start:
    sw  zero, -24(s0) # j = 0 
    j inner_loop_end

inner_loop_body:
    lw      a4,-20(s0)  # load i 
    lw      a5,-72(s0)  # load m1->cols 
    mul     a5,a4,a5    # a5 = i * m1->cols 
    lw      a4,-24(s0)  # load j 
    add     a5,a4,a5    # a5 = i * m1->cols + j 
    sw      a5,-32(s0)  # k = i * m1->cols + j 
    li      a5,1        # stride of m0 
    sw      a5,-36(s0)  # store stride of m0 
    lw      a4,-20(s0)  # load i 
    lw      a5,-60(s0)  # load m0->cols 
    mul     a5,a4,a5    # a5 = i * m0->cols 
    slli    a5,a5,2     # a5 = i * m0->cols * 4 
    lw      a4,-52(s0)  # load &m0[0] 
    add     a0,a4,a5    # a0 = &m0[i * m0->cols]
    lw      a5,-24(s0)  # load j 
    slli    a5,a5,2     # a5 = j * 4 
    lw      a4,-64(s0)  # load &m1[0] 
    add     a1,a4,a5    # a1 = &m1[j] 
    lw      a5,-32(s0)  # load [i * m1->cols + j]
    slli    a5,a5,2     # a5 = [i * m1->cols + j] * 4  
    lw      a4,-76(s0)  # load &d[0] 
    add     s1,a4,a5    # s1 = &d[i * m1->cols + j]
    lw      a4,-72(s0)  # load m1->cols 
    lw      a3,-36(s0)  # load stride of m0 
    lw      a2,-68(s0)  # load m1->rows 
    call    dot
    mv      a5,a0
    sw      a5,0(s1)
    lw      a5,-24(s0)
    addi    a5,a5,1
    sw      a5,-24(s0)

inner_loop_end:
    lw   a4, -24(s0)    # load j
    lw   a5, -72(s0)    # load m1->cols 
    blt  a4, a5, inner_loop_body
    lw   a5, -20(s0)    # load i 
    addi a5, a5, 1      # i = i + 1 
    sw   a5, -20(s0)    # store i

outer_loop_end:
    lw a4, -20(s0) # load i 
    lw a5, -56(s0) # load rows of m0
    blt  a4, a5,  inner_loop_start # if i < # width m1, continue inner loop
    nop # delay slot 
    nop # delay slot 
    lw ra, 76(sp) # restore ra
    lw s0, 72(sp) # restore s0 
    lw s1, 68(sp) # restore s1 
    addi sp, sp, 80 # deallocate space for 12 registers 
    jr ra # return

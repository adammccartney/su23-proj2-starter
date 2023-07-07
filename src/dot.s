.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

    # Prologue
    addi sp, sp, -20       # Decrement stack pointer 
    sw s0, 0(sp)           # local result 
    sw s1, 4(sp)           # local i 
    sw s2, 8(sp)           # local j 
    sw s3, 12(sp)          # local count
    sw ra, 16(sp)          # Push return address 

    ebreak
    li t0, 0
    add s0, t0, t0         # result = 0 
    add s1, t0, t0         # i = 0
    add s2, t0, t0         # j = 0 
    add s3, t0, t0         # count = 0

    li t0, 1                 # min num of elements, stride 
    blt a2, t0, err_elem     # if elem < min goto err_elem
    blt a3, t0, err_stride   # if strA < min goto err_stride
    blt a4, t0, err_stride   # if strB < min goto err_stride

loop_start:
    blt s3, a2, loop_body    # if count < elem goto loop_body 
    j loop_end               # else goto loop_end

loop_body: 
    slli t1, s1, 2           # calculate offset A: i * 4
    slli t2, s2, 2           # calculate offset B: j * 4

    add t3, a0, t1           # calculate address of arrA[i]
    add t4, a1, t2           # calculate address of arrB[j]
    lw t5, 0(t3)             # t8 = arrA[i] 
    lw t6, 0(t4)             # t9 = arrB[j]

    mul t0, t5, t6           # a0 = arrA[i] * arrB[j]
    add s0, s0, t0           # result += arrA[i] * arrB[j]

    add s1, s1, a3           # i = i + strideA
    add s2, s2, a4           # j = j + srideB
    addi s3, s3, 1           # count += 1
    j loop_start

loop_end:
    mv a0, s0

    # Epilogue
    lw s0, 0(sp)          # pop saved  
    lw s1, 4(sp)           
    lw s2, 8(sp)           
    lw s3, 12(sp)        
    lw ra, 16(sp)         # pop return address
    addi sp, sp, 20       # Increment stack pointer
    jr ra

err_elem:
    li a0, 36
    j exit

err_stride:
    li a0, 37
    j exit
    

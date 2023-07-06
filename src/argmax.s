.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    addi sp, sp, -8      # Decrement stack pointer  
    sw s0, 0(sp)         # push callee-saved to stack
    sw ra, 4(sp)         # Push return address onto stack 

    ebreak
    li t2, 1                  # t2 = 1 
    blt a1, t2, handle_error  # if a1 < 1, goto handle_error

    li t0, 0              # int i = 0
    lw t1, 0(a0)          # max = arr[0]
    li s0, 0              # result = 0

loop_start:
    blt t0, a1, loop_body  # if i < len goto loop body 
    j loop_end             # else goto loop_end

loop_body:
    slli t2, t0, 2        # calculate offset: i * 4
    add t3, a0, t2        # calculate address of arr[i]
    lw t4, 0(t3)          # load the value at arr[i] into t4

    blt t1, t4, update_max # if max < t4, goto update_max 
    j loop_continue

update_max:
    mv t1, t4               # set max = t3
    mv s0, t0               # set result = i

loop_continue:
    addi t0, t0, 1     # i += 1
    j loop_start

loop_end:
    mv a0, s0        # load result to return register 
    # Epilogue
    lw s0, 0(sp)     # Pop callee-saved
    lw ra, 4(sp)     # Pop the return address off the stack
    addi sp, sp, 8   # Increment stack pointer 
    jr ra            # return result 

handle_error:
    li a0, 36        # Load error code 36 into a0
    ecall            # terminate program

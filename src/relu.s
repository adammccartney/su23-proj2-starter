.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -4       # Decrement stack pointer  
    sw ra, 0(sp)          # Push return address onto stack 
    li t2, 1              # Set t2 to 1
    blt a1, t2, handle_error # if a1 < 2, goto handle_error
    li t3, 0              # int i = 0
loop_start:
    beq t3, a1, loop_end   # if i == len goto loop_end
    slli t4, t3, 2         # calculate offset: i + 4 
    add t4, a0, t4         # Calculate address of vec[i]
    lw t5, 0(t4)           # load the value at vec[i] into t5
    blt t5, zero, skip_set_zero # if vec[i] < 0, goto skip_set_zero 
    j loop_continue        # else, goto loop_continue
skip_set_zero:
    sw zero, 0(t4)         # Set vector[i] to zero
loop_continue:
    addi t3, t3, 1         # i += 1
    j loop_start           # goto loop_start 

loop_end:
    # Epilogue
    lw ra, 0(sp)     # Pop the return address off the stack
    addi sp, sp, 4   # Increment stack pointer 
    jr ra                 # Return

handle_error: 
    li a0, 36     # Load error code 32 into a0
    ecall         # Terminate program 

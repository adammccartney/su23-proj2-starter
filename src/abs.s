.globl abs

.text
# =================================================================
# FUNCTION: Given an int return its absolute value.
# Arguments:
#   a0 (int*) is a pointer to the input integer
# Returns:
#   None
# =================================================================
abs:
    # Prologue

    # PASTE HERE
    # Load number from memory
    lw t0 0(a0)         # t0 <- a[0]
    bge t0, zero, done  # if t0 >= 0; goto done 

    # Negate a0
    sub t0, zero, t0    # t0 <- 0 - t0

    # Store number back to memory
    sw t0 0(a0)

done:
  ret

    # Epilogue

    jr ra

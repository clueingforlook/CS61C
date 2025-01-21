.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue : None

    addi t0, x0, 0        
    ble a1, t0, error
    
loop_start:
    bge t0, a1, loop_end
    slli t1, t0, 2     
    add t1, a0, t1
    lw t2, 0(t1)         

    blt t2, x0, set_zero
    j loop_continue
set_zero:
    sw x0, 0(t1)

loop_continue:
    addi t0, t0, 1
    j loop_start

error:
    addi a1, x0, 78
    j exit2

loop_end:


    # Epilogue

    
	ret
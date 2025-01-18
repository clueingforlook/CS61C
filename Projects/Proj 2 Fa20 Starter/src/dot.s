.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    # Prologue
    ble a2, x0, error_1 
    ble a3, x0, error_2
    ble a4, x0, error_2
    

    add t0, x0, x0          # t0 (int): dot result
    add t1, x0, x0          # t1 (int): current a1 index
    add t2, x0, x0          # t2 (int): current a2 index
    j loop_start

error_1:
    addi a1, x0, 75            
    j exit2                   

error_2:
    addi a1, x0, 76            
    j exit2                

loop_start:
    bge t1, a2, loop_end
    bge t1, a2, loop_end

    mul t3, t1, a3          # t3 = t1 * stride1
    mul t4, t2, a4          # t4 = t2 * stride2

    slli t3, t3, 2          # t3 = t3 * 4
    slli t4, t4, 2          # t4 = t4 * 4
    add t3, t3, a0
    add t4, t4, a1
    lw t5, 0(t3)
    lw t6, 0(t4)
    mul t5, t5, t6
    add t0, t0, t5
    # update index
    addi t1, t1, 1
    addi t2, t2, 1
    j loop_start



loop_end:

    add a0, t0, x0
    # Epilogue

    
    ret

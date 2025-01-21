.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    ble a1, x0, error_72
    ble a2, x0, error_72
    ble a4, x0, error_73
    ble a5, x0, error_73
    bne a2, a4, error_74

    # Prologue
    addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
   
    # store args
    add s0, a0, x0
    add s1, a1, x0
    add s2, a2, x0
    add s3, a3, x0
    add s4, a4, x0
    add s5, a5, x0
    add s6, a6, x0

     # init loop counter
    add s7, x0, x0   # s7 = 0 
    add s8, x0, x0   # s8 = 0
    j outer_loop_start

error_72:
    addi a1, x0, 72          
    j exit2  

error_73:
    addi a1, x0, 73          
    j exit2  

error_74:
    addi a1, x0, 74
    j exit2

outer_loop_start:
    bge s7, s1, outer_loop_end      # if (s7 > m0.row) end outer loop 
    addi s8, x0, 0                  # s8 = 0
    
inner_loop_start:
    bge s8, s5, inner_loop_end      # if (s8 > m1.col) end inner loop

    # prepare args for dot
    mul a0, s7, s2                  # a0 = s0 + s7 * m0.col * 4; set addr of v0
    slli a0, a0, 2
    add a0, a0, s0

    slli a1, s8, 2                  # a1 = m1.addr + s8 * 4; set addr of v1
    add a1, a1, s3
    add a2, s2, x0                  # set vec length to m0.col
    addi a3, x0, 1                  # set stride_1 to 1
    add a4, s5, x0                  # set stride_2 to m1.col

    # call dot product function
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, dot
    lw ra, 0(sp)
    addi sp, sp, 4
    # store dot result
    mul t0, s7, s5
    add t0, t0, s8
    slli t0, t0, 2
    add t0, t0, s6
    sw a0, 0(t0)

    # next loop, counter++
    addi s8, s8, 1
    j inner_loop_start
inner_loop_end:
    addi s7, s7, 1
    j outer_loop_start

outer_loop_end:


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    addi sp, sp, 36
    
    ret

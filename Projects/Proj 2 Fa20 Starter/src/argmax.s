.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue

         
    bgt a1, x0, loop_start
    addi a1, x0, 77
    j exit2

loop_start:
    addi t0, x0, 0      # t0:current index
    lw t4, 0(a0)        # t4:current max value
    add t5, x0, x0      # t5:urrent max index
    j loop_continue
    # slt t5, t4, t3          # if current data is greater than current max, t5 = 1; else: t5 = 0
    # not t5, t5
    # addi t5, t5, 1          # t5 : 1 -> 1111   0 -> 0000

find_new_max_value:
    add t4, t3, x0      # t4:update current max value
    add t5, t0, x0      # t5:update current max index

loop_continue:
    bge t0, a1, loop_end    # t0:current index
    slli t1, t0, 2          # t1:current addr bias
    add t2, a0, t1          # t2:element mem addr
    lw t3, 0(t2)            # t3:current data
    bgt t3, t4, find_new_max_value
    addi t0, t0, 1
    j loop_continue

loop_end:
    add a0, t5, x0
    ret
    # Epilogue


    ret

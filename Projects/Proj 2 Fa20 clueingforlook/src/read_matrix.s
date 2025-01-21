.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -32
    sw s1, 0(sp)
    sw s2, 4(sp)
    sw s3, 8(sp)
    sw s4, 12(sp)
    sw s5, 16(sp)
    sw s6, 20(sp)
    sw s7, 24(sp)
    sw ra, 28(sp)

    # save rows ptr and cols ptr to callee saved registers
    add s1, a1, x0  # save rows ptr to s1
    add s2, a2, x0  # save cols ptr to s2

    # open the file
    add a1, a0, x0  # set a1 to the filename
    li a2, 0        # set a2 to 0(read permission)
    jal ra, fopen   # call fopen
    # fopen error
    addi a2, x0, -1
    beq a0, a2, fopen_error
    add s3, a0, x0  # s3: save file discripter to callee saved register s3

    # read rows of the matrix
    li a3, 4        # a3 = Number of bytes to be read.
    add a2, s1, x0  # a2 = pointer to the buffer you want to write the read bytes to.
    add a1, s3, x0  # a1 = file descriptor
    jal ra, fread
    # fread error
    li t0, 4
    bne a0, t0, fread_error

    # read cols of the matrix
    li a3, 4        # a3 = Number of bytes to be read.
    add a2, s2, x0  # a2 = pointer to the buffer you want to write the read bytes to.
    add a1, s3, x0  # a1 = file descriptor
    jal ra, fread
    # fread error
    li t0, 4
    bne a0, t0, fread_error
    lw s1, 0(s1)    # of rows
    lw s2, 0(s2)    # of columns

    # allocate memory for the matrix using malloc
    mul a0, s1, s2
    slli a0, a0, 2      # set a0 to the # of bytes to allocate heap memory for
    jal ra, malloc
    add s4, a0, x0      # s4: save matrix ptr to s4
    # malloc error
    beq a0, x0, malloc_error

    # read the matrix, one element at a time
    mul s6, s1, s2  # total number of integers
    add s7, x0, x0  # i = 0
    mv s5, s4       # s5: pointer + offset

loop_begain:
    bge s7, s6, loop_end
    # prepare args
    add a1, s3, x0      # a1 = file descriptor
    mv a2, s5           # a2 = pointer + offset
    li a3, 4            # a3 = Number of bytes to be read.     
    jal ra, fread
    # read error
    li t0, 4
    bne a0, t0, fread_error

    addi s7, s7, 1      # increase counter
    addi s5, s5, 4          # update pointer + offset
    j loop_begain

loop_end:
    # close the file
    add a1, s3, x0      # a1 = file descriptor
    jal ra, fclose
    # close file error
    li t0, -1
    beq a0, t0, fclose_error 

    add a0, s4, x0
    # Epilogue
    lw s1, 0(sp)
    lw s2, 4(sp)
    lw s3, 8(sp)
    lw s4, 12(sp)
    lw s5, 16(sp)
    lw s6, 20(sp)
    lw s7, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32

    ret


malloc_error:
    addi a1, x0, 88            
    j exit2
fopen_error:
    addi a1, x0, 90            
    j exit2
fread_error:
    addi a1, x0, 91            
    j exit2
fclose_error:
    addi a1, x0, 92            
    j exit2
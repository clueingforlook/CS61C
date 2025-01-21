.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>


    # check the number of arg
    li t0, 5
    bne a0, t0, exit_89

    # Prologue
    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    
    mv s0, a1       # s0 = argv
    mv s10, a2      # s10 = flag
	# =====================================
    # LOAD MATRICES
    # =====================================
    
    # Load pretrained m0
    li a0, 8
    jal malloc
    beq a0, x0, exit_88
    mv s2, a0           # s2 -> m0.rows, m0,cols
    mv a1, s2           
    addi a2, s2, 4      
    lw a0, 4(s0)
    jal read_matrix
    mv s1, a0           # s1 -> M0 

    # Load pretrained m1
    li a0, 8
    jal malloc
    beq a0, x0, exit_88
    mv s4, a0           # s4 -> m1.rows, m1.cols
    mv a1, s4           
    addi a2, s4, 4      
    lw a0, 8(s0)
    jal read_matrix
    mv s3, a0           # s3 -> M1 

    # Load input matrix
    li a0, 8
    jal malloc
    beq a0, x0, exit_88
    mv s6, a0           # s6 -> INPUT_MATRIX.rows, INPUT_MATRIX.cols
    mv a1, s6           
    addi a2, s6, 4      
    lw a0, 12(s0)
    jal read_matrix
    mv s5, a0           # s5: ptr to INPUT_MATRIX

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # allocate mem for 1st LINEAR LAYER: m0 * input
    lw t0, 0(s2)       # t0 = M0.rows
    lw t1, 4(s6)    # t1 = INPUT.cols
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    beq a0, x0, exit_88
    mv s7, a0       # s7 -> 1st LINEAR LAYER

    # 1st LINEAR LAYER:    m0 * input
    mv a0, s1
    lw a1, 0(s2)
    lw a2, 4(s2)
    mv a3, s5
    lw a4, 0(s6)
    lw a5, 4(s6)
    mv a6, s7
    jal matmul

    # NONLINEAR LAYER: ReLU(m0 * input)
    mv a0, s7
    lw t0, 0(s2)       # t0 = M0.rows
    lw t1, 4(s6)    # t1 = INPUT.cols
    mul a1, t0, t1
    jal relu

    # allocate mem for 2nd LINEAR LAYER:  m1 * ReLU(m0 * input)
    lw t0, 0(s4)       # t0 = M1.rows
    lw t1, 4(s6)    # t1 = INPUT.cols
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    beq a0, x0, exit_88
    mv s8, a0       # s8 -> 2nd LINEAR LAYER

    # 2nd LINEAR LAYER:    m1 * ReLU(m0 * input)
    mv a0, s3           # a0 = ptr to M1
    lw a1, 0(s4)
    lw a2, 4(s4)
    mv a3, s7           # a3 = ptr to ReLU(m0 * input)
    lw a4, 0(s2)        
    lw a5, 4(s6)        
    mv a6, s8
    jal matmul


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s0)   # a0 = argv[4]
    mv a1, s8
    lw a2, 0(s4)    # rows of score 
    lw a3, 4(s6)    # cols of score
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s8
    lw t0, 0(s4)
    lw t1, 4(s6)
    mul a1, t0, t1
    jal argmax
	mv s9, a0

    bne s10, x0, not_print
    # Print classification
    mv a1, s9
    jal print_int

    # Print newline afterwards for clarity
    li a1, '\n'
    jal print_char

not_print:
    # free the space
    mv a0, s1
    jal free
    mv a0, s2
    jal free
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free
    mv a0, s8
    jal free

    mv a0, s9

    # epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    addi sp, sp, 48

    ret

exit_89:
	li a1, 89
    jal exit2
    
exit_88:
	li a1, 88
    jal exit2
.data
    n: .word 20
    teststr:    .string "Hey!\n"
    teststr2:   .string "Yo\n"

    lbracket: .string "["
    rbracket: .string "]"
    comma: .string ","
    backspace: .string "\b"
    newline: .string "\n"
    iformat: .string "%d,"
    xformat: .string "%x\n"

.text

.global main

main:
    li t1, 0
    addi sp, sp, -4
    sw ra, 0(sp)

    # push sp
    lw t0, n
    slli t0, t0, 2
    sub sp, sp, t0

    mv a0, sp           # a0 = &cond
    li t0, 7            # cond.n = 4
    sw t0, 0(a0)
    li t0, 3            # cond.k = 3
    sw t0, 4(a0)
    sw x0, 8(a0)       # cond.returnSize = 0

    call combine
    # a0 = res

    lw a1, 4(a3)    # a1 = cond.k
    lw a2, 8(a3)    # a2 = cond.returnSize
    
    call printAns

    # pop sp
    lw t0, n
    slli t0, t0, 2
    add sp, sp, t0

    # restore ra
    lw ra, 0(sp)
    addi sp, sp, 4

    # exit
    li a0, 0
    ret

memcpy:
    # a0 dest
    # a1 src
    # a2 n
    #slli t5, a2, 0x2
    li t3, 0        # i = 0

mcpyloop:
    lw t4, 0(a1)
    sw t4, 0(a0)

    addi a0, a0, 4
    addi a1, a1, 4
    addi t3, t3, 4
    bne t3, a2, mcpyloop
    ret 

GetLineSize:
    # a0 = res
    # a1 = line
    # a2 = lineSize
    # a3 = cond
    # a4 = idx
    addi sp, sp, -12
    sw ra, 0(sp)
    sw a2, 4(sp)    # lineSize
    sw a4, 8(sp)    # idx
    lw s1, 4(a3)    # s1 = cond->k

    bne a2, s1, GLSrecursive    # if (lineSize != cond->k)
    
PutLineIn:
    # a0 = res
    # a1 = line
    # a2 = lineSize
    # a3 = cond
    # a4 = idx
    addi sp, sp, -24
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)

    lw t2, 20(sp)

    add t1, t2, t1
    add a0, a0, t1      # a0 = res[cond->returnSize]
    lw t2, 4(a3)        # t2 = cond->k

    slli a2, t2, 0x2    # a2 = sizoef(int) * cond->k
    sw a2, 20(sp)       # store offset                      # Here can do some improvement

    call memcpy
    lw a0, 0(sp)        # res
    lw a1, 4(sp)        # line
    lw a2, 8(sp)        # lineSize
    lw a3, 12(sp)       # cond
    lw a4, 16(sp)       # idx
    
    addi sp, sp, 24
    addi t5, t5, 1      # cond->returnSize++
    sw t5, 8(a3)        # store returnSize back
    lw ra, 0(sp)
    addi sp, sp, 12
    ret
    
GLSrecursive:
    mv s2, a2                   # s1 = lineSize
    mv s3, a4                   # int i = idx
    lw t0, 0(a3)                # t0 = cond->n
    
    blt t0, s3, Normalreturn
    #addi t0, t0, 1
GLSloop:
    
    slli t3, s2, 0x2            # t3 = line[lineSize] offset
    add t4, a1, t3              # t4 = line[lineSize] address
    sw s3, 0(t4)                # line[lineSize] = i
    
    # a2, a3 must put in function with plus 1
    addi a2, s2, 1              # lineSize + 1
    addi a4, s3, 1              # i + 1
    
    call GetLineSize
    addi s3, s3, 1              # i++
    sw s3, 8(sp)
    bge t0, s3, GLSloop
    
Normalreturn:
    lw ra, 0(sp)
    addi sp, sp, 12
    lw a2, 4(sp)
    lw a4, 8(sp)

    mv s2, a2
    mv s3, a4

    ret


combine:
    # a0 = &cond
    # 0(a0) = cond->n
    # 4(a0) = cond->k
    # 8(a0) = cond->returnSize


    addi sp, sp, -24
    sw ra, 0(sp)
    mv a3, a0           # a3 = cond
    addi a0, a0, -2000      # a0 = address of **res
    addi a1, a0, -2000    # a1 = address of line[cond->k]   
    li a2, 0            # a2 = lineSize
    li a4, 1            # a4 = 1
    
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)
    sw a4, 20(sp)
    
    call GetLineSize

    lw ra, 0(sp)
    lw a0, 4(sp)        # res
    lw a1, 8(sp)        # line
    lw a2, 12(sp)       # lineSize
    lw a3, 16(sp)       # cond
    lw a4, 20(sp)       # idx
    addi sp, sp, 24
    ret


printAns:

    # a0 = res
    # a1 = k (cond.k)
    # a2 = returnSize (cond.returnSize)
    mv s2, a1                           # return Size = 3
    mv s3, a2                           # k = 4
    addi sp, sp, -4
    sw ra, 0(sp)

    mv s1, a0                   # s1 = res
    la a0, lbracket
    call printf
    li s4, 0                    # int i = 0
    li s5, 0                    # int j = 0
printloop1:

    la a0, lbracket
    call printf

    li s4, 0                    # int j = 0

printloop2:
    lw a1, 0(s1)                # res[i]

    addi s1, s1, 0x4            # res[i][j] address offset
    la a0, iformat
    call printf

    addi s4, s4, 1              # i++
    bne s4, s2, printloop2      # j < returnColumnSizes

    la a0, backspace
    call printf

    la a0, rbracket
    call printf

    la a0, comma
    call printf

    addi s5, s5, 1              # i++
    bne s5, s3, printloop1      # i < returnSize

    la a0, backspace
    call printf

    la a0, rbracket
    call printf

    la a0, newline
    call printf

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

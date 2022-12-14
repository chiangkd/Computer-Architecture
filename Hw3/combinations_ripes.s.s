.data
    n: .word 20
    teststr:    .string "Hey!\n"
    teststr2:   .string "Yo\n"

    lbracket: .string "["
    rbracket: .string "]"
    backspace: .string "\b"
    newline: .string "\n"
    iformat: .string "%d\n"



.text

.global main

main:
    addi sp, sp, -16
    sw ra, 0(sp)
    lw t0, n
    slli t0, t0, 2
    sub sp sp, t0
    mv a0, sp
    #lui a0, 0x14
    #addi a0, sp, -2000      # a0 = &cond
    li t0, 4            # cond.n = 4
    sw t0, 0(a0)
    li t0, 3            # cond.k = 3
    sw t0, 4(a0)
    sw x0, 8(a0)       # cond.returnSize = 0
    


    call combine



    # a0 = res
    # a1 = cond.returnSize
    # a2 = cond.k
    lw a1, 4(a3)
    lw a2, 8(a3)
    
    
    la a0, teststr
    call printf
    call printAns



    li a0, 0
    ret



memcpy:
    # a0 dest
    # a1 src
    # a2 n


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
    #lw t5, 8(a3)      # t5 = cond->returnSize
    #slli t1, t5, 0x2    # t1 = res[cond->returnSize] offset
    add t1, t2, t1
    add a0, a0, t1      # a0 = res[cond->returnSize]
    lw t2, 4(a3)      # t2 = cond->k
    slli a2, t2, 0x2    # a2 = sizoef(int) * cond->k
    sw a2, 20(sp)       # store offset

    
    
    call memcpy
    lw a0, 0(sp)        # res
    lw a1, 4(sp)        # line
    lw a2, 8(sp)       # lineSize
    lw a3, 12(sp)       # cond
    lw a4, 16(sp)       # idx
    
    addi sp, sp, 24
    addi t5, t5, 1      # cond->returnSize++
    sw t5, 8(a3)      # store returnSize back
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
    #addi, s3, s3, 1
    
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
    addi a1, a0, -12    # a1 = address of line[cond->k]   
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
    # a1 = returnSize (cond.returnSize)
    # a2 = returnColumnizes (cond.k)
    mv s2, a1
    mv s3, a2
    addi sp, sp, -4
    sw ra, 0(sp)

    mv s1, a0                   # s1 = res
    la a0, lbracket
    #call printf
    li t0, 0                    # int i = 0
    li t1, 0                    # int j = 0
printloop1:
    la a0, lbracket
    #call printf

    li t1, 0                    # int j = 0

printloop2:
    #slli t2, t1, 0x2            # j offset


    lw a1, 0(s1)                # res[i]
    addi s1, s1, 0x4              # res[i][j] address
    
    la a0, iformat
    #lw a1, 0(s1)
    #call printf

    addi t1, t1, 1              # i++
    bne t1, s3, printloop2      # j < returnColumnSizes

    la a0, rbracket
    #call printf

    addi t0, t0, 1              # i++
    bne t0, s2, printloop1      # i < returnSize


    lw ra, 0(sp)
    addi sp, sp, 4
    ret



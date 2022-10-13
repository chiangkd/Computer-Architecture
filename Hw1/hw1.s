.data
len1: .word 10
len2: .word 5
len3: .word 14
test1: .word 1 1 1 2 3 4 4 5 6 6 
test2: .word 2 2 2 3 5
test3: .word 1 2 2 2 2 2 5 7 7 7 7 7 7 8

bef_msg: .string "Before delete:\n "
aft_msg: .string "After delete:\n "
divider: .string "==================\n "

.text
main:
    la a0, divider
    li a7, 4
    ecall
    ################# test case 1 #################
    la a0, test1        # a0 = arr
    lw a1, len1         # a1 = arr_len

    jal ra, initialize_list      # a0 = return value = struct ListNode head
    jal ra, runtestcase
    
    la a0, divider
    li a7, 4
    ecall
    ################# test case 2 #################
    la a0, test2        # a0 = arr
    lw a1, len2         # a1 = arr_len
    jal ra, initialize_list
    jal ra, runtestcase
    
    la a0, divider
    li a7, 4
    ecall
    ################# test case 3 #################
    la a0, test3        # a0 = arr
    lw a1, len3         # a1 = arr_len
    jal ra, initialize_list
    jal ra, runtestcase
    ###############################################
    la a0, divider
    li a7, 4
    ecall
    j exit

runtestcase:
    # prologue
    addi sp, sp, -8
    sw ra, 0(sp)
    sw a0, 4(sp)
    # print messsage
    # a0 need to handle the print msg for printf system call,
    # so just temporary mv list head to t1
    mv t1, a0        # t1 = list head
    la a0, bef_msg
    li a7, 4
    ecall
    # print end
    
    jal ra, print_list
    
    
    la a0, aft_msg
    li a7, 4
    ecall
    
    lw t1, 4(sp)                    # t1 = list head
    jal ra, deleteDuplicates
    mv t1, s2                    # t1 = list head
    jal ra, print_list
    
    # epilogue
    lw ra, 0(sp)        # back to main
    lw a0, 4(sp)
    addi sp, sp, 8
    jr ra

initialize_list:
    # prologue
    addi sp, sp, -8      # push stack pointer to the bottom
    sw ra, 0(sp)
    
    # body
    addi t0, a1, -1     # t0 = arr_len - 1
    mv t1, a0           # t1 = arr
    lw t2, 0(t1)        # load array value
    
    li s0, 0x20000000   # s0 will handle the address of each list node
    sw s0, 4(sp)        # store list head to stack
       
    jal ra malloc       # struct ListNode *head = malloc 
    
    sw t2, 0(s0)        # head->val = arr[0];
    mv t3, s0           # struct ListNode *c = head;
    
    addi s0, s0, 8 
    li s1, 0            # i == 0
    
    
loop:
    jal ra malloc       # struct ListNode *next = malloc    
    
    addi t1, t1, 4      # push array by 4 (int)
    lw t2, 0(t1)        # arr[i+1]
    sw t2, 0(s0)        # next->val = arr[i+1]
    
    
    sw s0, 4(t3)        # c -> next = next
    addi t3, t3, 8      # push heap 8 byte
    
    addi s1, s1, 1      # i++

    addi s0,s0, 8       # push head,4 bytes for integer, 4 bytes for address
    
    bne s1, t0 loop     # for loop condition
    
    #addi s0,s0,4        # End position
    sw x0, 4(t3)
    
    lw ra, 0(sp)        # load return address
    lw a0, 4(sp)        # load list head address
    addi sp, sp, 8
    
    jr ra

print_list:
    lw a0, 0(t1)        # load value to a0
    li a7, 1            # system call: print int
    ecall
    
    li a0, 9            # tab
    li a7, 11           # print char
    ecall
    
    lw t1, 4(t1)        # t1 = t1->next
    
    bne t1, x0 print_list
    
    li a0, 10           # next line
    li a7, 11           # print char
    ecall
    
    jr ra

deleteDuplicates:
    addi sp, sp, -4
    sw ra 0(sp)        # stored return address
    beq t1, x0, ifnohead    # if(!head), t1 = list head
    li t6, 0                #head_dup = 0
    lw t2, 4(t1)            # node->next
    # while (head->next && head ->val == head->next->val) {
    bne t2,x0 nnexist    # node->next exist
    
remdupnode:
    lw t2 4(t1)        # t2 = n = head -> next
    mv a0, t1          # a0 = c = head

    
    # Now head duplicate is removed
    
    # for(struct ListNode *n = head-> next; n; n = n->next)
    # now use s2 - s11 to handle remain work
    mv s2, t1          # struct ListNode *c = head
    lw s3, 4(s2)       # s3 = n = head->next
    
    ###############################################
    # s2 = list head                              #
    # s3 = c                                      #
    # s4 = n                                      #
    # s5 = npt                                    #
    # use t register to handle all the condition  #
    ###############################################
    mv s3, s2          # s3 = c = head

    lw t1, 4(s2)       # n = head->next
    mv s4, t1
forloop:
    lw t2 4(s4)        # t2 = n->next
    
    bne t2, x0, if1cond1   # n->next exist
    
if1end:
    sw s4, 4(s3)        # c->next = n
    mv s3, s4           # c = n
    lw s4, 4(s4)        # n = n->next
    bne s4, x0, forloop    # n exist
    j forloopexit

if1cond1:
    lw t3, 0(s4)       # n->val
    lw t4, 0(t2)       # n->next->val
    beq t3, t4, if1cond2
    
    j if1end
    
if1cond2:
    lw s5, 4(s4)       # npt = n->next
    
whilecond1:
    bne s5, x0, whilecond1pass    # npt exist
whilenot:
    lw s4 4(s4)        # n = n->next
    j if1end
whilecond1pass:
    lw t2, 0(s4)        # n->val 
    lw t3, 0(s5)        # npt->val

    beq t2, t3, whilecond2
    j whilenot
whilecond2:
    lw s5, 4(s5)        # npt = npt->next
    sw s5, 4(s4)        # n->next = npt

if2cond1:
    bne s5, x0, if2cond1pass
    j whilecond1
if2cond1pass:
    lw t2, 4(s5)        # t2 = npt->next
    bne t2, x0, if2cond2
    j whilecond1    
if2cond2:
    lw t3, 0(s5)        # t3 = npt->val
    lw t4, 0(t2)        # t4 = npt->next->val
    
    beq t3, t4 if2cond3
    j whilecond1
if2cond3:
    mv s4, s5           # n = npt
    lw s5, 4(s5)        # npt = npt->next
    
    j whilecond1

forloopexit:
    bne t6, x0, remhead

enddup:
    # epilogue
    lw ra 0(sp)
    addi sp, sp, 4
    jr ra
    
remhead:
    lw s2 4(s2)
    j enddup
    
nnexist:
    lw t3, 0(t1)            # node->val
    lw t4, 0(t2)            # node->next->val
    beq t3, t4 remnode      # node->val == node->next->val
    
    j remdupnode
    
remnode:
    # t2 = removed node
    li t6, 1                # head_dup = 1
    mv t3, t2               # struct ListNode *c = node
    
    lw t2, 4(t2)            # node = node->next
    
    sw t2, 4(t1)            # store to heap
    
    bne t2, x0, nnexist     # node exist
    
    j remdupnode

ifnohead:
    jr ra                   # return NULL

malloc:
    li a7, 214          # brk system call
    ecall
    jr ra
    
exit:
    li a7, 10           # end the program
    ecall
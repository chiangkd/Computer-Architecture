# RISC-V assembly program to print "Hello World!" to stdout.

.org 0
# Provide program starting address to linker
.global _start

/* newlib system calls */
.set SYSEXIT,  93
.set SYSWRITE, 64

.data

test_1_s: .string "anagram"
test_1_t: .string "nagaram"
test_2_s: .string "rat"
test_2_t: .string "anagram"
test_3_s: .string "tseng"
test_3_t: .string "gnest"
# correct_1:       .string "test_1: Pass\n"
#                  .set t1cor_size, .-correct_1
# not_correct_1:   .string "test_1: Fail\n"
#                  .set t1incor_size, .-not_correct_1
# correct_2:       .string "test_2: Pass\n"
#                  .set t2cor_size, .-correct_2
# not_correct_2:   .string "test_2: Fail\n"
#                  .set t2incor_size, .-not_correct_2
# correct_3:       .string "test_3: Pass\n"
#                  .set t3cor_size, .-correct_3
# not_correct_3:   .string "test_3: Fail\n"
#                  .set t3incor_size, .-not_correct_3

.text

_start: 
#     li a7, SYSWRITE        # "write" system call
#     li a0, 1               #  1 = standard output (stdout)
    jal ra, TEST_1
    jal ra, TEST_2
    jal ra, TEST_3
    j end

TEST_1:
    addi sp, sp, -4
    sw ra, 0(sp)
    la a0, test_1_s        # s(a0) = test_1_s  
    la a1, test_1_t        # t(a1) = test_1_t
    jal ra, isAnagram      # call isAnagram(s(a0), t(a1))
    bne a0, x0, TRUE_1     # if isAnagram(s(a0), t(a1)) == 1 correct
#    li a0, 1               # reload a0 to handle stdout
#    la a1, not_correct_1   # test1 not correct address
#    la a2, t1incor_size    # test1 not correct length
#    ecall
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

TEST_2:
    addi sp, sp, -4
    sw ra, 0(sp)
    la a0, test_2_s        # s(a0) = test_2_s
    la a1, test_2_t        # t(a1) = test_2_t
    jal ra, isAnagram	   # call isAnagram(s(a0), t(a1))
    beq a0, x0, TRUE_2	   # if isAnagram(s(a0), t(a1)) == 0 correct

#    la a1, not_correct_2   # test2 not correct address
#    la a2, t2incor_size    # test not correct length
#    ecall
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

TEST_3:
    addi sp, sp, -4
    sw ra, 0(sp)
    la a0, test_3_s        # s(a0) = test_3_s
    la a1, test_3_t        # t(a1) = test_3_t
    jal ra, isAnagram	   # call isAnagram(s(a0), t(a1))
    bne a0, x0, TRUE_3     # if isAnagram(s(a0), t(a1)) == 1 correct
    li a0, 1               # reload a0 to handle stdout
#    la a1, not_correct_3   # test3 not correct address
#    la a2, t3incor_size    # test3 not correct length
#    ecall
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

TRUE_1:
#    la a1, correct_1     # test1 correct address
#    la a2, t1cor_size    # test1 correct length
#    ecall
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra               # go to example2

TRUE_2:
#    li a0, 1             # reload a0 to handle stdout 
#    la a1, correct_2     # test2 correct address
#    la a2, t2cor_size    # test2 correct length
    ecall
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra              # go to example3

TRUE_3:
#    la a1, correct_3     # test2 correct address
#    la a2, t3cor_size    # test2 correct length
#    ecall
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
    
isAnagram:                  # a0 = s, a1 = t
    addi sp, sp, -104       # get sapce for store int letter_freq[26]
    addi t0, sp, 0          # t0 = letter_freq[0]
    addi t1, x0, 0          # t1 = i = 0
    li t2, 26
LOOP1:                      # int letter_freq[26] = {0};
#    beq t1, t2, GET_FREQ_s  # if i < 26 
    sw x0, 0(t0)            # letter_freq[i] = 0;
    addi t1, t1, 1          # i++;
    addi t0, t0, 4          # letter_freq[i+1]
    blt t1, t2, LOOP1
#    j LOOP1
	
GET_FREQ_s:
    addi t0, sp, 0         # t0 = letter_freq[0]
    addi t1, a0, 0         # t1 = s
#    addi t2, x0, 0         # t2 = i = 0

    
PRECOND1:
    lbu t5, 0(t1)          # t5 = s[0]
    beqz t5, GET_FREQ_F    # if s[0] = 0, break the loop
    addi t2, t1, 1         # t2 = s++
LOOP2:                            # for(  ;s[i] ;i++ )
    addi t5, t5, -97       # s[i] - 'a'
    slli t5, t5, 0x2       # get offset from letter_freq[0] to letter_freq[s[i] - 'a']
    add t5, t5, sp         # t5 = address of letter_freq[s[i] - 'a']
    lw t3, 0(t5)           # t3 = letter_freq[s[i] - 'a']
    addi t3, t3, 1         # letter_freq[s[i] - 'a']++
    sw t3, 0(t5)           # store back
    addi t2, t2, 1         # s++
    lbu t5, -1(t2)         # t5 = s[i]
    bnez t5, LOOP2

#    add  t3, t1, t2         # get address of s[index] from s[0] + 
#    lb t5, 0(t3)            # t5 = s[i]
#    beq t5, x0, GET_FREQ_F # if s[i] ==0 break the loop
#    addi t5, t5, -97         # t5 = s[i] - 'a'
#    slli t5, t5, 2          # get offset form letter_freq[0] to letter_freq[s[i] - 'a']
#    add t5, t5, t0          # get address of letter_freq[s[i] - 'a']
#    lw t3, 0(t5)            # t3 = [freq[s[i] - 'a']]
#    addi t3, t3, 1          # t3 = [freq[s[i] - 'a']] + 1
#    sw t3, 0(t5)            # [freq[s[i] - 'a']] = ([freq[s[i] - 'a']] + 1) 
#    addi t2, t2, 1          # i++
#    j LOOP2


GET_FREQ_F:
    addi t0, sp, 0         # t0 = freq[]
    addi t1, a1, 0         # t1 = t
#    addi t2, x0, 0         # t2 = i = 0

PRECOND2:
    lbu t5, 0(t1)          # t5 = t[0]
    beqz t5, CHECK         # if t[0] = 0, break the loop
    addi t2, t1, 1         # t2 = t++
LOOP3:                      # for(  ;t[i] ;i++ )
    addi t5, t5, -97       # t[i] - 'a'
    slli t5, t5, 0x2       # get offset from letter_freq[0] to letter_freq[t[i] - 'a']
    add t5, t5, sp         # t5 = address of letter_freq[t[i] - 'a']
    lw t3, 0(t5)           # t3 = letter_freq[t[i] - 'a']
    addi t3, t3, -1         # letter_freq[t[i] - 'a']--
    sw t3, 0(t5)           # store back
    addi t2, t2, 1         # t++
    lbu t5, -1(t2)         # t5 = t[i]
    bnez t5, LOOP3


#    add  t3, t1, t2         # get address of t[index]
#    lb t5, 0(t3)            # t5 = t[i]
#    beq t5, x0, CHECK       # if t[i] == 0 break the loop
#    addi t5, t5, -97        # t5 = t[i] - 'a'
#    slli t5, t5, 2          # get offset form letter_freq[0] to letter_freq[t[i] - 'a']
#    add t5, t5, t0        
#    lw t3, 0(t5)            # t5 = [freq[t[i] - 'a']]
#    addi t3, t3, -1         # t3 = [freq[t[i] - 'a']] - 1
#    sw t3, 0(t5)            # [freq[t[i] - 'a']] = ([freq[t[i] - 'a']] - 1) 
#    addi t2, t2, 1          # i++
#    j LOOP3
CHECK:
    addi t0, sp, 0 # t0 = address freq[0]

    addi t1, sp, 104        # 104 = 4 * 26 = the end of the letter_freq[]
LOOP4:                      # for (int i = 0; i < 26; i++)
    #beq t1, t2, TRUE         # i < 26
    lw t3, 0(t0)            # t3 = freq[i];
    bne t3, x0, FALSE       # if freq[i] != 0 break
    addi t0, t0, 4         # freq++
    blt t0, t1, LOOP4
    #j LOOP4

TRUE:
    addi a0, x0, 1          # if pass check return true
    j END_F
FALSE:
    addi a0, x0, 0          # if false return false

END_F:
    addi sp, sp, 104
    jr ra                   # return,  a0 = return value = true or false

end:
    li a7, SYSEXIT      # "exit" syscall
    add a0, x0, 0       # Use 0 return code
    ecall               # invoke syscall to terminate the program
    
.data

test_1_s: .string "anagram"
test_1_t: .string "nagaram"
test_2_s: .string "rat"
test_2_t: .string "anagram"
test_3_s: .string "tseng"
test_3_t: .string "gnest"
correct_1:       .string "test_1: correct"
not_correct_1:   .string "test_1: not correct"
correct_2:       .string "test_2: correct"
not_correct_2:   .string "test_2: not correct"
correct_3:       .string "test_3: correct"
not_correct_3:   .string "test_3: not correct"

.text

main: 
	addi a7, x0, 4
	
	la a0, test_1_s        # s(a0) = test_1_s  
	la a1, test_1_t        # t(a1) = test_1_t
	jal ra, isAnagram      # call isAnagram(s(a0), t(a1))
	bne a0, x0 TRUE_1      # if isAnagram(s(a0), t(a1)) == 1 correct
	la a0,  not_correct_1  # not correct print error
	ecall
TEST_2:
	la a0, test_2_s        # s(a0) = test_2_s
	la a1, test_2_t        # t(a1) = test_2_t
	jal ra isAnagram	   # call isAnagram(s(a0), t(a1))
	beq a0, x0 TRUE_2	   # if isAnagram(s(a0), t(a1)) == 0 correct
	la a0,  not_correct_2  # not correct print error
	ecall
TEST_3:
	la a0, test_3_s        # s(a0) = test_3_s
	la a1, test_3_t        # t(a1) = test_3_t
	jal ra isAnagram	   # call isAnagram(s(a0), t(a1))
	bne a0, x0 TRUE_3      # if isAnagram(s(a0), t(a1)) == 0 correct
	la a0,  not_correct_3  # not correct print error
	j END
	ecall
TRUE_1:
	la a0,  correct_1      # correct print correct
    ecall
	j TEST_2               # go to example2
	
TRUE_2:
	la a0,  correct_2      # correct print correct
    ecall
	j TEST_3               # go to example3
TRUE_3:
	la a0,  correct_3      # correct print correct
    ecall
END: 
	addi a7, x0, 10
	ecall


isAnagram:                  # a0 = s, a1 = t
	addi sp, sp, -104       # get sapce for store int letter_freq[26]
	addi t0, sp, 0          # t0 = letter_freq[0]
	addi t1, x0, 0          # t1 = i = 0
	li t2, 26
LOOP1:                      # int letter_freq[26] = {0};
	beq t1, t2 GET_FREQ_s   # if i < 26 
	sw x0, 0(t0)            # letter_freq[i] = 0;
	addi, t1, t1, 1         # i++;
	addi, t0, t0, 4         # 
	j LOOP1
	
GET_FREQ_s:
	addi, t0, sp, 0         # t0 = letter_freq[0]
 	addi, t1, a0, 0         # t1 = s
	addi, t2, x0, 0         # t2 = i = 0
LOOP2:                            # for(  ;s[i] ;i++ )
	add  t3, t1, t2         # get address of s[index] from s[0] + 
	lb t5, (0)t3            # t5 = s[i]
 	beq, t5, x0, GET_FREQ_F # if s[i] ==0 break the loop
	addi t5, t5 -97         # t5 = s[i] - 'a'
	slli t5, t5, 2          # get offset form letter_freq[0] to letter_freq[s[i] - 'a']
	add t5, t5, t0          # get address of letter_freq[s[i] - 'a']
	lw t3, 0(t5)            # t3 = [freq[s[i] - 'a']]
	addi t3, t3, 1          # t3 = [freq[s[i] - 'a']] + 1
	sw t3, 0(t5)            # [freq[s[i] - 'a']] = ([freq[s[i] - 'a']] + 1) 
	addi t2, t2, 1          # i++
	j LOOP2
GET_FREQ_F:
	addi, t0, sp, 0         # t0 = freq[]
 	addi, t1, a1, 0         # t1 = t
	addi, t2, x0, 0         # t2 = i = 0
LOOP3:                      # for(  ;s[i] ;i++ )
	add  t3, t1, t2         # get address of t[index]
	lb t5, (0)t3            # t5 = t[i]
 	beq, t5, x0, CHECK      # if t[i] == 0 break the loop
	addi t5, t5 -97         # t5 = t[i] - 'a'
	slli t5, t5, 2          # get offset form letter_freq[0] to letter_freq[t[i] - 'a']
	add t5, t5, t0        
	lw t3, 0(t5)            # t5 = [freq[t[i] - 'a']]
	addi t3, t3, -1         # t3 = [freq[t[i] - 'a']] - 1
	sw t3, 0(t5)            # [freq[t[i] - 'a']] = ([freq[t[i] - 'a']] - 1) 
	addi t2, t2, 1          # i++
	j LOOP3
CHECK:
	addi t0, sp, 0 # t0 = address freq[0]
	addi t1, x0, 0 # t1 = i = 0
	li t2, 26
LOOP4:                      # for (int i = 0; i < 26; i++)
	beq t1, t2 TRUE         # i < 26
	lw t3, 0(t0)            # t3 = freq[i];
	bne t3, x0, FALSE       # if freq[i] != 0 break
	addi, t1, t1, 1         # i++;
	addi, t0, t0, 4         # freq + 1
	j LOOP4
	
FALSE:
	addi a0, x0, 0          # if flase return false
	j END_F
TRUE:
	addi a0, x0, 01          # if pass check return true
END_F:
	jr ra                   # return,  a0 = return value = true or false
#include<stdio.h>
#include<time.h>

#define __ARCH_WANT_TIME32_SYSCALLS
int isAnagram(char * s, char * t)
{
    int letter_freq[26] = {0}; //store frequency of every letter

    for (int i = 0; s[i]; i++) {
        letter_freq[s[i] - 'a']++;
    }
    // calculate frequency of every letter of t
    for (int i = 0; t[i]; i++) {
        letter_freq[t[i] - 'a']--;
    }
    // if letter_freq[i] != 0, it mean in letter char(i + 'a') frequency of letter of s and t are not same. 
    for (int i = 0; i < 26; i++) {
        if (letter_freq[i]) 
            return 0;
    }
    return 1; // all of letter of frequency are same
}

int main() {
	char *test_1_s = "anagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagram";
	char *test_1_t = "anagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagramanagram";

	char *test_2_s = "rat";
	char *test_2_t = "anagram";

	char *test_3_s = "tseng";
	char *test_3_t = "gnest";


    clock_t time_start = clock();
    
    if ( 1 == isAnagram(test_1_s, test_1_t)) {
        printf("test_1: correct\n");
    } else {
        printf("test_1: not_correct\n");
    }
    if ( 0 == isAnagram(test_2_s, test_2_t)) {
        // printf("test_2: correct\n");
    } else {
        // printf("test_2: not_correct\n");
    }
    if ( 1 == isAnagram(test_3_s, test_3_t)) {
        // printf("test_3: correct\n");
    } else {
        // printf("test_3: not_correct\n");
    }

    clock_t time_end = clock();

    fprintf(stderr, "clock gettime time = %d ms\n", (time_end - time_start) * 1000/CLOCKS_PER_SEC);

    
}
#include<stdio.h>
#include<time.h>
#include<stdlib.h>
#include<string.h>

#define MAX_MSG_LEN 1000
#define GENRAND64(X) (((X) & 0x7F7F7F7F7F7F7F7F) | 0x6060606060606060)
#define GENRAND8(X)  (((X) & 0x7F) | 0x61)

#define DETECT_NULL(X)         (((X) - 0x0101010101010101) & ~(X) & 0x8080808080808080)
#define DETECT_CHAR(X, MASK)   (DETECT_NULL((X) ^ (MASK)))

static void GenRandString(char *str, int length)
{
    int size = length;
    uint64_t *lptr = (uint64_t *) str;

    while (size >= 8) {
        uint64_t rand64 = (uint64_t) rand() << 32 | rand();
        // printf("in\n");
        *lptr = GENRAND64(rand64);
        // if detected no needed character
        if (DETECT_CHAR(*lptr, 0x6060606060606060) ||\
            DETECT_CHAR(*lptr, 0x7B7B7B7B7B7B7B7B) ||\
            DETECT_CHAR(*lptr, 0x7C7C7C7C7C7C7C7C) ||\
            DETECT_CHAR(*lptr, 0x7D7D7D7D7D7D7D7D) ||\
            DETECT_CHAR(*lptr, 0x7E7E7E7E7E7E7E7E) ||\
            DETECT_CHAR(*lptr, 0x7F7F7F7F7F7F7F7F))
            continue;
        lptr++;
        size -= 8;
    }

    char *cptr = (char *) lptr;

    while (size) {
        *cptr = GENRAND8(rand());
        // if detected no needed character
        if (!(*cptr ^ 0x60) || !(*cptr ^ 0x7B) || !(*cptr ^ 0x7C) || !(*cptr ^ 0x7D) || !(*cptr ^ 0x7E) || !(*cptr ^ 0x7F))
            continue;
        cptr++;
        size--;
    }   
    *cptr = '\0';
}



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
    srand(time(0));

    char* str = malloc(sizeof(char));
    for(int i = 10000; i <= 100000; i = i + 1) {
        GenRandString(str, i);
        clock_t time_start = clock();
        if(isAnagram(str, str)) {
            ;   // print something if needed
        }
        clock_t time_end = clock();
        printf("%d\t%d\n", i, (time_end - time_start) * 1000/CLOCKS_PER_SEC);
    }
}
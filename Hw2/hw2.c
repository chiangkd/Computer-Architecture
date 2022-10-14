#include<stdio.h>
#include<stdlib.h>
#include <stdbool.h>
bool isAnagram(char * s, char * t)
{
    int letter_freq[26] = {0}; //store frequency of every letter
	
    // calculate frequency of every letter of s
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
            return false;
    }
    return true; // all of letter of frequency are same
}

int main() {
	char *test_1_s = "anagram";
	char *test_1_t = "nagaram";

	char *test_2_s = "rat";
	char *test_2_t = "car";

	char *test_3_s = "tseng";
	char *test_3_t = "gnest";
    /*
	printf("test_1 ans is true, got %s \n", isAnagram(test_1_s, test_1_t) ? "true" : "false");
	printf("test_2 ans is false, got %s \n", isAnagram(test_2_s, test_2_t) ? "true" : "false");
	printf("test_3 ans is true, got %s \n", isAnagram(test_3_s, test_3_t) ? "true" : "false");
    */
    if ( 1 == isAnagram(test_1_s, test_1_t)) {
        printf("test_1: correct");
    } else {
        printf("test_1: not_correct");
    }
    if ( 0 == isAnagram(test_2_s, test_2_t)) {
        printf("test_2: correct");
    } else {
        printf("test_2: not_correct");
    }
    if ( 1 == isAnagram(test_3_s, test_3_t)) {
        printf("test_2: correct");
    } else {
        printf("test_2: not_correct");
    }
}
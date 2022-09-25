#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#define LEN1 10
#define LEN2 5
#define LEN3 3


struct ListNode {
    int val;
    struct ListNode *next;
};


/* iteration method */
struct ListNode *deleteDuplicates(struct ListNode *head)
{
    if(!head)
        return NULL;
    int head_dup = 0;
    while(head->next && head->val == head->next->val){
        head_dup = 1;
        head = head->next;
    }
    
    struct ListNode *c = head;  // current
    for(struct ListNode *n = head->next ; n ;n = n-> next) {
        if(n->next && n->val == n->next->val) {
            struct ListNode *npt = n->next; // use to store n->next
            while(npt && n->val == npt->val){
                npt = npt->next;
                n->next = npt;
                if(npt && npt->next && npt->val == npt->next->val) {
                    npt = npt->next;
                    n = npt;
                }
            }
            n = n->next;
        }
        c->next = n;
        c = n;
        if(!n)
            break;
    }
    return head_dup ? head->next : head;
}
struct ListNode* initial_list(struct ListNode *head, int *arr, int arr_len)
{
    struct ListNode *c = head;

    c->val = (int)arr[0];
    for(int i = 0; i < arr_len-1; i++) {
        struct ListNode *next = malloc(sizeof(struct ListNode));
        next->val = arr[i+1];
        c->next = next;
        c = c->next;
    }
    c->next = NULL;
    return head;
}

void print_list(struct ListNode *head)
{   
    while(head){
        printf("%d ", head->val);
        head = head->next;
    }
    printf("\n");
}



int main(){


    int arr1[LEN1] = {1,2,3,3,4,4,5,6,6,7};
    int arr2[LEN2] = {1,1,1,2,3};
    int arr3[LEN3] = {1,2,2};
    struct ListNode *testcase1 = malloc(sizeof(struct ListNode));
    struct ListNode *testcase2 = malloc(sizeof(struct ListNode));
    struct ListNode *testcase3 = malloc(sizeof(struct ListNode));
 
    printf("=== test 1 === \n");
    testcase1 = initial_list(testcase1, arr1, LEN1);

    printf("before delete: \n");
    print_list(testcase1);
    testcase1 = deleteDuplicates(testcase1);
    printf("after delete: \n");
    print_list(testcase1);

    printf("=== test 2 === \n");
    testcase2 = initial_list(testcase2, arr2, LEN2);

    printf("before delete: \n");
    print_list(testcase2);
    testcase2 = deleteDuplicates(testcase2);
    printf("after delete: \n");
    print_list(testcase2);

    printf("=== test 3 === \n");
    testcase3 = initial_list(testcase3, arr3, LEN3);

    printf("before delete: \n");
    print_list(testcase3);
    testcase3 = deleteDuplicates(testcase3);
    printf("after delete: \n");
    print_list(testcase3);


    return 0;
}
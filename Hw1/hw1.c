#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#define LEN1 10
#define LEN2 5
#define LEN3 3

struct ListNode
{
    int val;
    struct ListNode *next;
};

struct ListNode* remNodeandFree(struct ListNode *node)    // free node without re-link
{
    struct ListNode *c = node;
    node = node->next;
    free(c);
    return node;
}

/* iteration method */
struct ListNode *deleteDuplicates(struct ListNode *head)
{
    if (!head)
        return NULL;
    int head_dup = 0;
    while (head->next && head->val == head->next->val) {
        head_dup = 1;
        head = remNodeandFree(head);
    }

    struct ListNode *c = head;
    for (struct ListNode *n = head->next; n; n = n->next) {
        if (n->next && n->val == n->next->val) {
            struct ListNode *npt = n->next;
            struct ListNode *freenode = n;
            while (npt && n->val == npt->val) {
                npt = remNodeandFree(npt);
                n->next = npt;

                if (npt && npt->next && npt->val == npt->next->val) {
                    n = npt;
                    npt = npt->next;
                    free(freenode);
                }
            }
            n = remNodeandFree(n);
        }
        c->next = n;
        c = n;
        if (!n)
            break;
    }
    if(head_dup)
        head = remNodeandFree(head);
    return head;
}
struct ListNode* initial_list(int *arr, int arr_len)
{
    struct ListNode *head = malloc(sizeof(struct ListNode));
    head->val = arr[0];
    struct ListNode *c = head;
    for (int i = 0; i < arr_len - 1; i++) {
        struct ListNode *next = malloc(sizeof(struct ListNode));
        next->val = arr[i + 1];
        c->next = next;
        c = c->next;
    }
    c->next = NULL;
    return head;
}



void print_list(struct ListNode *head)
{
    while (head) {
        printf("%d ", head->val);
        head = head->next;
    }
    printf("\n");
}

void free_list(struct ListNode *head)
{
    while (head) {
        struct ListNode *freenode = head;
        head = head->next;
        free(freenode);
    }
    return;
}

void runTestcase(struct ListNode* testcase)
{
    printf("Before delete: \t");
    print_list(testcase);
    testcase = deleteDuplicates(testcase);
    printf("After delete: \t");
    print_list(testcase);
    free_list(testcase);
}

int main()
{

    int arr1[LEN1] = {1, 2, 3, 3, 4, 4, 5, 6, 6, 7};
    int arr2[LEN2] = {1, 1, 1, 2, 3};
    int arr3[LEN3] = {1, 2, 2};

    struct ListNode *testcase1 = initial_list(arr1, LEN1);
    struct ListNode *testcase2 = initial_list(arr2, LEN2);
    struct ListNode *testcase3 = initial_list(arr3, LEN3);

    runTestcase(testcase1);
    runTestcase(testcase2);
    runTestcase(testcase3);

    return 0;
}
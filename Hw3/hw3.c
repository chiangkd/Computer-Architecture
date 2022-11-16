#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define MAXLEN 184756

struct set {
    int n;
    int k;
    int returnSize;
};

void GetLineSize(int **res, int *line, int lineSize, struct set *cond, int idx)
{
    if (lineSize == cond->k) {
        res[cond->returnSize] = (int *)malloc(sizeof(int) * cond->k);
        memcpy(res[cond->returnSize], line, sizeof(int) * cond->k);
        (cond->returnSize)++;
        return;
    }
    for (int i = idx; i <= cond->n; i++) {
        line[lineSize] = i;
        GetLineSize(res, line, lineSize + 1, cond, i + 1);
    }
}
int** combine(struct set *cond){
    int **res = (int **)malloc(sizeof(int *)* MAXLEN);
    int line[cond->k];
    int lineSize = 0;
    GetLineSize(res, line, lineSize, cond, 1);
    res = realloc(res, sizeof(int*) * cond->returnSize);
    return res;
}

void printAns(int **ans, int returnSize, int returnColumnSizes){
    printf("[");
    for(int i = 0; i < returnSize; i++){
        printf("[");
        for(int j = 0; j < returnColumnSizes; j++){
            printf("%d,", ans[i][j]);
        }
        printf("\b],");
    }
    printf("\b]\n");
}

int main(){
    int returnSize;
    struct set cond={.n=4, .k=3, .0};
    int **res = combine(&cond);
    printAns(res, cond.returnSize, cond.k);

    return 0;
}
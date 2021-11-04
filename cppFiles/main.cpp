#include "SString.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>



int main(void) {
    SString doc;
    char *inputString;
    while(strcmp(inputString, "quit")) {
        scanf("%s", inputString);
        printf("%s", inputString);
        doc.append(inputString);
    }
    doc.print();
}
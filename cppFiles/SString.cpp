#include <stdio.h>
#include <stdlib.h>

class SString {
    struct Character {
        char character;
        struct Character *next;
    };
    
private:
    char empty;
    struct Character *nillPtr;
    struct Character *start ;
    struct Character *end;
public:
    int count;
    SString() {
        nillPtr = (Character *)malloc(sizeof(Character));
        start = nillPtr;
        end = nillPtr;
        empty = '9';
        count = 0;
    }
    
    SString(char *initString) {
        SString();
        int index = 0;
        while (initString[count] != '\0') {
            if (count == 0) {
                start = makeNewCharPtr(initString[index]);
                end = start;
            } else {
                end->next = makeNewCharPtr(initString[index]);
                end = end->next;
            }
            index++;
            count++;
        }
    }

    struct Character *makeNewCharPtr(char newChar ){
        struct Character *ptr = (Character *)malloc(sizeof(Character));
        ptr->next = (Character *)malloc(sizeof(Character));
        ptr->character = newChar;
        ptr->next->next = nillPtr;
        return ptr;
    }

    void print() {
        struct Character *currentPtr = start;
        while (currentPtr->next != nillPtr) {
            printf("%c", currentPtr->character);
            currentPtr = currentPtr->next;
        }
    }
    
    
};


int main(void) {
    char name1[] = "Terence";
    SString name = SString(name1);

}
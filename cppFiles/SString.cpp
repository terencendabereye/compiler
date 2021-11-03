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
    
    SString(char *initString) {
        nillPtr = (Character *)malloc(sizeof(Character));
        //start = nillPtr;
        //end = nillPtr;
        count = 0;
        
        int index = 0;
        while (initString[index] != '\0') {
            if (count == 0) {
                start = makeNewCharPtr(initString[index]);
                end = start;
            } else if (count == 1) {
                start->next = makeNewCharPtr(initString[index]);
                end = start->next;
            } else {
                end->next = makeNewCharPtr(initString[index]);
                end = end->next;
            }
            index++;
            count = index;
        }
    }

    SString(const char *initString) {
        nillPtr = (Character *)malloc(sizeof(Character));
        //start = nillPtr;
        //end = nillPtr;
        count = 0;
        
        int index = 0;
        while (initString[index] != '\0') {
            if (count == 0) {
                start = makeNewCharPtr(initString[index]);
                end = start;
            } else if (count == 1) {
                start->next = makeNewCharPtr(initString[index]);
                end = start->next;
            } else {
                end->next = makeNewCharPtr(initString[index]);
                end = end->next;
            }
            index++;
            count = index;
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
    SString name = SString("Ndabereye");
    name.print();
}
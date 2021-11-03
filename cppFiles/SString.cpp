#include <stdio.h>
#include <stdlib.h>
#include <string.h>

class SString {
public:
    struct Character {
        char character;
        struct Character *next;
    };
    
    struct Character *start ;
    struct Character *end;

    int count;

    SString() {
        count = 0;
        start = (Character *) malloc(sizeof(Character));
        end = start;
    }
    
    SString(char *initString) {
        count = 0;
        
        while (initString[count] != '\0') {
            if (count == 0) {
                start = (Character *) malloc(sizeof(Character));
                start->character = initString[count];
                start->next = (Character *) malloc(sizeof(Character));
                end = start->next;
            } else {
                end->character = initString[count];
                end->next = (Character *) malloc(sizeof(Character));
                end = end->next;
            }
            
            count++;
        }
    }

    SString(const char *initString) {
        count = 0;
        
        while (initString[count] != '\0') {
            if (count == 0) {
                start = (Character *) malloc(sizeof(Character));
                start->character = initString[count];
                start->next = (Character *) malloc(sizeof(Character));
                end = start->next;
            } else {
                end->character = initString[count];
                end->next = (Character *) malloc(sizeof(Character));
                end = end->next;
            }
            
            count++;
        }
    }

    struct Character *makeNewCharPtr(char newChar ){
        struct Character *ptr = (Character *)malloc(sizeof(Character));
        ptr->next = (Character *)malloc(sizeof(Character));
        ptr->character = newChar;
        ptr->next->character = '\0';
        return ptr;
    }

    void print() {
        struct Character *currentPtr = start;
        while (currentPtr != end) {
            printf("%c", currentPtr->character);
            currentPtr = currentPtr->next;
        }
    }
    
    void append(const char *addedString) {
        int index = 0;
        while (addedString[index] != '\0') {
            end->character = addedString[index];
            end->next = (Character *) malloc(sizeof(Character));
            end = end->next;
            index++;
            count ++;
        }
    }
    void append(const char addedChar) {
        end->character = addedChar;
        end->next = (Character *) malloc(sizeof(Character));
        end = end->next;
        count++;
    }

    char *description() {
        char *out = (char *)malloc(count * sizeof(char));
        struct Character *currentPtr = start;
        for (int i=0; i<count; i++) {
            out[i] = currentPtr->character;
            currentPtr = currentPtr->next;
        }
        return out;
    }
    
    bool hasPrefix(const char prefix) {
        if (start->character == prefix) {
            return true;
        } else {
            return false;
        }
    }
    bool hasPrefix(const char *prefix) {
        int index = 0;
        struct Character *currentPtr = start;
        while (prefix[index] != '\0') {
            if (currentPtr->character != prefix[index]){
                return false;
            }
            currentPtr = currentPtr->next;
            index++;
        }
        return true;
    }
    
    struct Character *firstPtrOf(const char testChar) {
        struct Character *currentPtr = start;
        while (currentPtr != end) {
            if (currentPtr->character == testChar) {
                return currentPtr;
            }
            currentPtr = currentPtr->next;
        }
        return NULL;
    }
    
    char *getSubString(struct Character *from, struct Character *to) {
        SString temp;
        while (from != to) {
            temp.append(from->character);
            from = from->next;
        }
        return temp.description();
    }
    char *getSubString(struct Character *from) {
        SString temp;
        temp.append(from->character);
        return temp.description();
    }
    bool contains(const char checkChar) {
        struct Character *currentPtr = start;
        while (currentPtr != end) {
            if(currentPtr->character == checkChar) {
                return true;
            } else {
                currentPtr = currentPtr->next;
            }
        }
        return false;
    }
    bool contains(const char *checkStr) {
        int index = 0;
        int streak = 0;
        int checkStrLength = 0;
        struct Character *temp = start;

        SString checkStrSuper = checkStr;
        checkStrLength = checkStrSuper.count;
        
        while ((temp != end) && (streak < checkStrLength)) {
            if (checkStr[streak] == temp->character) {
                streak++;
            } else {
                streak *= 0;
            }
            temp = temp->next;
        }

        
        if (streak == checkStrLength) {
            return true;
        } else {
            return false;
        }
    }
};


int main(void) {
    SString name = "Terence Ndabereye";
    printf("%d", name.contains("e N"));
    return 0;
}
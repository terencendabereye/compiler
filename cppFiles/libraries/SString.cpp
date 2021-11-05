#include "SString.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>






SString::SString() {
        count = 0;
        start = (Character *) malloc(sizeof(Character));
        end = start;
    }
SString::SString(char *initString) {
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
SString::SString(const char *initString) {
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
SString::~SString() {
        while (start != end) {
            removeFirst();
        }
        removeFirst();
    }
void SString::print() {
        struct Character *currentPtr = start;
        while (currentPtr != end) {
            printf("%c", currentPtr->character);
            currentPtr = currentPtr->next;
        }
    }
void SString::append(const char *addedString) {
        int index = 0;
        while (addedString[index] != '\0') {
            end->character = addedString[index];
            end->next = (Character *) malloc(sizeof(Character));
            end = end->next;
            index++;
            count ++;
        }
    }
void SString::append(const char addedChar) {
        end->character = addedChar;
        end->next = (Character *) malloc(sizeof(Character));
        end = end->next;
        count++;
    }
char *SString::description() {
        char *out = (char *)malloc(count * sizeof(char));
        struct Character *currentPtr = start;
        for (int i=0; i<count; i++) {
            out[i] = currentPtr->character;
            currentPtr = currentPtr->next;
        }
        return out;
    }
bool SString::hasPrefix(const char prefix) {
        if (start->character == prefix) {
            return true;
        } else {
            return false;
        }
    }
bool SString::hasPrefix(const char *prefix) {
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
SString:: Character *SString::firstPtrOf(const char testChar) {
        struct Character *currentPtr = start;
        while (currentPtr != end) {
            if (currentPtr->character == testChar) {
                return currentPtr;
            }
            currentPtr = currentPtr->next;
        }
        return NULL;
    }
char *SString::getSubString(struct Character *from, struct Character *to) {
        SString temp;
        while (from != to) {
            temp.append(from->character);
            from = from->next;
        }
        return temp.description();
    }
char SString::getChar(struct Character *from) {
        SString temp;
        temp.append(from->character);
        return temp.start->character;
    }
bool SString::contains(const char checkChar) {
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
bool SString::contains(const char *checkStr) {
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
SString:: Character *SString::before(struct Character *checkCha) {
        struct Character *current = start;
        struct Character *before = start;
        while (current != checkCha) {
            before = current;
            current = current->next;
        }
        return before;
    }
SString:: Character *SString::after(struct Character *checkCha) {
        if (checkCha == end) {
            return end;
        }
        struct Character *current = start;
        struct Character *after = current->next;
        while (current != checkCha) {
            current = current->next;
            after = current->next;
        }
        return after;
    }
SString:: Character *SString::index(int index) {
        struct Character *current = start;
        int position = 0;
        while ((current != end) && (position != index)) {
            position++;
            current = current->next;
        }
        return current;
    }
void SString::remove(struct Character *toRemove) {
        if (toRemove == start) {
            removeFirst();
        } else if (toRemove == end) {
            removeLast();
        } else {
            struct Character *before = SString::before(toRemove);
            struct Character *after = SString::after(toRemove);
            before->next = after;
            free(toRemove);
        }
        count--;
    }
void SString::removeFirst() {
        struct Character *temp = start;
        start = after(start);
        free(temp);
        count--;
    }
void SString::removeFirst(const int number) {
        for (int i=0; i<number; i++) {
            removeFirst();
        }
    }
void SString::removeLast() {
        remove(before(end));
    }
void SString::removeLast(const int number) {
        for (int i=0; i<number; i++) {
            removeLast();
        }
    }
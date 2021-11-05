#ifndef _SSTRING_HPP
#define _SSTRING_HPP
class SString {
public:
    struct Character {
        char character;
        struct Character *next;
    };
    
    struct Character *start ;
    struct Character *end;

    int count;

    SString();    //initialise 
    SString(char *initString);
    SString(const char *initString);
    ~SString();
    void print();    
    void append(const char *addedString);
    void append(const char addedChar);
    char *description();    
    bool hasPrefix(const char prefix);
    bool hasPrefix(const char *prefix);    
    struct Character *firstPtrOf(const char testChar);    
    char *getSubString(struct Character *from, struct Character *to);
    char getChar(struct Character *from);
    bool contains(const char checkChar);
    bool contains(const char *checkStr);
    struct Character *before(struct Character *checkCha);
    struct Character *after(struct Character *checkCha);
    struct Character *index(int index);
    void remove(struct Character *toRemove);
    void removeFirst();
    void removeFirst(const int number);
    void removeLast();
    void removeLast(const int number);
};

#endif
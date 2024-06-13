#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Symbol{
    char token[100];
    int value;
    struct Symbol* next;
} Symbol;


Symbol* head = NULL;


Symbol* createSymbol(const char* token, int value){
    Symbol* newSymbol = (Symbol*)malloc(sizeof(Symbol));
    //Use strcpy to assign the value of the String to the token
    strcpy(newSymbol->token, token);
    newSymbol->value = value;
    newSymbol->next = NULL;
    return newSymbol;
}

void insertSymbol(const char* token, int value){
    Symbol* newSymbol = createSymbol(token, value);
    newSymbol->next = head;
    head = newSymbol;

    printf("Symbol[token: %s, value: %d] inserted.\n", token, value);
}

void displaySymbolTable(){
    Symbol* current = head;
    printf("\n*****Symbol Table*****\n");

    while(current != NULL){
        printf("Toeken: %s, Value: %d\n", current->token, current->value);
        current = current->next;
    }
    printf("\n");
}


int main(){
    insertSymbol("Test", 1);
    insertSymbol("Hello", 2);
    insertSymbol("World", 2344);

    displaySymbolTable();

    return 0;
}

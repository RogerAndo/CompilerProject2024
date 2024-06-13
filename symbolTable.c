#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct Symbol{
    char token[100];
    int value;
    struct Symbol* next;
} Symbol;

int getLenght();

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
    int count = 1;

    while(current != NULL){
        printf("%d) Token: %s, Value: %d\n", count, current->token, current->value);
        current = current->next;
        count++;
    }

    printf("Length: %d\n", getLenght());
    printf("**********************\n\n");
}

void deleteSymbol(const char* token, int value){
    Symbol* previous = NULL;
    Symbol* current = head;

    while(current != NULL && strcmp(current->token, token) != 0 && current->value != value){
        previous = current;
        current = current->next;
    }

    if(current == NULL){
        printf("Symbol not found!\n");
        return;
    }

    if(previous == NULL){
        head = current->next;
    }else{
        previous->next = current->next;
    }

    free(current);
    printf("Symbol[Token: %s, Value: %d] has been deleted\n", token, value);
}

int getLenght(){
    Symbol* current = head;
    int count = 0;
    while(current != NULL){
        current = current->next;
        count++;
    }
    return count;
}


int main(){
    insertSymbol("Test", 1);
    insertSymbol("Hello", 2);
    insertSymbol("World", 2344);

    displaySymbolTable();

    deleteSymbol("Test", 1);

    displaySymbolTable();

    return 0;
}

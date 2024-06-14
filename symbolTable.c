#include <stdio.h>
#include <stdlib.h>
#include <string.h>


union Value {
    int ival;
    float fval;
} Value;

// Define the type enumeration
enum Type { INT, FLOAT };

typedef struct Symbol{
    char token[100];
    enum Type type;
    union Value value;
    struct Symbol* next;
} Symbol;

int getLenght();

Symbol* head = NULL;

Symbol* createSymbol(const char* token, int type, union Value value){
    Symbol* newSymbol = (Symbol*)malloc(sizeof(Symbol));
    //Use strcpy to assign the value of the String to the token
    strcpy(newSymbol->token, token);
    // newSymbol->value = value;
    if(type){
        newSymbol->type = INT;
        newSymbol->value.ival = value.ival;
    }else{
        newSymbol->type = FLOAT;
        newSymbol->value.fval = value.fval;
    }
    newSymbol->next = NULL;
    return newSymbol;
}

void insertSymbol(const char* token, int type, int ival, float fval){
    union Value v;
    if(type){
        v.ival = ival;
    }else{
        v.fval = fval;
    }
    Symbol* newSymbol = createSymbol(token, type, v);
    newSymbol->next = head;
    head = newSymbol;

    if(type){
        printf("Symbol[token: %s, Type: INT, value: %d] inserted.\n", token, v.ival);
    }else{
        printf("Symbol[token: %s, Type: FLOAT, value: %.2f] inserted.\n", token, v.fval);
    }
}

void displaySymbolTable(){
    Symbol* current = head;
    printf("\n*****Symbol Table*****\n");
    int count = 1;

    while(current != NULL){
        if(current->type == INT){
            printf("%d) Token: %s, Value: %d\n", count, current->token, current->value.ival);   
        }else{
            printf("%d) Token: %s, Value: %.2f\n", count, current->token, current->value.fval);   

        }
        current = current->next;
        count++;
    }

    printf("Length: %d\n", getLenght());
    printf("**********************\n\n");
}

void deleteSymbol(const char* token){
    Symbol* previous = NULL;
    Symbol* current = head;

    //Loop untile element is found
    while(current != NULL && strcmp(current->token, token) != 0){
        previous = current;
        current = current->next;
    }

    //End of the list
    if(current == NULL){
        printf("Symbol not found!\n");
        return;
    }

    if(previous == NULL){//No element in list
        head = current->next;
    }else{
        previous->next = current->next;
    }

    free(current);
    printf("Symbol[Token: %s] has been deleted\n", token);
}

void updateSymbol(const char* token, int type, int ival, float fval){
    Symbol* current = head;

    while(current != NULL){
        printf("Current type %d\n", current->type);

        if(strcmp(current->token, token) == 0){//if 0 the they are equal
            current->type = type;
            if(type == INT){
                current->value.ival = ival;
                printf("Symbol[Token: %s, Type: INT, Value: %d] has been updated\n", token, ival);
            } else {
                current->value.fval = fval;
                printf("Symbol[Token: %s, Type: FLOAT, Value: %.2f] has been updated\n", token, fval);
            }
            printf("Symbol[Token: %s] has been updated\n", token);
            return;
        }
        current = current->next;
    }
    printf("Symbol[Token: %s] not found.\n", token);
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

    insertSymbol("Test", 1, 2, 0.0);
    insertSymbol("Hello", 0, 0, 2.0);
    insertSymbol("World", 1, 2344, 0.0);

    displaySymbolTable();

    deleteSymbol("Test");

    updateSymbol("World", 1, 23, 5.0);

    displaySymbolTable();

    return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TABLE_SIZE 100

union Value
{
    int ival;
    float fval;
} Value;

// Define the type enumeration
enum Type
{
    INT,
    FLOAT
};

typedef struct Symbol
{
    char token[100];
    enum Type type;
    union Value value;
    struct Symbol *next;
} Symbol;

Symbol *symbol_table[TABLE_SIZE];

Symbol *head = NULL;

Symbol *createSymbol(const char *token, int type, union Value value)
{
    Symbol *newSymbol = (Symbol *)malloc(sizeof(Symbol));
    // Use strcpy to assign the value of the String to the token
    strcpy(newSymbol->token, token);
    // newSymbol->value = value;
    if (type)
    {
        newSymbol->type = INT;
        newSymbol->value.ival = value.ival;
    }
    else
    {
        newSymbol->type = FLOAT;
        newSymbol->value.fval = value.fval;
    }
    newSymbol->next = NULL;
    return newSymbol;
}

void insertSymbol(const char *token, int type, int ival, float fval)
{
    union Value v;
    if (type)
    {
        v.ival = ival;
    }
    else
    {
        v.fval = fval;
    }

    Symbol *newSymbol = createSymbol(token, type, v);
    unsigned int index = hash(token);
    newSymbol->next = symbol_table[index];
    symbol_table[index] = newSymbol;

    if (type)
    {
        printf("Symbol[token: %s, Type: INT, value: %d] inserted.\n", token, v.ival);
    }
    else
    {
        printf("Symbol[token: %s, Type: FLOAT, value: %.2f] inserted.\n", token, v.fval);
    }
}

void displaySymbolTable()
{
    printf("\n*****Symbol Table*****\n");
    int count = 0;

    for (int i = 0; i < TABLE_SIZE; i++)
    {
        Symbol *current = symbol_table[i];

        while (current != NULL)
        {
            if (current->type == INT)
            {
                printf("%d) Token: %s, Value: %d\n", ++count, current->token, current->value.ival);
            }
            else
            {
                printf("%d) Token: %s, Value: %.2f\n", ++count, current->token, current->value.fval);
            }
            current = current->next;
        }
    }

    printf("Length: %d\n", count);
    printf("**********************\n\n");
}

void deleteSymbol(const char *token)
{
    unsigned int index = hash(token);
    Symbol *previous = NULL;
    Symbol *current = symbol_table[index];

    // Loop untile element is found
    while (current != NULL)
    {
        if (strcmp(current->token, token) == 0)
        {
            if (previous == NULL)
            { // The node to be deleted is the head of the list
                symbol_table[index] = current->next;
            }
            else
            {
                previous->next = current->next;
            }
            printf("Symbol[Token: %s] has been deleted\n", token);
            free(current->token);
            free(current);
            return;
        }
        previous = current;
        current = current->next;
    }

    // End of the list
    if (current == NULL)
    {
        printf("Symbol[Token: %s] not found!\n", token);
        return;
    }
}

Symbol *lookup_symbol(const char *token)
{
    unsigned int index = hash(token);
    Symbol *current = symbol_table[index];
    while (current != NULL)
    {
        if (strcmp(current->token, token) == 0)
        {
            return &current;
        }
        current = current->next;
    }
    return NULL;
}

void updateSymbol(const char *token, int type, int ival, float fval)
{
    Symbol *symbol = lookup_symbol(token);

    if (symbol != NULL)
    {
        printf("Current type %d\n", symbol->type);
        symbol->type = type;

        if (type == INT)
        {
            symbol->value.ival = ival;
            printf("Symbol[Token: %s, Type: INT, Value: %d] has been updated\n", token, ival);
        }
        else
        {
            symbol->value.fval = fval;
            printf("Symbol[Token: %s, Type: FLOAT, Value: %.2f] has been updated\n", token, fval);
        }
        printf("Symbol[Token: %s] has been updated\n", token);
    }
    else
    {
        printf("Symbol[Token: %s] not found.\n", token);
    }
}

/**
***********Brauchts glabi nit?**********
int getLenght()
{
    Symbol *current = head;
    int count = 0;
    while (current != NULL)
    {
        current = current->next;
        count++;
    }
    return count;
}
*/

unsigned int hash(const char *name)
{
    unsigned int hash = 0;
    while (*name)
    {
        hash = (hash << 5) + *name++;
    }
    return hash % TABLE_SIZE;
}

int main()
{

    insertSymbol("Test", 1, 2, 0.0);
    insertSymbol("Hello", 0, 0, 2.0);
    insertSymbol("World", 1, 2344, 0.0);

    displaySymbolTable();

    deleteSymbol("Test");

    updateSymbol("World", 1, 23, 5.0);

    displaySymbolTable();

    return 0;
}

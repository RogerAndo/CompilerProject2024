#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define TABLE_SIZE 100

typedef union Value
{
    int ival;
    float fval;
} Value;

typedef struct Symbol
{
    char token[100]; // variable name or token
    int type; // 1 for int, 0 for float
    Value value; // value of the symbol
    struct Symbol *next; // pointer to the next symbol in the linked list
} Symbol;

extern Symbol *symbol_table[TABLE_SIZE];

Symbol *createSymbol(const char *token, int type, Value value);
void insertSymbol(const char *token, int type, int ival, float fval);
void displaySymbolTable();
void deleteSymbol(const char *token);
Symbol *lookup_symbol(const char *token);
void updateSymbol(const char *token, int type, int ival, float fval);
unsigned int hash(const char *name);

#endif // SYMBOL_TABLE_H

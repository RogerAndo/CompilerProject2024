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
    char token[100];
    int type;
    Value value;
    struct Symbol *next;
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

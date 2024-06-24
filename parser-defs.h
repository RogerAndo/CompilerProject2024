#ifndef PARSER_DEFS_H
#define PARSER_DEFS_H

typedef struct
{
    int is_int;
    union
    {
        int ival;
        float fval;
    } value;
    char *lexeme;
} YYSTYPE;

#define YYSTYPE_IS_DECLARED 1

#endif // PARSER_DEFS_H

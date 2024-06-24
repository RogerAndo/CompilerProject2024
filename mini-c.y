%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include "symbolTable.h"

void yyerror(const char *s)
{
    fprintf(stderr, "%s\n", s);
    exit(1);
}

int yylex(void);

%}

%union {
    int ival;
    float fval;
    char *lexeme;
}

%token <ival> INUM
%token <fval> FNUM
%token <lexeme> ID
%token INT FLOAT
%token PLUS MINUS MUL DIV 
%token LP RP ASSIGN
%token UNARY_MINUS

//Define precedence and associativity
%right ASSIGN
%right PLUS MINUS
%left MUL DIV

%nonassoc SIGN

%type <ival> expr_int
%type <fval> expr_float
%type <lexeme> id

%start line

%%
line:
      declarations statements
      ;
declarations:

      | declarations declaration
      ;
declaration:
      INT id {
            insertSymbol($2, 1, 0, 0);
      }
      | FLOAT id {
            insertSymbol($2, 0, 0, 0);
      }
      ;
statements:

      | statements statement
      ;
statement:
      id "=" expr_int {
            Symbol *sym = lookup_symbol($1);
            if(sym) {
                  if (sym->type == 1) {
                        sym->value.ival = $3;
                  } else {
                        yyerror("Type mismatch: expected float");
                  }
            } else {
                  yyerror("Undefined variable");
            }
      }
      | id "=" expr_float {
            Symbol *sym = lookup_symbol($1);
            if(sym) {
                  if (sym->type == 0) {
                        sym->value.fval = $3;
                  } else {
                        yyerror("Type mismatch: expected int");
                        $$ = 0;
                  }
            } else {
                  yyerror("Undefined variable");
                  $$ = 0;
            }
      }
      | expr_int {
            printf("Result: %d\n", $1);
      }
      | expr_float {
            printf("Result: %f\n", $1);
      }
      ;
expr_int:
      INUM {
            $$ = $1;
      }
      | id {
            Symbol *sym = lookup_symbol($1);
            if (sym) {
                  if (sym->type = 1) {
                        $$ = sym->value.ival;
                  } else {
                        yyerror("Type mismatch: expected int");
                        $$ = 0.0;
                  }
            } else {
                  yyerror("Undefined variable");
                  $$ = 0.0;
            }
      }
      | expr_int PLUS expr_int {
            $$ = $1 + $3;
      }
      | expr_int MINUS expr_int {
            $$ = $1 - $3;
      }
      | expr_int MUL expr_int {
            $$ = $1 * $3;
      }
      | expr_int DIV expr_int {
            $$ = $1 / $3;
      }
      | LP expr_int RP {
            $$ = $2;
      }
      ;
expr_float:
      FNUM {
            $$ = $1;
      }
      | id {
            Symbol *sym = lookup_symbol($1);
            if (sym) {
                  if (sym->type = 0) {
                        $$ = sym->value.fval;
                  } else {
                        yyerror("Type mismatch: expected float");
                        $$ = 0;
                  }
            } else {
                  yyerror("Undefined variable");
                  $$ = 0;
            }
      }
      | expr_float PLUS expr_float {
            $$ = $1 + $3;
      }
      | expr_float MINUS expr_float {
            $$ = $1 - $3;
      }
      | expr_float MUL expr_float {
            $$ = $1 * $3;
      }
      | expr_float DIV expr_float {
            $$ = $1 / $3;
      }
      | LP expr_float RP {
            $$ = $2;
      }
      ;
id:
      ID {
            $$ = strdup($1);
      }
      ;

%%

	
int main(void)
{
      return yyparse();
}
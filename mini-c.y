%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include "lex.yy.c"

void yyerror(const char *s)
{
    fprintf(stderr, "%s\n", s);
    exit(1);
}


int yylex(void);

typedef struct {
    int is_int;
    union {
        int ival;
        float fval;
    } value;
} YYSTYPE;

#define YYSTYPE_IS_DECLARED 1
%}

%union {
       char* lexeme;			//identifier
       float fval;          //value of an identifier of type float
       int ival;			//value of an identifier of type int
       YYSTYPE val;         //flag to indicate is_int
       }

%token <ival>  int
%token <fval>  float
%token <lexeme> ID
%token UNARY_MINUS

//Define precedence and associativity
%right '+' '-'
%left '*' '/'

%nonassoc SIGN

%type <val> expr
%type <val> line

%start line

%%
line  : expr '\n'      {
                        if($1.is_int) {
                              printf("Result: %d\n", $1.value.ival);
                        } else {
                              printf("Result: %f\n", $1.value.fval)
                        }
                        exit(0);
      }
      | ID '=' expr '\n'{
                        if($3.is_int) {
                              update_symbol(); //TODO w8 for andis implementation
                        } else {
                              update_symbol();
                        }
                        printf("Assigned %s\n", $1);
      };
expr  : expr '+' expr  {
                        if($1.is_int && $3.is_int) {
                              $$.is_int = 1;
                              $$.value.ival = $1.value.ival + $3.value.ival;
                        } else {
                              $$.is_int = 0;
                              $$.value.fval = ($1.is_int ? $1.value.ival : $1.value.fval) + ($3.is_int ? $3.value.ival : $3.value.fval); 
                        }
      }
      | expr '-' expr  {
                        if($1.is_int && $3.is_int) {
                              $$.is_int = 1;
                              $$.value.ival = $1.value.ival - $3.value.ival;
                        } else {
                              $$.is_int = 0;
                              $$.value.fval = ($1.is_int ? $1.value.ival : $1.value.fval) - ($3.is_int ? $3.value.ival : $3.value.fval); 
                        }
      }
      | expr '*' expr  {
                        if($1.is_int && $3.is_int) {
                              $$.is_int = 1;
                              $$.value.ival = $1.value.ival * $3.value.ival;
                        } else {
                              $$.is_int = 0;
                              $$.value.fval = ($1.is_int ? $1.value.ival : $1.value.fval) * ($3.is_int ? $3.value.ival : $3.value.fval); 
                        }
      }
      | expr '/' expr  {
                        if($1.is_int && $3.is_int) {
                              $$.is_int = 1;
                              $$.value.ival = $1.value.ival / $3.value.ival;
                        } else {
                              $$.is_int = 0;
                              $$.value.fval = ($1.is_int ? $1.value.ival : $1.value.fval) / ($3.is_int ? $3.value.ival : $3.value.fval); 
                        }
      }
      | '('expr')'     {$$ = $2;}
      | int            {$$.is_int = 1; $$.value.ival = $1;}
      | float          {$$.is_int = 0; $$.value.fval = $1;}
      | '-' expr       %prec SIGN {
                        $$.is_int = $2.is_int; 
                        if ($2.is_int) {
                              $$.value.ival = -$2.value.ival;
                        } else {
                              $$.value.fval = -$2.value.fval;
                        }
      }
      | ID             {
                        Symbol *symbol = lookup_symbol($1);
                        if(symbol == NULL) {
                              yyerror("Undefined variable");
                        }
                        $$.is_int = (symbol->type == INT);
                        if (symbol->type == INT) {
                              $$.value.ival = symbol->value.ival;
                        } else {
                              $$.value.fval = symbol->.fval;
                        }
      }
      ;

%%

	
int main(void)
{
  return yyparse();}
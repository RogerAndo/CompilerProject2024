%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include "lex.yy.c"
#include "parser-defs.h"
#include "symbolTable.h"

void yyerror(const char *s)
{
    fprintf(stderr, "%s\n", s);
    exit(1);
}

extern YYSTYPE yylval;

int yylex(void);

%}

%union {
    int ival;
    float fval;
    char *lexeme;
}

%token <ival>  INT
%token <fval>  FLOAT
%token <lexeme> ID
%token UNARY_MINUS

//Define precedence and associativity
%right '='
%right '+' '-'
%left '*' '/'

%nonassoc SIGN

%type <yystype> expr
%type <yystype> line

%start line

%%
line  : expr '\n'      {
                        if($1.is_int) {
                              printf("Result: %d\n", $1.value.ival);
                        } else {
                              printf("Result: %f\n", $1.value.fval);
                        }
                        exit(0);
      }
      | ID '=' expr '\n'{
                        if($3.is_int) {
                              update_symbol($1, 1, $3.value.ival, 0.0);
                        } else {
                              update_symbol($1, 0, 0, $3.value.fval);
                        }
                        printf("Assigned %s\n", $1);
      };
expr  : expr '+' expr  {
                        if($1.is_int && $3.is_int) {
                              $$.is_int = 1;
                              $$.value.ival = $1.value.ival + $3.value.ival;
                        } else {
                              $$.is_int = 0;
                              $$.fval = ($1.is_int ? $1.value.ival : $1.value.fval) + ($3.is_int ? $3.value.ival : $3.value.fval); 
                        }
      }
      | expr '-' expr  {
                        if($1.is_int && $3.is_int) {
                              $$.is_int = 1;
                              $$.value.ival = $1.value.ival - $3.value.ival;
                        } else {
                              $$.is_int = 0;
                              $$.fval = ($1.is_int ? $1.value.ival : $1.value.ival) - ($3.is_int ? $3.value.ival : $3.value.fval); 
                        }
      }
      | expr '*' expr  {
                        if($1.is_int && $3.is_int) {
                              $$.is_int = 1;
                              $$.value.ival = $1.value.ival * $3.value.ival;
                        } else {
                              $$.is_int = 0;
                              $$.value.fval = ($1.is_int ? $1.value.ival : $1.value.ival) * ($3.is_int ? $3.value.ival : $3.value.fval); 
                        }
      }
      | expr '/' expr  {
                        if($1.is_int && $3.is_int) {
                              $$.is_int = 1;
                              $$.value.ival = $1.value.ival / $3.value.ival;
                        } else {
                              $$.is_int = 0;
                              $$.value.fval = ($1.is_int ? $1.value.ival : $1.value.ival) / ($3.is_int ? $3.value.ival : $3.value.fval); 
                        }
      }
      | '('expr')'     {$$ = $2;}
      | INT            {$$.is_int = 1; $$.value.ival = $1;}
      | FLOAT          {$$.is_int = 0; $$.value.fval = $1;}
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
                        $$.is_int = (symbol->type == 1);
                        if (symbol->type == 1) {
                              $$.value.ival = symbol->value.ival;
                        } else {
                              $$.fval = symbol->value.fval;
                        }
      }
      ;

%%

	
int main(void)
{
      return yyparse();
}
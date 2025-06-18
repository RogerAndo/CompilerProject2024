%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include "symbolTable.h"
#include "expr.h"

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
    struct expr *expression;
}

%token <ival> INUM
%token <fval> FNUM
%token <lexeme> ID
%token INT FLOAT
%token PLUS MINUS MUL DIV 
%token LP RP ASSIGN
%token EOL

//Define precedence and associativity
%left PLUS MINUS
%left MUL DIV
%right ASSIGN
%nonassoc SIGN

%type <expression> expr
%type <lexeme> id

%start line

%%
line:
      /* empty production */
    | line item
    ;
item:
      declaration EOL
    | statement EOL
    ;
declaration:
      INT id {
            insertSymbol($2, 1, 0, 0.0);
            free($2);
      }
      | FLOAT id {
            insertSymbol($2, 0, 0, 0.0);
            free($2);
      }
      ;
statement:
      id ASSIGN expr {
            Symbol *sym = lookup_symbol($1);
            if(sym) {
                  if (sym->type == 1) {
                        if($3->type == 1) {
                              sym->value.ival = $3->value.ival;
                              printf("Assign %s: %d\n", $1, $3->value.ival);
                        } else {
                              yyerror("Type mismatch: expected int received float");
                        }               
                  } else if(sym->type == 0) {
                        if($3->type == 0) {
                              sym->value.fval = $3->value.fval;
                              printf("Assign %s: %f\n", $1, $3->value.fval);
                              fflush(stdout);
                        } else {
                              sym->value.fval = (float)$3->value.ival;
                        }
                  } else {
                        yyerror("Type mismatch");
                  }
            } else {
                  yyerror("Undefined variable");
            }
            free($1);
            free($3);
      }
      | expr {
            if( $1->type == 1) {
                  printf("Result: %d\n", $1->value.ival);
                  fflush(stdout);
            } else {
                  printf("Result: %f\n", $1->value.fval);
                  fflush(stdout);
            }
            free($1);
      }
      ;
expr:
      INUM {
            $$ = malloc(sizeof(struct expr));
            $$->value.ival = $1;
            $$->type = 1;
      }
      | FNUM {
            $$ = malloc(sizeof(struct expr));
            $$->value.fval = $1;
            $$->type = 0;
      }
      | id {
            Symbol *sym = lookup_symbol($1);
            if (sym) {
                  $$ = malloc(sizeof(struct expr));
                  if (sym->type == 1) {
                        $$->value.ival = sym->value.ival;
                        $$->type = 1;
                  }else if (sym->type == 0) {
                        $$->value.fval = sym->value.fval;
                        $$->type = 0;
                  } else {
                        yyerror("Type mismatch");
                  }
            } else {
                  yyerror("Undefined variable");
            }
      }
      | expr PLUS expr {
            $$ = malloc(sizeof(struct expr));
            if( $1->type == 1 && $3->type == 1) {
                  $$->value.ival = $1->value.ival + $3->value.ival;
                  $$->type = 1;
            } else if ($1->type == 0 && $3->type == 1) {
                  $$->value.fval = $1->value.fval + $3->value.ival;
                  $$->type = 0;
            } else if ($1->type == 1 && $3->type == 0) {
                  $$->value.fval = $1->value.ival + $3->value.fval;
                  $$->type = 0;
            } else {
                  $$->value.fval = $1->value.fval + $3->value.fval;
                  $$->type = 0;
            }
            free($1);
            free($3);
      }
      | expr MINUS expr {
            $$ = malloc(sizeof(struct expr));
            if( $1->type == 1 && $3->type == 1) {
                  $$->value.ival = $1->value.ival - $3->value.ival;
                  $$->type = 1;
            } else if ($1->type == 0 && $3->type == 1) {
                  $$->value.fval = $1->value.fval - $3->value.ival;
                  $$->type = 0;
            } else if ($1->type == 1 && $3->type == 0) {
                  $$->value.fval = $1->value.ival - $3->value.fval;
                  $$->type = 0;
            } else {
                  $$->value.fval = $1->value.fval - $3->value.fval;
                  $$->type = 0;
            }
            free($1);
            free($3);
      }
      | expr MUL expr {
            $$ = malloc(sizeof(struct expr));
            if( $1->type == 1 && $3->type == 1) {
                  $$->value.ival = $1->value.ival * $3->value.ival;
                  $$->type = 1;
            } else if ($1->type == 0 && $3->type == 1) {
                  $$->value.fval = $1->value.fval * $3->value.ival;
                  $$->type = 0;
            } else if ($1->type == 1 && $3->type == 0) {
                  $$->value.fval = $1->value.ival * $3->value.fval;
                  $$->type = 0;
            } else {
                  $$->value.fval = $1->value.fval * $3->value.fval;
                  $$->type = 0;
            }
            free($1);
            free($3);
      }
      | expr DIV expr {
            $$ = malloc(sizeof(struct expr));
            if( $1->type == 1 && $3->type == 1) {
                  $$->value.ival = $1->value.ival / $3->value.ival;
                  $$->type = 1;
            } else if ($1->type == 0 && $3->type == 1) {
                  $$->value.fval = $1->value.fval / $3->value.ival;
                  $$->type = 0;
            } else if ($1->type == 1 && $3->type == 0) {
                  $$->value.fval = $1->value.ival / $3->value.fval;
                  $$->type = 0;
            } else {
                  $$->value.fval = $1->value.fval / $3->value.fval;
                  $$->type = 0;
            }
            free($1);
            free($3);
      }
      | LP expr RP {
            $$ = $2;
      }
      | MINUS expr %prec SIGN {
            $$ = malloc(sizeof(struct expr));
            $$->type = $2->type;
            if($2->type == 1) {
                  $$->value.ival = -$2->value.ival;
            } else {
                  $$->value.fval = -$2->value.fval;
            }
            free($2);
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
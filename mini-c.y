%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>

void yyerror(const char *s)
{
    fprintf(stderr, "%s\n", s);
    exit(1);
}


int yylex(void);
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

//Define precedence abd associativity
%right '+' '-'
%left '*' '/'

%nonassoc SIGN

%type <val> expr
%type <val> line

%start line

%%
line  : expr '\n'      {$$ = $1; printf("Result: %f\n", $$); exit(0);}
      ;
expr  : expr '+' expr  {$$ = $1 + $3;}
      | expr '-' expr  {$$ = $1 - $3;}
      | expr '*' expr  {$$ = $1 * $3;}
      | expr '/' expr  {$$ = $1 / $3;}
      | '('expr')'     {$$ = $2;}
      | int            {$$.is_int = 1;
                        $$.value.ival = $1;}
      | float          {$$.is_int = 0;
                        $$.value.fval = $1;}
      | '-' expr       %prec SIGN {$$ = -$2;}
      | ID             {$$=0; printf("IDENTIFICATORE = %s\n",$1);}
      ;

%%

#include "lex.yy.c"
	
int main(void)
{
  return yyparse();}
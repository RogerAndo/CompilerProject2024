%option noyywrap
%{
#include <stdlib.h>
#include <string.h>
#include "parser-defs.h"
#include "mini-c.tab.h"
%}

digit  [0-9]

int {digit}+
float {digit}+(\.{digit}+)

letter [a-zA-Z]
id {letter}+
%%

{int} {yylval.value.ival = atoi(yytext); return INT;}
{float} {yylval.value.fval = atof(yytext); return FLOAT;}
{id} {yylval.lexeme = strdup(yytext); return ID;}

"+" {return '+';}
"-" {return '-';}
"*" {return '*';}
"/" {return '/';}
"(" {return '(';}
")" {return ')';}
[ \t\n\r]+  /* skip whitespace */
.  { /* any other character */ }

%%

%option noyywrap
%{
#include <stdlib.h>
#include <string.h>
#include "mini-c.tab.h"
%}

digit  [0-9]

letter [a-zA-Z]
id {letter}+
%%

"int" {return INT;}
"float" {return FLOAT;}
{digit}+ {yylval.ival = atoi(yytext); return INUM;}
{digit}+(\.{digit}+) {yylval.fval = atof(yytext); return FNUM;}
{id} {yylval.lexeme = strdup(yytext); return ID;}

"=" {return ASSIGN;}
"+" {return PLUS;}
"-" {return MINUS;}
"*" {return MUL;}
"/" {return DIV;}
"(" {return LP;}
")" {return RP;}
[ \t\n\r]+  /* skip whitespace */
.  { fprintf(stderr, "Unexpected character: %s\n", yytext); }

%%

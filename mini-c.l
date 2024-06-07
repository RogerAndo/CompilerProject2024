%option noyywrap
%{
#include <stlib.h>
%}

digit  [0-9]

int {digit}+
float {digit}+(\.{digit}+)

letter [a-zA-Z]
id {letter}+
%%

{int} {yylval.value = atof(yytext); return int;}
{float} {yylval.value = atof(yytext); return float;}

{id} {yylval.lexeme = yytext; return id;}

"+" {return '+';}
"-" {return '-';}
"*" {return '*';}
"/" {return '/';}

[ \t\n\r]+  /* skip whitespace */
.  { /* any other character */ }

%%

%{ 
#include <stdio.h>
#include <ctype.h> 
#include "y.tab.h"
extern int yylval;
%}
ZERO "0"
FLOAT [0-9]+"."[0-9]*
DIGIT [1-9][0-9]*|ZERO
IDENTIFIER [a-zA-Z_][a-zA-Z0-9_]*
KW_FILE [a-zA-Z0-9]+"."[a-zA-Z]+
KW_COMMAND \;{2}[a-zA-Z0-9.+-/* ]*
%%
and		{return KW_AND;}
or 	        {return KW_OR;}
not          	{return KW_NOT;}
list         	{return KW_LIST;}
disp         	{return KW_DISP;}
load         	{return KW_LOAD;}
false        	{return KW_FALSE;}
equal        	{return KW_EQUAL;}
less         	{return KW_LESS;}
if           	{return KW_IF;}
exit         	{return KW_EXIT;}
nil          	{return KW_NIL;}
true         	{return KW_TRUE;}
append       	{return KW_APPEND;}
concat       	{return KW_CONCAT;}
set		{return KW_SET;}
deffun 	{return KW_DEFFUN;}
for          	{return KW_FOR;}
while		{return KW_WHILE;}
{KW_FILE}	{ return KW_FILE;}
{KW_COMMAND}	{return KW_COMMENT; }
{IDENTIFIER}	{return IDENTIFIER;}
{DIGIT} 	{yylval = atoi(yytext); return INTEGER;}
{FLOAT}	{yylval = atof(yytext); return KW_FLOAT;}
"+"		{return OP_PLUS;}
"-"		{return OP_MINUS;}
"/"		{return OP_DIV;}
"*"		{return OP_MULT;}
"**"	{return OP_DBLMULT;}
"("		{return OP_OP;}
")"		{return OP_CP;}
","		{return OP_COMMA;}
"\""		{return OP_OC;}
%% 
int yywrap(){return 1;} 

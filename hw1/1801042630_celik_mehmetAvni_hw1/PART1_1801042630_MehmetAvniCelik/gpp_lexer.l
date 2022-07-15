%{ 
#include <stdio.h>
#include <ctype.h>
int cont = -1;
FILE * out_ptr;
int a = 0, b = 0;
%} 
ENTER [\n]
ZERO [0]
ERRORVALUE [0][0-9]*
DIGIT [0-9]
DIGIT_START [1-9]
KEYWORDS and|or|not|equal|less|nil|list|append|concat|set|deffun|for|if|exit|load|disp|true|false
IDENTIFIER [a-z][a-z0-9]*
COMMAND \;{2}[a-zA-Z0-9.+-/* ]*
ERRORSYN [0-9][a-z]*

%%
{ZERO}				{fprintf(out_ptr,"VALUE\n");}
{COMMAND}			{fprintf(out_ptr,"COMMENT\n");}
{KEYWORDS}			{
					int a=0,b=3;
					char arr[100];
					arr[0] = 'K';
					arr[1] = 'W';
					arr[2] = '_';
					while(sizeof(yytext)>a)
					{
						arr[b] = toupper(yytext[a]);
						a++;
						b++;
					}
					fprintf(out_ptr,"%s\n", arr);
				} 
{IDENTIFIER}			{fprintf(out_ptr,"IDENTIFIER\n");}
{ERRORVALUE}			{fprintf(out_ptr,"SYNTAX ERROR. VALUE CAN NOT START WITH 0.\n");} 
{DIGIT}+{IDENTIFIER}		{fprintf(out_ptr,"SYNTAX ERROR. SYNTAX CAN NOT BE TOKENIZED.\n");}
")"				{fprintf(out_ptr,"OP_CP\n");cont = 1;}
"("				{fprintf(out_ptr,"OP_OP\n");}
","				{fprintf(out_ptr,"OP_COMMA\n");}
"\""				{fprintf(out_ptr,"OP_OC\n");}
"+"				{fprintf(out_ptr,"OP_PLUS\n");}
"-"				{fprintf(out_ptr,"OP_MINUS\n");}
"*"				{fprintf(out_ptr,"OP_MULT\n");}
"**"				{fprintf(out_ptr,"OP_DBLMULT\n");}
"/"				{fprintf(out_ptr,"OP_DIV\n");}
{DIGIT_START}+ 		{fprintf(out_ptr,"VALUE\n");}
{DIGIT_START}+"."{DIGIT}*	{fprintf(out_ptr,"VALUE\n");}
[-]*{DIGIT_START}*{DIGIT}+ 	{fprintf(out_ptr,"VALUE\n");}

[" "] {}

{ENTER} {
if (cont == 1){
	cont = -1;
	fclose(out_ptr);
	out_ptr = fopen("result.txt","a");
}
else{ return 0;}
}
%% 
int yywrap(){} 

void interpreter(char * file)
{
	FILE * file_ptr;
	//if filename comes as an arguament
	if(file != NULL)
	{
		file_ptr = fopen(file, "r");
		yyin = file_ptr;
		yylex();
		fclose(file_ptr);
		return;
	}
	//if filename doesnt come as an arguament
	yylex();
}

////////////////////////////////////
int main(int argc, char *argv[]){
	char *myFile = NULL;
	out_ptr = fopen("result.txt","w+");
	if(argc == 2){
		myFile = (char*) malloc(sizeof(char));
		sscanf(argv[1],"%s",myFile);
	}
	interpreter(myFile);
	fclose(out_ptr);
	return 0; 
}
//////////////////////////////////// 


%{
#include <stdio.h>
#include <math.h>
#include <string.h>

int terminate = 0;
int checkPoint1=0,checkPoint2=0,checkPoint3=0;
int input1  = 0;
int input2  = 0;
int list[100];

%}
%start START
%token KW_AND KW_OR KW_NOT KW_LIST KW_DISP KW_LOAD KW_FALSE KW_SET KW_SETQ KW_DEFFUN KW_DEFVAR
%token KW_EQUAL KW_LESS KW_IF KW_EXIT KW_NIL KW_TRUE KW_APPEND KW_CONCAT KW_FOR KW_FLOAT
%token OP_PLUS OP_MINUS OP_DIV OP_MULT OP_DBLMULT OP_OP OP_CP OP_COMMA OP_OC OP_CC
%token COMMA NUMBER IDENTIFIER KW_WHILE INTEGER KW_FILE KW_COMMENT KW_LISTQUOTES 

%%
START:| INPUT{
	if (checkPoint3 == 0 && checkPoint2 == 1){
		checkPoint2 = 0;
		printf("Syntax OK.\n");
		if ($$ == 1)	{printf("Result: T\n", $$);}
		else		{printf("Result: NIL\n",$$);}
	}
	else if (checkPoint3 == 0 && checkPoint1 == 1){
		checkPoint1 = 0;
		printf("Syntax OK.\n");
		printf("Result: ");
		listing(input1, list);
		input1 = 0;
		input2 = 0;
	}
	else if (checkPoint3 == 0)
	{
		printf("Syntax OK.\n");
		printf("Result: %d\n",$$);
	}
	printf( "\n");
	return 1;
};
////////////////////////////////////////////////////////////////
INPUT: EXPLISTI | EXPI | EXPB {checkPoint2 = 1;};
IDLIST: OP_OP identifierlist OP_CP;
identifierlist: identifierlist IDENTIFIER | IDENTIFIER;
////////////////////////////////////////////////////////////////
EXPB: 
  OP_OP KW_AND EXPB EXPB OP_CP {$$ = $3 && $4;}			| OP_OP KW_OR EXPB EXPB OP_CP {$$ = $3 || $4;}
| OP_OP KW_EQUAL EXPB EXPB OP_CP {$$ = ($3 == $4);} | OP_OP KW_EQUAL EXPI EXPI OP_CP {$$ = ($3 == $4);}
| OP_OP KW_LESS EXPI EXPI OP_CP {$$ = ($3 < $4);}		| OP_OP KW_NOT EXPB OP_CP {$$ != $3;}
| binv {$$=$1;};
////////////////////////////////////////////////////////////////
LISTVALUE:
  KW_LISTQUOTES VALUES OP_CP{	checkPoint1 = 1; if (input2 == 0){input2 = input1;}}
| KW_LISTQUOTES OP_CP{$$ = 0; checkPoint1 = 1; input1 = 0;}
| KW_NIL {$$ = 0;};
////////////////////////////////////////////////////////////////
EXPLISTI: 
  OP_OP KW_CONCAT EXPLISTI EXPLISTI OP_CP {$$ = 1; checkPoint1 = 1;}
| LISTVALUE {$$ = 1;};
////////////////////////////////////////////////////////////////
binv:
  KW_TRUE {$$ = 1;}	| KW_FALSE {$$ = 0;};
////////////////////////////////////////////////////////////////
EXPI:
  OP_OP KW_DEFVAR IDENTIFIER EXPI OP_CP {$$ = $4;}
| OP_OP OP_PLUS EXPI EXPI OP_CP {$$ = $3 + $4;}
| OP_OP OP_MINUS EXPI EXPI OP_CP {$$ = $3 - $4;}
| OP_OP OP_MULT EXPI EXPI OP_CP {$$ = $3 * $4;}
| OP_OP OP_DBLMULT EXPI EXPI OP_CP {$$ = pow($3, $4);}
| OP_OP OP_DIV EXPI EXPI OP_CP {$$ = $3 / $4;}
| OP_OP KW_SET IDENTIFIER EXPI OP_CP { $$ = $4;}
| OP_OP KW_SETQ IDENTIFIER EXPI OP_CP { $$ = $4;}
| OP_OP IDENTIFIER EXPLISTI OP_CP {$$ = $3; checkPoint1 = 1;}
| OP_OP KW_DEFFUN IDENTIFIER IDLIST EXPLISTI OP_CP {$$ = $5; checkPoint1 = 1;}
| OP_OP KW_IF EXPB EXPLISTI OP_CP {$$ = $3; 
		if (!$3){
			list[0] = NULL;
			input1 = 0;
		}
		checkPoint1 = 1;}
| OP_OP KW_FOR OP_OP IDENTIFIER EXPI EXPI OP_CP EXPLISTI OP_CP {checkPoint1 = 1;}
| OP_OP KW_WHILE EXPB EXPLISTI OP_CP {$$ = $3;
	checkPoint1  = 1;
	if(!$3){
		input1 = 0;
		list[0] = NULL;
	}
}
| OP_OP KW_LIST VALUES OP_CP {$$ = 1; checkPoint1 = 1;}
| OP_OP KW_EXIT OP_CP {printf("Program Terminated.\n"); terminate = 1; return 1;}
| OP_OP KW_DISP EXPI OP_CP {$$ = 1;}
| OP_OP KW_LOAD OP_OC KW_FILE OP_OC OP_CP {$$ = 1;}
| IDENTIFIER {$$ = 1;}
| KW_COMMENT {printf("KW_COMMENT\n"); return 1;}
| INTEGER {$$ = $1;};
////////////////////////////////////////////////////////////////
VALUES:
  VALUES INTEGER {list[input1++] = $2;}
| INTEGER {list[input1++] = $1;}
| KW_NIL {$$ = 0;};
%%
////////////////////////////////////////////////////////////////
int listing(int len, int list[]){
	printf("(");
	for (int i = 0; i < len; ++i)
	{
		if (i != len - 1){
			printf("%d ",list[i]);
		}
		else{
			printf("%d",list[i]);
		}
	}
	printf(")\n");
}
////////////////////////////////////////////////////////////////
int yyerror(const char *c){
	printf("SYNTAX ERROR. Expression not recognized.\n");
	terminate=1;
}
////////////////////////////////////////////////////////////////
int main(int argc, char *argv[])
{
  while(terminate == 0){
			yyparse();
	}
	return 0;
}
////////////////////////////////////////////////////////////////


make:
	lex gpp_interpreter.l
	yacc -d gpp_interpreter.y
	gcc lex.yy.c y.tab.c -w -lm -o gpp_interpreter.out
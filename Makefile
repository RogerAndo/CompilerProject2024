all:
		flex -l mini-c.l
		bison -vd mini-c.y
		gcc lex.yy.c mini-c.tab.c symbolTable.c -o mini-c -lfl
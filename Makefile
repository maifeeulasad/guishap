all:
	#flex --debug guishap.l
	flex guishap.l
	#bison -d --debug guishap.y
	bison -t -d guishap.y
	g++ lex.yy.c guishap.tab.c -lstdc++fs -o guishap.out
clear:
	rm -rf guishap.tab.c guishap.tab.h
	rm -rf lex.yy.c
	rm -rf guishap.out
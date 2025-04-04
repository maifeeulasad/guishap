CC = gcc
CXX = g++
FLEX = flex
BISON = bison
WAT2WASM = wat2wasm

all: guishap.wasm

guishap.wasm: guishap.wat
	$(WAT2WASM) guishap.wat -o guishap.wasm

guishap.wat: guishap.out
	./guishap.out > guishap.wat

guishap.out: lex.yy.c guishap.tab.c codegen.c
	$(CXX) lex.yy.c guishap.tab.c codegen.c -o guishap.out

lex.yy.c: guishap.l
	$(FLEX) guishap.l

guishap.tab.c: guishap.y
	$(BISON) -d guishap.y

clean:
	rm -f lex.yy.c guishap.tab.* guishap.out *.wasm *.wat
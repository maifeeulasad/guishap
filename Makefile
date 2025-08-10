CC = gcc
CXX = g++
FLEX = flex
BISON = bison
WAT2WASM = wat2wasm

all: guishap.out

guishap.wasm: guishap.wat
	$(WAT2WASM) guishap.wat -o guishap.wasm

guishap.wat: guishap.out
	echo "" | ./guishap.out > guishap.wat

guishap.out: lex.yy.c guishap.tab.c codegen.c
	$(CXX) lex.yy.c guishap.tab.c codegen.c -o guishap.out

lex.yy.c: guishap.l
	$(FLEX) guishap.l

guishap.tab.c: guishap.y
	$(BISON) -d guishap.y

wasm: guishap.wasm

test: guishap.out
	@echo "🧪 Running comprehensive test suite..."
	@./run_tests.sh
	@echo "✅ All tests passed!"
	
clean:
	rm -f lex.yy.c guishap.tab.* guishap.out *.wasm *.wat
	rm -f tests/*/actual_output.wat tests/*/output.wasm
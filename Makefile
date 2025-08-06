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

test-wasm: guishap.out
	@printf "x = 5\ny = 3\n" | ./guishap.out 2>/dev/null > example.wat
	@echo "Generated example.wat:"
	@cat example.wat
	@echo ""
	@if command -v wat2wasm >/dev/null 2>&1; then \
		wat2wasm example.wat -o example.wasm && echo "Successfully created example.wasm"; \
	else \
		echo "wat2wasm not found - install wabt toolkit to generate .wasm files"; \
	fi

test: guishap.out
	@echo "Testing with simple assignment:"
	@printf "x = 5\n" | ./guishap.out
	@echo "\nTesting with Bengali numbers:"
	@printf "x = ৫\n" | ./guishap.out
	@echo "\nTesting with test files:"
	@for file in test/*.mgs; do \
		echo "Testing $$file:"; \
		./guishap.out < "$$file" 2>&1 || echo "Failed to parse $$file"; \
		echo ""; \
	done

clean:
	rm -f lex.yy.c guishap.tab.* guishap.out *.wasm *.wat
%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex(void);
%}

%union {
    char *str;
}

%token IN
%token INDENT DEDENT NEWLINE
%token IF ELSE FOR WHILE DEF CLASS RETURN
%token ADD SUB MUL DIV EQ NE ASSIGN LPAREN RPAREN COLON COMMA
%token <str> NUMBER BN_NUMBER STRING EN_IDENTIFIER BN_IDENTIFIER KEYWORD_TYPE

%type <str> expression
%type <str> test

%start file_input

%%

file_input: 
    | file_input stmt 
    ;

stmt:
    simple_stmt
    | compound_stmt
    ;

simple_stmt:
    expr_stmt NEWLINE
    | return_stmt NEWLINE
    ;

expr_stmt:
    assignment
    | expression
    ;

compound_stmt:
    if_stmt
    | for_stmt
    | funcdef
    | classdef
    ;

assignment:
    identifier ASSIGN expression
    { printf("Assignment: %s = %s\n", $1, $3); free($1); free($3); }
    ;

if_stmt:
    IF test COLON NEWLINE INDENT stmt DEDENT
    { printf("If statement\n"); }
    | IF test COLON NEWLINE INDENT stmt DEDENT ELSE COLON NEWLINE INDENT stmt DEDENT
    { printf("If-else statement\n"); }
    ;

for_stmt:
    FOR identifier IN expression COLON NEWLINE INDENT stmt DEDENT
    { printf("For loop\n"); }
    ;

funcdef:
    DEF identifier LPAREN RPAREN COLON NEWLINE INDENT stmt DEDENT
    { printf("Function definition: %s\n", $2); free($2); }
    ;

test:
    expression comp_op expression
    { $$ = strcat(strcat($1, $2), $3); }
    ;

comp_op:
    EQ | NE
    ;

expression:
    term
    | expression ADD term
    | expression SUB term
    ;

term:
    factor
    | term MUL factor
    | term DIV factor
    ;

factor:
    NUMBER
    | BN_NUMBER
    | STRING
    | identifier
    | LPAREN expression RPAREN
    ;

identifier:
    EN_IDENTIFIER { $$ = $1; }
    | BN_IDENTIFIER { $$ = $1; }
    ;

return_stmt:
    RETURN expression
    { printf("Return statement: %s\n", $2); free($2); }
    ;

classdef:
    CLASS identifier COLON NEWLINE INDENT stmt DEDENT
    { printf("Class definition: %s\n", $2); free($2); }
    ;


%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}

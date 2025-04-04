%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
%}

%union {
    char *str;
}

%token IN
%token ERROR
%token KEYWORD_CONSTANT
%token INDENT DEDENT NEWLINE
%token IF ELSE FOR WHILE DEF CLASS RETURN
%token ADD SUB MUL DIV EQ NE ASSIGN LPAREN RPAREN COLON COMMA
%token <str> NUMBER BN_NUMBER STRING EN_IDENTIFIER BN_IDENTIFIER KEYWORD_TYPE

%type <str> expression test term factor identifier assignment return_stmt classdef funcdef comp_op

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
    { $$ = (char *) malloc(strlen($1) + strlen($2) + strlen($3) + 1); strcpy($$, $1); strcat($$, $2); strcat($$, $3); }
    ;

comp_op:
    EQ { $$ = strdup("=="); }
    | NE { $$ = strdup("!="); }
    ;

expression:
    term
    | expression ADD term { $$ = (char *) malloc(strlen($1) + strlen($3) + 2); sprintf($$, "%s+%s", $1, $3); free($1); free($3); }
    | expression SUB term { $$ = (char *) malloc(strlen($1) + strlen($3) + 2); sprintf($$, "%s-%s", $1, $3); free($1); free($3); }
    ;

term:
    factor
    | term MUL factor { $$ = (char *) malloc(strlen($1) + strlen($3) + 2); sprintf($$, "%s*%s", $1, $3); free($1); free($3); }
    | term DIV factor { $$ = (char *) malloc(strlen($1) + strlen($3) + 2); sprintf($$, "%s/%s", $1, $3); free($1); free($3); }
    ;

factor:
    NUMBER { $$ = $1; }
    | BN_NUMBER { $$ = $1; }
    | STRING { $$ = $1; }
    | identifier { $$ = $1; }
    | LPAREN expression RPAREN { $$ = $2; }
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

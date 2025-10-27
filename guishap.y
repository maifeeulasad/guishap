%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

void yyerror(const char *s);
int yylex(void);
void gen_wasm(ASTNode *node, FILE *out);

ASTNode *root = NULL;
ASTNode *current_block = NULL;
%}

%union {
    char *str;
    ASTNode *node;
}

%token IN ERROR
%token KEYWORD_CONSTANT
%token INDENT DEDENT NEWLINE
%token IF ELSE FOR WHILE DEF CLASS RETURN
%token ADD SUB MUL DIV EQ NE ASSIGN LPAREN RPAREN COLON COMMA
%token <str> NUMBER BN_NUMBER STRING EN_IDENTIFIER BN_IDENTIFIER KEYWORD_TYPE

%type <node> program stmt stmt_list simple_stmt expr_stmt compound_stmt
%type <node> assignment if_stmt for_stmt funcdef classdef test expression term factor identifier
%type <node> return_stmt  // ADDED MISSING TYPE DECLARATION

%start program

%%

program:
    { 
        root = create_node(NODE_PROGRAM, "Program");
        current_block = root;
    }
    stmt_list { root->children = $2; }
    ;

stmt_list:
    stmt { $$ = $1; }
    | stmt_list stmt { $1->next = $2; $$ = $1; }
    ;

stmt:
    simple_stmt { $$ = $1; }
    | compound_stmt { $$ = $1; }
    ;

simple_stmt:
    expr_stmt NEWLINE { $$ = $1; }
    | return_stmt NEWLINE { $$ = $1; }
    ;

expr_stmt:
    assignment { $$ = $1; }
    | expression { $$ = $1; }
    ;

compound_stmt:
    if_stmt { $$ = $1; }
    | for_stmt { $$ = $1; }
    | funcdef { $$ = $1; }
    | classdef { $$ = $1; }
    ;

assignment:
    identifier ASSIGN expression {
        $$ = create_node(NODE_ASSIGNMENT, "=");
        append_child($$, $1);
        append_child($$, $3);
    }
    ;

if_stmt:
    IF test COLON NEWLINE INDENT stmt DEDENT {
        $$ = create_node(NODE_IF, "if");
        append_child($$, $2);  // FIXED $3 to $2 (test node)
        append_child($$, $6);  // stmt node
    }
    | IF test COLON NEWLINE INDENT stmt DEDENT ELSE COLON NEWLINE INDENT stmt DEDENT {
        $$ = create_node(NODE_IF, "if-else");
        append_child($$, $2);  // test node
        append_child($$, $6);  // then branch
        append_child($$, $12); // else branch
    }
    ;

for_stmt:
    FOR identifier IN expression COLON NEWLINE INDENT stmt DEDENT {
        $$ = create_node(NODE_FOR, "for");
        append_child($$, $2);
        append_child($$, $4);
        append_child($$, $8);
    }
    ;

funcdef:
    DEF identifier LPAREN RPAREN COLON NEWLINE INDENT stmt DEDENT {
        $$ = create_node(NODE_FUNCTION, "func");
        append_child($$, $2);
        append_child($$, $8);
    }
    ;

test:
    expression EQ expression {
        ASTNode *op = create_node(NODE_BINOP, "==");
        append_child(op, $1);
        append_child(op, $3);
        $$ = op;
    }
    | expression NE expression {
        ASTNode *op = create_node(NODE_BINOP, "!=");
        append_child(op, $1);
        append_child(op, $3);
        $$ = op;
    }
    ;

expression:
    term { $$ = $1; }
    | expression ADD term {
        ASTNode *op = create_node(NODE_BINOP, "+");
        append_child(op, $1);
        append_child(op, $3);
        $$ = op;
    }
    | expression SUB term {
        ASTNode *op = create_node(NODE_BINOP, "-");
        append_child(op, $1);
        append_child(op, $3);
        $$ = op;
    }
    ;

term:
    factor { $$ = $1; }
    | term MUL factor {
        ASTNode *op = create_node(NODE_BINOP, "*");
        append_child(op, $1);
        append_child(op, $3);
        $$ = op;
    }
    | term DIV factor {
        ASTNode *op = create_node(NODE_BINOP, "/");
        append_child(op, $1);
        append_child(op, $3);
        $$ = op;
    }
    ;

factor:
    NUMBER { $$ = create_node(NODE_LITERAL, $1); }
    | BN_NUMBER { $$ = create_node(NODE_LITERAL, $1); }
    | STRING { $$ = create_node(NODE_LITERAL, $1); }
    | identifier { $$ = $1; }
    | LPAREN expression RPAREN { $$ = $2; }
    ;

identifier:
    EN_IDENTIFIER { $$ = create_node(NODE_IDENTIFIER, $1); }
    | BN_IDENTIFIER { $$ = create_node(NODE_IDENTIFIER, $1); }
    ;

return_stmt:
    RETURN expression {
        $$ = create_node(NODE_RETURN, "return");
        append_child($$, $2);
    }
    ;

classdef:
    CLASS identifier COLON NEWLINE INDENT stmt DEDENT {
        $$ = create_node(NODE_CLASS, "class");
        append_child($$, $2);
        append_child($$, $6);
    }
    ;

%%

// Implement AST functions
ASTNode* create_node(NodeType type, const char *value) {
    ASTNode *node = (ASTNode *)malloc(sizeof(ASTNode));
    node->type = type;
    node->value = strdup(value);
    node->left = node->right = node->children = node->next = NULL;
    return node;
}

void append_child(ASTNode *parent, ASTNode *child) {
    if (!parent->children) {
        parent->children = child;
    } else {
        ASTNode *last = parent->children;
        while (last->next) last = last->next;
        last->next = child;
    }
}

void free_ast(ASTNode *node) {
    if (!node) return;
    free_ast(node->children);
    free_ast(node->next);
    free(node->value);
    free(node);
}

void print_ast(ASTNode *node, int depth) {
    if (!node) return;
    for (int i = 0; i < depth; i++) fprintf(stderr, "  ");
    fprintf(stderr, "%s: %s\n", 
        (node->type == NODE_PROGRAM) ? "Program" :
        (node->type == NODE_ASSIGNMENT) ? "Assignment" :
        (node->type == NODE_IDENTIFIER) ? "Identifier" :
        (node->type == NODE_LITERAL) ? "Literal" :
        (node->type == NODE_BINOP) ? "BinOp" :
        (node->type == NODE_FUNCTION) ? "Function" :
        (node->type == NODE_CLASS) ? "Class" :
        (node->type == NODE_IF) ? "If" :
        (node->type == NODE_FOR) ? "For" :
        (node->type == NODE_RETURN) ? "Return" : "Unknown",
        node->value);
    print_ast(node->children, depth + 1);
    print_ast(node->next, depth);
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    if (yyparse() == 0 && root != NULL) {
        fprintf(stderr, "\nGenerated AST:\n");
        print_ast(root, 0);

        gen_wasm(root, stdout); // <-- clean wat output to stdout
    }
    free_ast(root);
    return 0;
}
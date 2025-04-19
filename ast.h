// ast.h
#ifndef AST_H
#define AST_H

typedef enum {
    NODE_PROGRAM,
    NODE_ASSIGNMENT,
    NODE_IDENTIFIER,
    NODE_LITERAL,
    NODE_BINOP,
    NODE_FUNCTION,
    NODE_CLASS,
    NODE_IF,
    NODE_FOR,
    NODE_RETURN
} NodeType;

typedef struct ASTNode {
    NodeType type;
    char *value;
    struct ASTNode *left;
    struct ASTNode *right;
    struct ASTNode *children;
    struct ASTNode *next;
} ASTNode;

ASTNode* create_node(NodeType type, char *value);
void append_child(ASTNode *parent, ASTNode *child);
void free_ast(ASTNode *node);
void print_ast(ASTNode *node, int depth);

#endif
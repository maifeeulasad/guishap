// codegen.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

void gen_wasm(ASTNode *node, FILE *out) {
    if (!node) return;
    
    switch(node->type) {
        case NODE_PROGRAM:
            fprintf(out, "(module\n");
            fprintf(out, "  (func $main (result i32)\n");
            gen_wasm(node->children, out);
            fprintf(out, "    i32.const 0\n");
            fprintf(out, "  )\n");
            fprintf(out, "  (export \"main\" (func $main))\n");
            fprintf(out, ")\n");
            break;
            
        case NODE_ASSIGNMENT:
            fprintf(out, "    ;; Assignment\n");
            gen_wasm(node->children->next, out); // value
            fprintf(out, "    global.set $%s\n", node->children->value);
            break;
            
        case NODE_BINOP: {
            char *op = node->value;
            gen_wasm(node->children, out);
            gen_wasm(node->children->next, out);
            fprintf(out, "    i32.%s\n", 
                strcmp(op, "+") == 0 ? "add" :
                strcmp(op, "-") == 0 ? "sub" :
                strcmp(op, "*") == 0 ? "mul" :
                strcmp(op, "/") == 0 ? "div_s" : "add");
            break;
        }
            
        case NODE_LITERAL:
            fprintf(out, "    i32.const %s\n", node->value);
            break;
            
        case NODE_IDENTIFIER:
            fprintf(out, "    global.get $%s\n", node->value);
            break;
            
        case NODE_FUNCTION:
            fprintf(out, "  (func $%s\n", node->children->value);
            gen_wasm(node->children->next, out);
            fprintf(out, "  )\n");
            break;
            
        default:
            // Handle other node types
            break;
    }
    
    gen_wasm(node->next, out);
}
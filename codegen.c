// codegen.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "ast.h"

#define MAX_GLOBALS 100

static char *global_vars[MAX_GLOBALS];
static int global_count = 0;

int is_global_declared(const char *name) {
    for (int i = 0; i < global_count; i++) {
        if (strcmp(global_vars[i], name) == 0) return 1;
    }
    return 0;
}

void declare_global(const char *name) {
    if (!is_global_declared(name) && global_count < MAX_GLOBALS) {
        global_vars[global_count++] = strdup(name);
    }
}

void collect_globals(ASTNode *node) {
    if (!node) return;

    if (node->type == NODE_ASSIGNMENT && node->children) {
        declare_global(node->children->value);
    }

    collect_globals(node->children);
    collect_globals(node->next);
}

char *normalize_bn_number(const char *bn) {
    static char result[64];
    int result_idx = 0;
    
    while (*bn && result_idx < 63) {
        // Check for Bengali digits (UTF-8 encoded)
        if (strncmp(bn, "০", 3) == 0) { result[result_idx++] = '0'; bn += 3; }
        else if (strncmp(bn, "১", 3) == 0) { result[result_idx++] = '1'; bn += 3; }
        else if (strncmp(bn, "২", 3) == 0) { result[result_idx++] = '2'; bn += 3; }
        else if (strncmp(bn, "৩", 3) == 0) { result[result_idx++] = '3'; bn += 3; }
        else if (strncmp(bn, "৪", 3) == 0) { result[result_idx++] = '4'; bn += 3; }
        else if (strncmp(bn, "৫", 3) == 0) { result[result_idx++] = '5'; bn += 3; }
        else if (strncmp(bn, "৬", 3) == 0) { result[result_idx++] = '6'; bn += 3; }
        else if (strncmp(bn, "৭", 3) == 0) { result[result_idx++] = '7'; bn += 3; }
        else if (strncmp(bn, "৮", 3) == 0) { result[result_idx++] = '8'; bn += 3; }
        else if (strncmp(bn, "৯", 3) == 0) { result[result_idx++] = '9'; bn += 3; }
        else { result[result_idx++] = *bn; bn++; }
    }
    result[result_idx] = '\0';
    return result;
}

void gen_wasm(ASTNode *node, FILE *out) {
    if (!node) return;

    switch(node->type) {
        case NODE_PROGRAM:
            collect_globals(node);

            fprintf(out, "(module\n");

            // Emit global variable declarations
            for (int i = 0; i < global_count; i++) {
                fprintf(out, "  (global $%s (mut i32) (i32.const 0))\n", global_vars[i]);
            }

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
            const char *op = node->value;
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
            fprintf(out, "    i32.const %s\n", normalize_bn_number(node->value));
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
            break;
    }

    gen_wasm(node->next, out);
}

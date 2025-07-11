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
    int i = 0;
    for (; *bn && i < 63; bn++, i++) {
        switch (*bn) {
            case '০': result[i] = '0'; break;
            case '১': result[i] = '1'; break;
            case '২': result[i] = '2'; break;
            case '৩': result[i] = '3'; break;
            case '৪': result[i] = '4'; break;
            case '৫': result[i] = '5'; break;
            case '৬': result[i] = '6'; break;
            case '৭': result[i] = '7'; break;
            case '৮': result[i] = '8'; break;
            case '৯': result[i] = '9'; break;
            default:  result[i] = *bn; break;
        }
    }
    result[i] = '\0';
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

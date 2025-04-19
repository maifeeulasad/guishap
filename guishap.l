%{
#include "ast.h"
#include "guishap.tab.h"
#include <string.h>

extern void yyerror(const char *s);

int current_indent = 0;
int indent_stack[100] = {0};
int stack_ptr = 0;
int paren_count = 0;
%}

%option noinput nounput nodefault yylineno
%option noyywrap

BN_DIGIT          [০১২৩৪৫৬৭৮৯]
BN_CHAR           [অআইঈউঊঋএঐওঔকখগঘঙচছজঝঞটঠডঢণতথদধনপফবভমযরলশষসহড়ঢ়য়ৎংঃঁ]
WHITESPACE        [ \t]

%x INDENT

%%

^[\n]             ;
^{WHITESPACE}+    {
    int spaces = 0;
    for(char *c = yytext; *c; c++) {
        if(*c == ' ') spaces++;
        else if(*c == '\t') spaces += 8;
    }
    
    if (spaces > current_indent) {
        indent_stack[stack_ptr++] = current_indent;
        current_indent = spaces;
        return INDENT;
    } 
    else if (spaces < current_indent) {
        while (stack_ptr > 0 && indent_stack[stack_ptr - 1] > spaces) {
            stack_ptr--;
            current_indent = indent_stack[stack_ptr];
            yyless(0);
            return DEDENT;
        }
        if (stack_ptr > 0 && indent_stack[stack_ptr - 1] != spaces) {
            yyerror("Invalid indentation");
            return ERROR;
        }
        return DEDENT;
    }
}

\n                       { current_indent = 0; return NEWLINE; }

"ধ্রুবক"                   { return KEYWORD_CONSTANT; }
"সংখ্যা"                   { return KEYWORD_TYPE; }
"স্ট্রিং"                    { return KEYWORD_TYPE; }
"যদি"                    { return IF; }
"নাহলে"                  { return ELSE; }
"জন্য"                   { return FOR; }
"যেহেতু"                  { return WHILE; }
"ফেরত"                  { return RETURN; }
"ফাংশন"                  { return DEF; }
"শ্রেণী"                   { return CLASS; }

"+"                     { return ADD; }
"-"                     { return SUB; }
"*"                     { return MUL; }
"/"                     { return DIV; }
"=="                    { return EQ; }
"!="                    { return NE; }
"="                     { return ASSIGN; }

"("                     { paren_count++; return LPAREN; }
")"                     { paren_count--; return RPAREN; }
":"                     { return COLON; }
","                     { return COMMA; }

{BN_DIGIT}+             { yylval.str = strdup(yytext); return BN_NUMBER; }
[0-9]+                  { yylval.str = strdup(yytext); return NUMBER; }

{BN_CHAR}+              { yylval.str = strdup(yytext); return BN_IDENTIFIER; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return EN_IDENTIFIER; }

\"(\\.|[^\\"])*\"       { yylval.str = strdup(yytext); return STRING; }

#.*               ; /* Comments */
{WHITESPACE}+     ; /* Ignore whitespace */
.                 { return yytext[0]; }

%{
    #include "guishap.tab.h"
    extern int yylex();
    extern int yyerror();

%}
%option noinput nounput nodefault yylineno
%option noyywrap
				

%%


.                       			{return *yytext;}


%%

static YY_BUFFER_STATE flex_buffer;


void set_input(const char* input) {
  yy_delete_buffer(flex_buffer);
  flex_buffer = yy_scan_string(input);
}

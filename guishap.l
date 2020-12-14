%{
    #include "guishap.tab.h"
    extern int yylex();
    extern int yyerror();

%}
%option noinput nounput nodefault yylineno
%option noyywrap
				

BN_DIGIT 			[০১২৩৪৫৬৭৮৯]
BN_CHAR 			[অআইঈউঊঋএঐওঔকখগঘঙচছজঝঞটঠডঢণতথদধনপফবভমযরলশষসহড়ঢ়য়ৎংঃঁ]
BN_CHAR_DIGIT 		[০১২৩৪৫৬৭৮৯অআইঈউঊঋএঐওঔকখগঘঙচছজঝঞটঠডঢণতথদধনপফবভমযরলশষসহড়ঢ়য়ৎংঃঁ]

%%

"ধ্রুবক"								{return KEYWORD_CONSTANT;}
"সংখ্যা"|"স্ট্রিং"					{yylval.token = yytext;return KEYWORD;}

"+" 								{yylval.token = yytext;return O_PLUS;}
"-" 								{yylval.token = yytext;return O_MINUS;}
"/" 								{yylval.token = yytext;return O_DEVIDE;}
"*" 								{yylval.token = yytext;return O_MULTIPLY;}

"ফিরান"		 						{return RETURN;}

"যদি" 								{return IF;}
"তাহলে" 								{return THEN;}

[{]									{return START_C;}
[}]									{return END_C;} 

[(]									{return START_P;}
[)]									{return END_P;}

"="                     			{return EQUALS;}
","                     			{return COMMA;}

";"									{return EOL;}

[[:digit:]]+(\.[[:digit:]]+)?		{yylval.token = yytext;return NUMBER;}
{BN_DIGIT}+(\.{BN_DIGIT}+)?			{yylval.token = yytext;return BN_NUMBER;}
\"(\$\{.*\}|\\.|[^\"\\])*\"			{yylval.token = yytext;return STRING;}

[[:alpha:]][[:alnum:]]* 			{yylval.token = yytext;return EN_VARIABLE;}
{BN_CHAR}{BN_CHAR_DIGIT}* 			{yylval.token = yytext;return BN_VARIABLE;}
[[:space:]\t\n]+            		;
.                       			{return *yytext;}


%%

static YY_BUFFER_STATE flex_buffer;


void set_input(const char* input) {
  yy_delete_buffer(flex_buffer);
  flex_buffer = yy_scan_string(input);
}

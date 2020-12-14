%{
    #include <stdio.h>

    #ifdef YYDEBUG
        yydebug = 1;
    #endif

    void yyerror (char const *s);
    int yywrap();
    int yylex(void);
    void set_input(const char* input);
%}

%union {
  char *token;
}

%token <token>  KEYWORD
%token  KEYWORD_CONSTANT

%token O_PLUS
%token O_MINUS
%token O_DEVIDE
%token O_MULTIPLY

%token  RETURN

%token  START_P
%token  END_P
%token  START_C
%token  END_C


%token  EQUALS
%token  COMMA

%token  IF
%token  THEN

%token <token> NUMBER
%token <token> BN_NUMBER
%token <token> STRING
%token <token> VARIABLE
%token <token> BN_VARIABLE

%token EOL


%%
GUISHAP     : STATEMENTS                                            {printf("guishap\n");}
            ;

OPERATOR    : O_PLUS
            | O_MINUS
            | O_DEVIDE
            | O_MULTIPLY
            ;

VAR_DEF     : KEYWORD VARIABLE
            | KEYWORD VARIABLE SET_VALUE
            | KEYWORD BN_VARIABLE
            | KEYWORD BN_VARIABLE SET_VALUE
            ;

VAR_DEF_C   : KEYWORD_CONSTANT KEYWORD VARIABLE SET_VALUE
            | KEYWORD_CONSTANT KEYWORD BN_VARIABLE SET_VALUE
            ;

STATEMENTS  : STATEMENT
            | STATEMENT STATEMENTS
            ;
STATEMENT   : VAR_DEF EOL
            | VAR_DEF_C EOL
            | CODEBLOCK
            ;

EXPRESSION  : MATH_EXPRESSION
            | STRING_EXPRESSION
            | FUNCTION
            | CALL_FUNCTION
            ;

SET_VALUE   : EQUALS EXPRESSION
            ;

STRING_EXPRESSION   : VARIABLE
                    | BN_VARIABLE
                    | STRING
                    | STRING O_PLUS STRING
                    | STRING O_MULTIPLY MATH_EXPRESSION
                    | START_P STRING_EXPRESSION END_P
                    ;

MATH_EXPRESSION : VARIABLE
                | BN_VARIABLE
                | NUMBER
                | BN_NUMBER
                | NUMBER OPERATOR MATH_EXPRESSION
                | START_P MATH_EXPRESSION END_P
                ;

CODEBLOCK   : START_C END_C
            | START_C STATEMENTS END_C
            | START_C STATEMENTS RETURN EXPRESSION EOL END_C
            ;

FUNCTION    : VARIABLE START_P PARAM_DEF END_P CODEBLOCK
            | BN_VARIABLE START_P PARAM_DEF END_P CODEBLOCK
            ;

PARAM_DEF   : VAR_DEF
            | VAR_DEF_C
            | VAR_DEF COMMA PARAM_DEF
            | VAR_DEF_C COMMA PARAM_DEF
            ;

CALL_FUNCTION   : VARIABLE START_P END_P
                | VARIABLE START_P PARAM_VALUES END_P
                | BN_VARIABLE START_P END_P
                | BN_VARIABLE START_P PARAM_VALUES END_P
                ;

PARAM_VALUES    : EXPRESSION
                | EXPRESSION COMMA PARAM_VALUES

%%


int main(int argc, char **argv)
{
    char buffer[BUFSIZ];
    while(1) {
        char* input = fgets(buffer, sizeof buffer, stdin);
        if (buffer == NULL) 
            break;
        set_input(input);
        yyparse();
        printf("****************Parsing complete************\n");
    }
   return 0;
}
int yywrap()
{
   return 1;
}
void yyerror (char const *s) {
    printf("Error :\n");
    fprintf (stderr, "%s\n", s);
}
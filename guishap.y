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
%token <token> STRING
%token <token> VARIABLE

%token EOL


%%
GUISHAP     : STATEMENTS                                            {printf("guishap\n");}
            ;

OPERATOR    : O_PLUS
            | O_MINUS
            | O_DEVIDE
            | O_MULTIPLY
            ;

STATEMENTS  : STATEMENT                                             {printf("statement---\n");}
            | STATEMENT STATEMENTS                                  {printf("statement---s\n");}
            ;
STATEMENT   : KEYWORD_CONSTANT KEYWORD VARIABLE SET_VALUE EOL       {printf("1\n");}
            | KEYWORD VARIABLE EOL                                  {printf("2\n");}
            | KEYWORD VARIABLE SET_VALUE EOL                        {printf("3\n");}
            ;

SET_VALUE   : EQUALS MATH_EXPRESSION
            | EQUALS STRING_OPERATION
            ;

STRING_OPERATION    : VARIABLE
                    | STRING
                    | STRING O_PLUS STRING
                    | STRING O_MULTIPLY MATH_EXPRESSION
                    | START_P STRING_OPERATION END_P
                    ;

MATH_EXPRESSION : VARIABLE
                | NUMBER
                | NUMBER OPERATOR MATH_EXPRESSION
                | START_P MATH_EXPRESSION END_P
                ;


%%


int main(int argc, char **argv)
{
    char buffer[BUFSIZ];
    if(argc == 2 || argc == 3){
        char* input = fgets(buffer, sizeof buffer, stdin);
        if (buffer == NULL) 
            return -1;
        set_input(input);
        yyparse();
        printf("****************Parsing complete************\n");
    }
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
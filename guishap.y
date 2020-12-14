%{
    #include<stdio.h>
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

%token <token> OPERATOR

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
STATEMENTS  : STATEMENT                                             {printf("statement---\n");}
            | STATEMENT STATEMENTS                                  {printf("statement---s\n");}
            ;
STATEMENT   : KEYWORD_CONSTANT KEYWORD VARIABLE SET_VALUE EOL       {printf("1\n");}
            | KEYWORD VARIABLE EOL                                  {printf("2\n");}
            | KEYWORD VARIABLE SET_VALUE EOL                        {printf("3\n");}
            ;

SET_VALUE   : EQUALS NUMBER                                         {printf("....1\n");}
            | EQUALS STRING                                         {printf("....2\n");}
            | EQUALS VARIABLE                                       {printf("....3\n");}
            ;

%%


int main()
{
    char buffer[BUFSIZ];
    while (1)
    {
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
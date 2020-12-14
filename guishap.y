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




%%


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
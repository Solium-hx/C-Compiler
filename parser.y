%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>

    struct symbol {
        char* id;
        int type;
        int declared;
    };
    /*
        string  0
        int     1
    */
    struct vals {
        char* str;
        int i;
    };

    struct symbol symbols[100];
    int symbolCount = 0;
    struct vals values[100];

    int lookup_symbol(char* id) {
        int i;
        for(i = 0; i < symbolCount; i = i + 1) {
            if(strcmp(symbols[i].id, id) == 0) {
                return i;
            }
        }

        return -1;
    }

    int add_symbol(char* id, int type, int declared, struct vals value) {
        int index = lookup_symbol(id);
        if(index == -1) {
            index = symbolCount;
            symbolCount = symbolCount + 1;
            symbols[index].id = id;
            symbols[index].type = type;
            symbols[index].declared = declared;
            if(declared == 1) {        
                values[index] = value;
            }
        }
    }
    
%}

%token ASN LPAR RPAR SEMICOL PRINT

%token TYPE_INT TYPE_STRING

%left PLUS MINUS MUL DIV

%union {
        char* str;
        int i_val;
}

%token <str> STRING
%token <i_val> INT
%token <str> ID

%type <i_val> type

%%

program 
        : statementList
        ;

statementList 
        : statementList statement
        | statement
        ;

statement 
        : declatation
        | assignment
        | output
        ;

output
        : PRINT LPAR STRING RPAR SEMICOL {
                printf("%s\n", $3);
        }
        | PRINT LPAR INT RPAR SEMICOL {
                printf("%d\n", $3);
        }
        | PRINT LPAR ID RPAR SEMICOL

declatation 
        : type ID SEMICOL {
                struct vals v;
                add_symbol($2, $1, 0, v);
                printf("%s, %d\n", symbols[symbolCount-1].id, symbols[symbolCount-1].type);
        }
        ;

type 
        : TYPE_STRING {
                $$ = 0;
        }
        | TYPE_INT {
                $$ = 1;
        }
        ;


assignment 
        : ID ASN INT SEMICOL
        | ID ASN expression SEMICOL
        | ID ASN STRING SEMICOL
        ;

expression 
        : expression PLUS term
        | expression MINUS term
        | term
        ;

term 
        : term MUL factor
        | term DIV factor
        | factor
        ;

factor 
        : INT
        | ID
        | LPAR expression RPAR
        ;


%%

int yyerror(char *s) {
    fprintf(stderr, "Custom Error: %s\n", s);
    return 0;
}

int main () {
    return yyparse();
}
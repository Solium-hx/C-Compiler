%{
    #include <stdio.h>
    #include "y.tab.h"
%}

letter  [a-zA-Z]
digit   [0-9]

%%

"int"                           {return TYPE_INT;}
"string"                        {return TYPE_STRING;}
"output"                        {return PRINT;}

"="                             {return ASN;}
"+"                             {return PLUS;}
"-"                             {return MINUS;}
"*"                             {return MUL;}
"/"                             {return DIV;}
"("                             {return LPAR;}
")"                             {return RPAR;}
";"                             {return SEMICOL;}
{letter}({letter}|{digit})*     {return ID;}
{digit}+                        { 
                                    yylval.i_val = atoi(yytext); 
                                    return INT;}
["](.)*["]                      {
                                    yylval.str = strdup(yytext);
                                    return STRING;
                                }
.                               {
                                    ;
                                }


%%

int yywrap() {
    return 1;
}
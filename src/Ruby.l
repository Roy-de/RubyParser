%{
    #include<stdio.h>
    #include<stdlib.h>
    #include "y.tab.h"
%}


%%
[\t ] /*Ignore white spaces*/

%%

int yywrap(void){
    return 1;
}

int main(){
        yylex();
        return 0;
}
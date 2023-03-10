%{
    #include<stdio.h>
    #include<stdlib.h>
    #include "y.tab.h"
    /*lexer with symbol table */
enum {
      LOOKUP = 0, /*Default - looking rather than defining*/
      KEYWORDS,
      VARNAME,
};
%}



%%
 /* Keywords in Ruby -- Start */
__ENCODING__ |
int |
float |
__LINE__ | 
__FILE__ |
BEGIN |
END |
alias |
and |
begin |
break |
case |
class |
def |
defined? |
do |
else |
elsif |
end |
ensure |
false |
for |
if |
in |
module |
next |
nil |
not |
or |
redo |
rescue |
retry |
return |
self |
super |
then |
true |
undef |
unless |
until |
when |
while |
yield {printf("%s: is a keyword",yytext); }
 /*End of keywords*/
 /*Checks to confirm other words are not keywords*/
[a-zA-Z]+   { printf("%s: is not a keyword",yytext); }
 /* ^ denotes that it must begin on a new line*/

%%

int yywrap(void){
    return 1;
}

int main(){
        yylex();
        return 0;
}
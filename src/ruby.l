%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "y.tab.h"
    enum {
       OP_ASGN,
       SYMBOL,
       FNAME,
       OPERATION,
       VARNAME,
       GLOBAL,
       STRING,
       STRING2,
       HERE_DOC,
       REGEXP,
       IDENTIFIER,
       LOOKUP = 0,
    };
%}
OP_ASGN: += | -= | *= | /= | %= | **=| &= | |= | ^= | <<= | >>=| &&= | ||=

SYMBOL: :FNAME| :VARNAME 

FNAME: IDENTIFIER| .. | "|"| ^ | & | <=> | == | === | = ̃| > | >= | < | <= | + | - | * | / | % | **| << | >> |  ̃ | +@ | -@ | [] | []=

OPERATION: IDENTIFIER [! | ?]

VARNAME: GLOBAL| @IDENTIFIER| IDENTIFIER

GLOBAL: $IDENTIFIER| $any_char| $-any_char

STRING: " {any_char}"| ` {any_char}`| ' {any_char}'

STRING2: %(Q|q|x)char {any_char} char

HERE_DOC: <<(IDENTIFIER| STRING){any_char}IDENTIFIER

REGEXP: / {any_char}/ [i|o|p]| %r char{any_char}char

IDENTIFIER: [a-zA-Z_]+[a-zA-Z0-9_] 
%%


%%

void main(){
    yylex();

}
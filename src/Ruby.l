%{
    #include<stdio.h>
    #include<stdlib.h>
    #include "y.tab.h"
%}


%%
 /* Keywords in Ruby -- Start */
__ENCODING__ |
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
yield |
 /*End of keywords*/
 /* ^ denotes that it must begin on a new line*/

%%

int yywrap(void){
    return 1;
}

int main(){
        yylex();
        return 0;
}
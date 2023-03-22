%{
    #include<stdio.h>
    #include<stdlib.h>
    #include "y.tab.h"
    /*lexer with symbol table */
enum {
        LOOKUP = 0, /*Default - looking rather than defining*/
        VARIABLE,
};
int state;
int add_variable(int type, char *word);
int lookup(char *word);
%}

/*We can define int state to store the state of our lookup table */
/* we can say state = VARNAME to store our variable names in a lookup table*/

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
"defined?" |
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
 /*ruby datatypes */
"integer" | "float" | "string" | "array" { printf("%s: is a datatype",yytext); }
 /*Defining integers */
[+-]*[0-9]+  { printf("%d: is set to be an integer value\n",yytext); }
 /*Defining floats */
[+-]*[0-9]+\.[0-9]+ { printf("%f: is ste to be a float value\n",yytext); }
 /* ^ denotes that it must begin on a new line*/
 /*Ruby operators*/
"+=" |
"-=" | 
"*=" | 
"/=" | 
"%=" | 
"**=" | 
"&=" | 
"|=" | 
"^=" | 
"<<=" | 
">>=" | 
"&&=" | 
"||=" | 
"*" | { printf("Operators",yytext);}
 /*Comments in ruby and removing them */
    /*Single line comment*/
 /*^[#]+ [a-zA-Z0-9]  { printf("Single line comment detected \n"); }*/
  /*Multiline comment*/  
 /*Add variables */
^\n { state = VARIABLE; }
[a-zA-Z]+ {
    if(state != LOOKUP){
        add_variable(state,yytext);
    }else{
        switch(lookup(yytext)) {
                case VARIABLE: printf("%s: Varable name\n",yytext);break;
                default: printf("%s: not recognized\n",yytext);break;
            }
    }
}
%%

int yywrap(void){
    return 1;
}

int main(){
        yylex();
        return 0;
}

/*Define a linked list of words and types*/
struct word{
    char *word_name;
    int word_type;
    struct word *next;
};

struct word *word_list; /*first element in word list*/

extern void *malloc();

int add_variable(int type, char *word){
    /*This function checks if our variable is added or not*/
    struct word *wp;
    if(lookup(word) != LOOKUP){
        printf("word defined: %s",word);
    }
    /*Word not there? Lets add it then
    we do this by allocating a new entry and link it on the list */

    wp = (struct word *)malloc(sizeof(struct word));
    wp -> next = word_list;

   
    return 1;
}

int lookup(char *word){
    struct word *wp = word_list;
    /*Search down the list looking for the word*/
    for(;wp;wp=wp->next){
        if(strcmp(wp->word_name,word) == 0)
            return wp->word_type;
    }
    return LOOKUP;
}
    /* wp -> word_name = (char *)malloc(strlen(word)+1);
    strcpy(word->word_name,word);
    wp-> word_type = type;
    word_list = wp;*/
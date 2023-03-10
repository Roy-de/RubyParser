%{
enum {
    LOOKUP = 0,
    VERB,
    ADJ,
    ADV,
    NOUN,
    PREP,
    PRON,
    CONJ
};
int state;

int add_word(int type, char *word);
int lookup_word(char *word);
%}

%%
[\t ]+    ;
is |
am |
are | 
were |
was |
be |
being |
been |
do |
does |
did |
will |
would |
should |
can |
could |
has |
have |
had |
go      { printf("%s: is a verb\n",yytext); }

very |
simply |
gently |
calmly |
angrily   { printf("%s: is an adverb\n",yytext); }

to |
from |
behind |
above |
below |
between { printf("%s: is a preposition\n",yytext); }

if |
then |
and |
but |
or   { printf("%s: is a conjunction\n",yytext); }

their |
my |
your |
his |
her |
its    { printf("%s: is an adjective\n",yytext); }

I |
you |
he |
she |
we |
they  { printf("%s: is a pronoun\n",yytext); }

   /*end of line return default state*/
\n  { state = LOOKUP; }

  /*Whenever a line starts with a reserved part of speech name 
    Start defining words of that type */
^verb   { state =  VERB; }
^adj   { state = ADJ; }
^adv   { state = ADV; }
^noun    { state =  NOUN; }
^prep { state = PREP; }
^pron  { state =  PRON; }
^conj   { state = CONJ; } 
[a-zA-Z]+ { 
    if(state != LOOKUP) {
        /*Define the current word */
        add_word(state, yytext);
    } else {
        switch(lookup_word(yytext)) {
            case VERB: printf("%s: verb\n",yytext); break;
            case ADJ: printf("%s: adjective\n",yytext); break;
            case ADV: printf("%s: adverb\n",yytext); break;
            case NOUN: printf("%s: noun\n",yytext); break;
            case PREP: printf("%s: preposition\n",yytext); break;
            case PRON: printf("%s: pronoun\n",yytext); break; 
            case CONJ: printf("%s: conjunction\n",yytext); break;
            default: printf("%s: Dont recognize\n",yytext); break;
        }
    }
 }

. /*ignore anything else. */
%%

void main(){
    yylex();
}
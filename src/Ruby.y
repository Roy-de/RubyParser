%{
   #include <stdio.h>
   #include<stdlib.h>

   extern int yylex();
   void yyerror(char *msg);
%} 
%token ';' "\n" '[' ']' '=' if until while unless do undef alias return yield and or not '!' "::" in end for super begin else '<' '*' '(' ')' ',' '.' '&' ">="
%token '>' '+' '-' '/'  '%' "**"

%%

PROGRAM : COMPSTMT {printf("%s\n",yytext);}
        ;

T : ';' 
  | '\n'
  ;

COMPSTMT : STMT {T EXPR} [T]
         ;

STMT : CALL do '[' '|' '[' BLOCK_VAR ']' '|' ']' COMPSTMT end
     | undef FNAME
     | alias FNAME FNAME
     | STMT if EXPR
     | STMT while EXPR
     | STMT unless EXPR
     | STMT until EXPR
     | "BEGIN" "{" COMPSTMT "}"  //object initializer
     | "END" "{" COMPSTMT "}"    //object finalizer
     | LHS '=' COMMAND '[' do '[' "|" '[' BLOCK_VAR']' "|" ']' COMPSTMT end ']'
     | EXPR
     ;

EXPR    : MLHS '=' MRHS
        | return CALL_ARGS
        | yield CALL_ARGS
        | EXPR and EXPR
        | EXPR or EXPR
        | not EXPR
        | COMMAND
        | '!' COMMAND
        | ARG
        ;

CALL : FUNCTION
     | COMMAND 
     ;
COMMAND : OPERATION CALL_ARGS
        | PRIMARY.OPERATION CALL_ARGS
        | PRIMARY "::" OPERATION CALL_ARGS
        | super CALL_ARGS
        ;

FUNCTION : OPERATION '[' "(" '[' CALL_ARGS ']' ")" ']'
         | PRIMARY.OPERATION "(" '['CALL_ARGS']' ")"
         | PRIMARY "::" OPERATION "(" '['CALL_ARGS']' ")"
         | PRIMARY.OPERATION
         | PRIMARY "::" OPERATION
         | super "(" '['CALL_ARGS']' ")"
         | super
         | for BLOCK_VAR in EXPR DO
            COMPSTMT
             end
         | begin
           COMPSTMT
           {rescue [ARGS] DO
               COMPSTMT}
           [else COMPSTMT]
           [ensure COMPSTMT]
            end
         | class IDENTIFIER [ '<' IDENTIFIER ]
                  COMPSTMT
                  end
         | module IDENTIFIER
             COMPSTMT
           end
         | def FNAME ARGDECL
             COMPSTMT
           end
         | def SINGLETON '(' '.' '|' "::" ')' FNAME ARGDECL
              COMPSTMT
           end
          ;

WHEN_ARGS : ARGS '[' ',' '*' ARG']'
          | '*' ARG
          ;

THEN : T 
     | then 
     | T then //'then" and "do" can go on the next line
     ;

DO : T 
   | do 
   | T do
   ;
BLOCK_VAR : LHS
          | MLHS
          ;
MLHS : MLHS_ITEM ',' '[' MLHS_ITEM '(' ',' MLHS_ITEM ')' '*' ']' '[''*' [LHS] ']'
     | '*' LHS 
     ;
MLHS_ITEM : LHS | "(" MLHS ")" 
          ;
LHS : VARIABLE
    | PRIMARY "[" [ARGS] "]"
    | PRIMARY.IDENTIFIER   
    ;
MRHS : ARGS [ , * ARG] 
     | '*' ARG

CALL_ARGS :  ARGS  
          | ARGS [',' ASSOCS] [',' * ARG] [',' '&' ARG]
          | ASSOCS [',' '*' ARG] [',' '&' ARG]
          |'*' ARG [',' '&' ARG] | '&' ARG
          |COMMAND                         
          ;

ARGS : ARG '(', ARG')' '*'  
     ;

ARG :LHS '=' ARG
    |LHS OP_ASGN ARG
    |ARG .. ARG | ARG ... ARG
    |ARG '+' ARG | ARG '-' ARG | ARG '*' ARG | ARG '/' ARG
    |ARG '%' ARG | ARG "**" ARG
    |'+' ARG | '-' ARG
    |ARG "|" ARG
    |ARG '*' ARG | ARG '&' ARG
    |ARG <=> ARG
    |ARG '>' ARG | ARG ">=" ARG | ARG '<' ARG | ARG <= ARG
    |ARG == ARG | ARG === ARG | ARG != ARG
    |ARG =~ ARG | ARG !~ ARG
    |! ARG | ~ ARG
    |ARG << ARG | ARG >> ARG
    |ARG && ARG | ARG || ARG
    |defined? ARG
    |PRIMARY 
    ;

PRIMARY : "(" COMPSTMT ")"
        |LITERAL
        |VARIABLE
        |PRIMARY :: IDENTIFIER
        |:: IDENTIFIER
        |PRIMARY "[" [ARGS] "]"
        |"[" [ARGS [,]] "]"
        |"{" [ARGS | ASSOCS [,]] "}"
        |return ["(" [CALL_ARGS] ")"]
        |yield ["(" [CALL_ARGS] ")"]
        |defined? "(" ARG ")"
        |FUNCTION
        |FUNCTION "{" ["|" [BLOCK_VAR] "|"] COMPSTMT "}"
        |if EXPR THEN
            COMPSTMT
        {elsif EXPR THEN
            COMPSTMT}
        [else
            COMPSTMT]
        end
        |unless EXPR THEN
        COMPSTMT
        [else
            COMPSTMT]
        end
        |while EXPR DO COMPSTMT end
        |until EXPR DO COMPSTMT end
        |case COMPSTMT
            when WHEN_ARGS THEN COMPSTMT
            {when WHEN_ARGS THEN COMPSTMT}

        [else
            COMPSTMT]
            end  
        ;

ARGDECL : "(" ARGLIST ")"
        | ARGLIST T
        ;
ARGLIST : IDENTIFIER(,IDENTIFIER)*[, *[IDENTIFIER]][,&IDENTIFIER]
        | *IDENTIFIER[, &IDENTIFIER]
        | [&IDENTIFIER]
        ;

SINGLETON : VARIABLE
          | "(" EXPR ")"
          ;
ASSOCS : ASSOC {, ASSOC}
       ;
ASSOC : ARG => ARG
      ;
VARIABLE: VARNAME 
        | nil 
        | self
        ;
LITERAL :
         numeric { $$ = $1; }
        | SYMBOL { $$ = $1; }
        | STRING { $$ = $1; }
        | STRING2 { $$ = $1; }
        | HERE_DOC { $$ = $1; }
        | REGEXP  { $$ = $1; }
        ;     

%%

void yyerror(char *msg){
  fprintf(stderr, "%s\n",msg)
  exit(1)
}

//Where the code starts
int main(){
  yyparse();
  return 0;
}
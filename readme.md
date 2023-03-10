#Compiling a lex file and its explanation
1. run lex {name of your lex file}.l
   This will generate a lex.yy.c file which is a C file

2. run cc lex.yy.c -o {name of output file} -ll
   this compiles the c file and links it with the -ll (lex library) and the generated output is named according to your name option

3. run {name of output file} and the lexical syntax you want to test

-------------PATR 2------------------
#Building a dynamic symbol table
#Compiling a lex file and its explanation

1. run lex {name of your lex file}.l
   This will generate a lex.yy.c file which is a C file
2. run cc lex.yy.c -o {name of output file} -ll
   this compiles the c file and links it with the -ll (lex library) and the generated output is named according to your name option
3. run {name of output file} and the lexical syntax you want to test

-------------PATR 2------------------
#Building a dynamic symbol table
in this example we will biulding a reserve keyword symbol table

(The caret, "^", at the begin- ning of the pattern makes the pattern match only at the beginning of an input line.

We reset the state to LOOKUP at the beginning of each line so that after we add new words interactively we can test our table of words to determine if it is working correctly. If the state is LOOKUP when the pattern "[a-zA-Zl+" matches, we look up the word, using Iookup-word(), and if found print out its type. If we're in any other state, we define the word with add-word().

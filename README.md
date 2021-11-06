# Semantic Analyser 

This repository contains the implementation of a lex based semantic analyser capable of parsing the C language.
A compiler is a computer program that transforms source code written in a
programming language (the source language) into another computer language (the
target language), with the latter often having a binary form known as object code.
When executing, the compiler first parses all of the language statements
syntactically one after the other and then, in one or more successive stages or
passes, builds the output code, making sure that statements that refer to other
statements are referred to correctly in the final code. Four Phases of the frontend
compiler are Lexical phase, Syntax phase, Semantic phase and Intermediate code
generation. Once the parse tree is generated the Semantic Analyser will check
actual meaning of the statement parsed in parse tree. Semantic analysis is mainly a
process in compiler construction after parsing to gather necessary semantic
information from the source code. Semantic analyser checks whether syntax
structure constructed in the source program derives any meaning or not. It is the
phase in which the compiler adds semantic information to the parse tree and builds
the symbol table. Semantic analyser is also called context sensitive analysis. This
phase performs semantic checks such as type checking (checking for type errors),
or definite assignment (variable to be initialized before use), rejecting incorrect
programs or issuing warnings. Semantic analysis logically follows the parsing phase,
and logically precedes the code generation phase.

## Files
### 1. assgn3.l

The script is a program that generates lexical analyzers ("scanners" or "lexers"). Lex reads an input stream specifying the lexical analyzer and outputs source code implementing the lexer in the C programming language. The structure of our flex script is intentionally similar to that of a yacc file; files are divided into three sections, separated by lines that contain only two percent signs, as follows:
```
Definition section
%%
Rules section
%%
C code section
```
The definition section defines macros and imports header files written in C. The rules section associates regular expression patterns with C statements. When
the lexer sees text in the input matching a given pattern, it will execute the associated C code.

### 2. assgn3.y

A YACC source program is structurally similar to a LEX one.
```
Declarations section
%%
Rules section
%%
Routines section
```
#### Declarations Section
- Declarations of tokens. Yacc requires token names to be declared as such
using the keyword %token
- Declaration of the start symbol using the keyword %start.
- C declarations: included files, global variables, types.
- C code between %{ and % }

#### Rules Section
A rule has the form:
```
Nonterminal : sentential form
| sentential form
………………
| sentential form
;
```
Actions may be associated with rules and are executed when the associated
sentential form is matched.

## Implementation
The semantic analyzer is built by adding subroutines and C functions for the
grammar rules defined in the syntax analyzer phase of the compiler. The symbol
table of syntax phase is updated in the semantic phase. The symbol table contains
the following columns:
1. Serial No - represents the number of entries in the symbol table
2. Identifier - specifies the name of the variables which are identifiers
3. Scope - specifies the scope of the variables
4. Value - represents the mathematical value of a variable if initialized/defined
5. Type - specifies the data type of the variable
6. Dimension - specifies the dimension if the identifier is an array
7. Parameter type - specifies the data types of function arguments/parameters
8. Parameter list - specifies the names of function parameters


The functionalities that we have provided are:
1) To detect if the user has used a reserved keyword or identifier as a variable name
2) To check arithmetic expressions (only integers and symbols allowed)
3) To detect if new declarations of functions or variables don't conflict with earlier ones.
4) To check if break statements are only present in loops.
5) Check if a parameter's type is compatible with the function call.



**The test cases along with i/o screenshots are provided in the test_doc.pdf**

## How to run
1) run `lex assgn3.l`. This will create a lex.yy.c file.
2) run `gcc -lfl lex.yy.c` to compile the C file.
3) run  `./a.out` 



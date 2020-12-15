%{
int yylineno;
void pop();
void push();
%}

alpha [A-Za-z]
digit [0-9]
und [_]

%%
[ \t] ;
\n	{yylineno++;}
"{"	{push(); return '{';} /*** we are pushing the ***/ 
						 /***scope of the var on the stack since the scope is defined via brackets ***/

"}"	{pop(); return '}';}
";"	     {   return(';'); }
","	     {   return(','); }
":"	     {   return(':'); }
"="	     {   return('='); }
"("	     {   return('('); }
")"	     {   return(')'); }
("[") 	     {   return('['); }
("]")        {   return(']'); }
"."	     {   return('.'); }
"&"	     {   return('&'); }
"!"	     {   return('!'); }
"~"	     {   return('~'); }
"-"	     {   return('-'); }
"+"	     {   return('+'); }
"*"	     {   return('*'); }
"/"	     {   return('/'); }
"%"	     {   return('%'); }
"<"	     {   return('<'); }
">"	     {   return('>'); }
"^"	     {   return('^'); }
"|"	     {   return('|'); }
"?"	     {   return('?'); }
int	{yylval.ival = INT; return INT;} /*** yylval stores the value of the integer and returns the token INT to yacc ***/
float	{yylval.ival = FLOAT; return FLOAT;} /*** .ival stores the token number which will be passed to yacc and to determine ***/
/*** which type of datatype it is we have two var defined in union function of assgn3.y ***/
void	{yylval.ival = VOID; return VOID;}
else	{return ELSE;}
if	{return IF;}
^"#include ".+	return PREPROC;

return 	return RETURN;
printf	return PRINT;
{alpha}({alpha}|{digit}|{und})* {yylval.str=strdup(yytext); return ID;}
{digit}+	{yylval.str=strdup(yytext);return NUM;}
{digit}+\.{digit}+ 	{yylval.str=strdup(yytext); return REAL;} //pointer to value in yytext
"<="		return LE;
">="            return GE;
"=="            return EQ;
"!="            return NE;
"++"            return INC;
"--"            return DEC;
\/\/.* ;
\/\*(.*\n)*.*\*\/ ; /*** multiline comments ***/
\".*\"	return STRING;
.	return yytext[0];
%%
int yywrap(){}
%{
#include <stdio.h>			
#include <stdlib.h>
#include <string.h>
#include "symbolTable.c"		
int i=1,k=-1,l=-1;
int j=0;
int stack[100];				
int top=0;
int plist[100]; /* stores the type of parameter during function definition */
int flist[100]; /* stores the type of parameter during function call */
int end[100];
int arr[10];
int ct=0,c=0,b;
int errc=0; /* stores the error count */
int type=0;
extern int yylineno; /* global variable which is accessible to other files also */
int printline();
%}

%token<ival> INT FLOAT VOID /* ival means the integer value and here value of token is returned from the lex code since the token value is integer of all three. */
%token<str> ID NUM REAL
%token IF RETURN PREPROC LE STRING PRINT FUNCTION  ELSE  GE EQ NE INC DEC

%right '='

%type<str> assignment1 consttype assignment2
%type<ival> Type /* tells about the type of value returned and stores the token number of the type of value returned! */

/* ints floats string are the terminals */

%union /* a datatype in which tells about the type of values stored in tokens */
{
	int ival;
	char *str;
}

%%

start : Function start
	| PREPROC start
	| Declaration start
	|
	;



Function : Type ID '('')' CompoundStmt {
	if ($1!=returntype_func(ct)) /* ct: counter che */
	{
		printf("\nError : Type mismatch : Line %d\n",printline()); errc++;
	}


	if (!(strcmp($2,"printf") && strcmp($2,"scanf") && strcmp($2,"getc") && strcmp($2,"gets") && strcmp($2,"getchar") && strcmp	($2,"puts") && strcmp($2,"putchar") && strcmp($2,"clearerr") && strcmp($2,"getw") && strcmp($2,"putw") && strcmp($2,"putc") && strcmp($2,"rewind") && strcmp($2,"sprint") && strcmp($2,"sscanf") && strcmp($2,"remove") && strcmp($2,"fflush")))

	/* function name cannot be a  reserved keyword  */

		{printf("Error : Redeclaration of %s : Line %d\n",$2,printline()); errc++;}
	else
	{
		/*** passing name and FUNCTION. $2 is a name of a function not name of a var :P ***/
		insert($2,FUNCTION);
		/* name of function , return type is being passed*/
		insert($2,$1);  
	}
	}
        | Type ID '(' parameter_list ')' CompoundStmt  {
	if ($1!=returntype_func(ct))
	{
		printf("\nError : Type mismatch : Line %d\n",printline()); errc++;
	}

	if (!(strcmp($2,"printf") && strcmp($2,"scanf") && strcmp($2,"getc") && strcmp($2,"gets") && strcmp($2,"getchar") && strcmp	($2,"puts") && strcmp($2,"putchar") && strcmp($2,"clearerr") && strcmp($2,"getw") && strcmp($2,"putw") && strcmp($2,"putc") && strcmp($2,"rewind") && strcmp($2,"sprint") && strcmp($2,"sscanf") && strcmp($2,"remove") && strcmp($2,"fflush")))
		{printf("Error : Redeclaration of %s : Line %d\n",$2,printline());errc++;}
	else
	{
		insert($2,FUNCTION);  
		insert($2,$1);
                for(j=0;j<=k;j++)
                {insertp($2,plist[j]);}  
                /* function name and parameter type of parameters are being passed*/
                k=-1;
	}
	}
	;

parameter_list : parameter_list ',' parameter
               | parameter
               ;
/* parameter's type,name and scope are being stored  */
parameter : Type ID {plist[++k]=$1;insert($2,$1);insertscope($2,i);}
          ;

Type : INT
	| FLOAT
	| VOID
	;

CompoundStmt : '{' StmtList '}'
	;

StmtList : StmtList stmt
	| CompoundStmt
	|
	;

stmt : Declaration 
	| if
   
	| RETURN consttype ';' { /*** ct is a counter for array 'arr' which is storing datatype of var returned ***/

					if(!(strspn($2,"0123456789")==strlen($2)))
						storereturn(ct,FLOAT);
					else
						storereturn(ct,INT);
					ct++;
				}
	| RETURN ';' {storereturn(ct,VOID); ct++;}
        | RETURN ID ';' {
        /* returns scope  and type of variable returned*/
                          int sct=returnscope($2,stack[top-1]); 	
                          //stack[top-1] - current scope
		          int type=returntype($2,sct);
                          if (type==259) storereturn(ct,FLOAT);
                          else storereturn(ct,INT);
                          ct++;
                         }
	| ';'
	| PRINT '(' STRING ')' ';'
	| CompoundStmt
	;



if : IF '(' expr1 ')' CompoundStmt
	| IF '(' expr1 ')' CompoundStmt ELSE CompoundStmt
	;


expr1 : expr1 LE expr1
        | expr1 GE expr1
        | expr1 NE expr1
        | expr1 EQ expr1
        | expr1 INC
        | expr1 DEC
        | expr1 '>' expr1
        | expr1 '<' expr1
	| assignment1
	;


assignment1 : ID '=' assignment1 /* checking if the data type of ID and assgn1 is same or not */
	{
		int sct=returnscope($1,stack[top-1]);
		int type=returntype($1,sct);
		if((!(strspn($3,"0123456789")==strlen($3))) && type==258)
			{printf("\nError : Type Mismatch : Line %d\n",printline()); errc++;}
         
	}

	
	

	| assignment2
	
	| ID // test case 1/2
	{
		if(lookup($1))
			{ printf("\nUndeclared Variable %s : Line %d\n",$1,printline()); errc++; }
	}
	| ID '=' ID '(' paralist ')'			//function call
        {
                int sct=returnscope($1,stack[top-1]);
		int type=returntype($1,sct);
                //printf("%s",$3);
                int rtype;
                /* function type being returned*/
                rtype=returntypef($3); int ch=0;
                //printf("%d",rtype);
		if(rtype!=type)
			{ printf("\nError : Type Mismatch : Line %d\n",printline()); errc++;}

			/* checking first whether the variable exists or not, if yes whether the function being called exists or not! */
		if(!lookup($1))
		{
		  for(j=0;j<=l;j++)
                  {ch = ch+checkp($3,flist[j],j);}

                  if(ch>0) { printf("\nError : Parameter Type Mistake or Function undeclared : Line %d\n",printline()); errc++;}
                  l=-1;
		}
	}
	| ID '(' paralist ')'			//function call without assignment
	{
                int sct=returnscope($1,stack[top-1]);
		int type=returntype($1,sct); int ch=0;
		if(!lookup($1))
		{
		  for(j=0;j<=l;j++)
                  {ch = ch+checkp($1,flist[j],j);}
                  if(ch>0) { printf("\nError : Parameter Type Mistake or Required Function undeclared : Line %d\n",printline()); errc++;}
                  l=-1;
		}
                else {printf("\nUndeclared Function %s : Line %d\n",$1,printline());errc++;}
	}

	| consttype
	;

paralist : paralist ',' param
         | param
         ;

param : ID 
	{
                if(lookup($1))
	        	{printf("\nUndeclared Variable %s : Line %d\n",$1,printline());errc++;}
                else
                {
                	int sct=returnscope($1,stack[top-1]);
                	/* flist  stores the type and variable names of the parameters passed during fun call!*/
                	flist[++l]=returntype($1,sct);
                }
	}
	;

assignment2 : ID '=' exp {c=0;}
		| ID '=' '(' exp ')'
		;

exp : ID
	{
		if(c==0)							//check compatibility of mathematical operations
		{
			c=1;
			int sct=returnscope($1,stack[top-1]);
			b=returntype($1,sct);
		}
		else
		{
			/* char + number nuh uh! */
			int sct1=returnscope($1,stack[top-1]);
			if(b!=returntype($1,sct1)){}
				{printf("\nError : Type Mismatch : Line %d\n",printline());errc++;}
		}
	}
	| exp '+' exp
	| exp '-' exp
	| exp '*' exp
	| exp '/' exp
	| '(' exp '+' exp ')'
	| '(' exp '-' exp ')'
	| '(' exp '*' exp ')'
	| '(' exp '/' exp ')'
	| consttype
	;

consttype : NUM
	| REAL
	;

Declaration : Type ID '=' consttype ';'
	{
		if( (!(strspn($4,"0123456789")==strlen($4))) && $1==258)
			{printf("\nError : Type Mismatch : Line %d\n",printline());errc++;}
                
		if(!lookup($2))
		{
			int currscope=stack[top-1];
			int previous_scope=returnscope($2,currscope);
			if(currscope==previous_scope)
				{printf("\nError : Redeclaration of %s : Line %d\n",$2,printline());errc++;}
			else
			{
				insert_dup($2,$1,currscope);
				
			}
		}
		else
		{
			int scope=stack[top-1];
			insert($2,$1);
			insertscope($2,scope);
			
		}
	}
	| assignment1 ';'
	{
		if(!lookup($1))
		{
			int currscope=stack[top-1];
			int scope=returnscope($1,currscope);
			int type=returntype($1,scope);
			if(!(scope<=currscope && end[scope]==0) || (scope==0 && type!=271))
				{printf("\nError : Variable %s out of scope : Line %d\n",$1,printline());errc++;}
		}
		else
			{printf("\nError : Undeclared Variable %s : Line %d\n",$1,printline());errc++;}
	}
        | Type ID ';'
        {
        	if(!lookup($2))
		{
			int currscope=stack[top-1];
			int previous_scope=returnscope($2,currscope);
			if(currscope==previous_scope)
				{printf("\nError : Redeclaration of %s : Line %d\n",$2,printline());errc++;}
			else
			{
				insert_dup($2,$1,currscope);
				
			}
		}
		else
		{
			int scope=stack[top-1];
			//printf("%d",type);
			insert($2,$1);
			insertscope($2,scope);
			
		}
	}

	| error
	;



%%

#include "lex.yy.c"
#include<ctype.h>
int main(int argc, char *argv[])
{
	yyin =fopen(argv[1],"r");
	if(!yyparse()&& errc<=0)
	{
		printf("\nParsing Completed\n");
		display();
	}
	else
	{
		printf("\nParsing Failed\n");
                display();
	}
	fclose(yyin);
	return 0;
}

yyerror(char *s)
{
	printf("\nLine %d : %s %s\n",yylineno,s,yytext);
}

int printline()
{
	return yylineno;
}
void push()
{
	stack[top]=i;
	i++;
	top++;
	return;
}
void pop()
{
	top--;
	end[stack[top]]=1;
	stack[top]=0;
	return;
}

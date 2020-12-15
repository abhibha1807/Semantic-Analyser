#include<stdio.h>
#include<string.h>
// stores everything abt a var and function
struct sym
{
	int sno;
	char token[100]; // stores name of vars, funs
	int type[100]; // stores token no corresponding to the datatype of the fun/var
	int paratype[100];
	int tn; // no of tokens
	int pn; // no of parameters
	int scope;
}st[100]; //
int n=0,arr[10];



// match token val and return highest scope
// cs = current scope
int returnscope(char *a,int cs)
{
	int i;
	int max = 0;
	for(i=0;i<=n;i++)
	{
		if(!strcmp(a,st[i].token) && cs>=st[i].scope)
		{
			if(st[i].scope>=max)
				max = st[i].scope;
		}
	}
	return max;
}
// checking if the var exists or not
// n denotes number of objects in the structure
int lookup(char *a)
{
	int i;
	for(i=0;i<n;i++)
	{
		if( !strcmp( a, st[i].token) )
			return 0;
	}
	return 1;
}
// return a, tau a ka returntype batayega
int returntype(char *a,int sct)
{
	int i;
	for(i=0;i<n;i++)
	{
		if(!strcmp(a,st[i].token) && st[i].scope==sct)
			return st[i].type[0];
	}
	return 1;
}

// first match token value and then insert scope
void insertscope(char *a,int s)
{
	int i;
	for(i=0;i<n;i++)
	{
		if(!strcmp(a,st[i].token))
		{
			st[i].scope=s;
			break;
		}
	}
}

// func ka returntype return krta h
int returntypef(char *a)
{
	int i;
	for(i=0;i<n;i++)
	{
		if(!strcmp(a,st[i].token))
			{ return st[i].type[1];}
	}
	return 1;
}


// create a new object (reverse)

void insert(char *name, int type)
{
	int i;
	if(lookup(name)) //if it does not exist, create var
	{
		strcpy(st[n].token,name);
		st[n].tn=1; // flags being set to detect redeclaration of var
        st[n].pn=0;
		st[n].type[st[n].tn-1]=type;
		st[n].sno=n+1;
		n++;
	}
	else // update the var 
	{
		for(i=0;i<n;i++)
		{
			if(!strcmp(name,st[i].token))
			{
				st[i].tn++;
				st[i].type[st[i].tn-1]=type;
				break;
			}
		}
	}

	return;
}
// counter=ct , arr stores retyrn types 
int returntype_func(int ct)
{
	return arr[ct-1];
}

// ct is a counter for array 'arr' which is storing datatype of var returned
void storereturn( int ct, int returntype )
{
	arr[ct] = returntype;
	return;
}
void insert_dup(char *name, int type, int s_c)
{
	strcpy(st[n].token,name);
	st[n].tn=1;
    st[n].pn=0;
	st[n].type[st[n].tn-1]=type;
	st[n].sno=n+1;
	st[n].scope=s_c;
	n++;
	return;
}

// for fun parameters
void insertp(char *name,int type)
{
 	int i;
 	for(i=0;i<n;i++)
 	{
  		if(!strcmp(name,st[i].token))
  		{
   			st[i].pn++; 
   			st[i].paratype[st[i].pn-1]=type;
   			break;
  		}
 	}
}
// jis type ke var fun call ke time hai, usi type ke fun ke definition mai hai
int checkp(char *name,int flist,int c)
{
 	int i,j;
 	for(i=0;i<n;i++)
 	{
  		if(!strcmp(name,st[i].token))
  		{
    			if(st[i].paratype[c]!=flist)
    			return 1;
  		}
 	}
 	return 0;
}

void display()
{
	int i,j;
	printf("\n");
	printf("Identifier\t\tType\t\t\tParameter type(for functions)\n");
	for(i=0;i<n;i++)
	{
		if(st[i].type[0]==258 || st[i].type[1]==258 || st[i].type[1]==260)
			printf("%s\t",st[i].token);
		else
			printf("%s\t",st[i].token);
                printf("\t\t");
		for(j=0;j<st[i].tn;j++)
		{
			if(st[i].type[j]==258)
				printf("INT");
			else if(st[i].type[j]==259)
				printf("FLOAT");
			else if(st[i].type[j]==271)
				printf("FUNCTION");
			else if(st[i].type[j]==260)
				printf("VOID");
                        if(st[i].tn>1 && j<(st[i].tn-1))printf(" - ");
		}
                printf("\t\t");
		for(j=0;j<st[i].pn;j++)
		{
			if(st[i].paratype[j]==258)
				printf("INT");
			else if(st[i].paratype[j]==259)
				printf("FLOAT");
			if(st[i].pn>1 && j<(st[i].pn-1))printf(", ");
		}
		printf("\n");
	}
	return;
}
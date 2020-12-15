#include <stdio.h>
void foo (int x)
{
	return;
}

int main()
{
	int a=9;
	foo(a);
	float b=8;

	return 0;
}

/* assignment : ID '=' consttype
	| ID '+' assignment /* --------------*/
/*	| ID ',' assignment /* --------------*/
/*	| consttype ',' assignment /* --------------*/
/*	| ID
	| consttype
	;*/
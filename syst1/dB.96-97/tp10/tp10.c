#include <stdio.h>

int count = 0;
int * ints = NULL;

float tabs(float x) {if (x < 0) return(-x); else return(x);}

void remove_int(int item) {
	int * ints_tmp = (int *) malloc(sizeof(int)*--count);
	int i; 
	printf("\nremoving furthmost from mean : %d", ints[item]);
	for(i=0;i<item;i++) ints_tmp[i] = ints[i];
	for(;i<count;i++) ints_tmp[i] = ints[i+1];
	free(ints);
	ints = ints_tmp;	
}

long_mean(float mv) {
	float t; int i, ipos = 0;
	if (count == 0) return;
	t = ints[0];
	for(i=0;i<count;i++) if (tabs(mv-ints[i])>tabs(mv-t)) {t = ints[i]; ipos = i;}
	remove_int(ipos);
	for(i=0;i<count;i++) if (tabs(mv-ints[i])==tabs(mv - t)) remove_int(i--);
}

float mean_value(void) {
	float iret = 0;
	int i; 
	if (count == 0) return(0);
	for(i=0;i<count;i++) iret += ints[i];
	return(iret / count);
}

void add_int(int value) {
	int * ints_tmp = (int *) malloc(sizeof(int)*++count);
	int i; for(i=0;i<count - 1;i++) ints_tmp[i] = ints[i];
	free(ints);
	ints = ints_tmp;
	ints[count - 1] = value;
	printf("adding integer %d\n", value);
}

void generate_sort(void)
{
	int i, j, t;
	for (i=1;i<count;i++)
		for (j=count-1;i<=j;j--)
			if (ints[j]<ints[j-1]){
				t = ints[j];
				ints[j] = ints[j-1];
				ints[j-1] = t;
				}
}

void main(void) {
	int t;
	float mv;
 	while (scanf("%d", &t)) add_int(t);
	printf("\nnon-sorted list              : "); for (t = 0;t<count;t++) printf("%d ", ints[t]);
	printf("\nmean value                   : "); mv = mean_value(); printf("%f", mv);
	long_mean(mv);
	generate_sort();
	printf("\nsorted remaining list        : "); for (t = 0;t<count;t++) printf("%d ", ints[t]);
	printf("\nTP10 - (c) Daniel Doubrovkine - doubrov5@cui.unige.ch - All Rights Reserved\n");
}

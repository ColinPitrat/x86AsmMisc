#include <stdio.h>

int main(int argc, char **argv)
{
  if(argc != 2)
  {
    printf("Syntaxe : %s <fichier>\n",argv[0]);
    return -1;
  }
  else
  {
    FILE *fichier = fopen(argv[1], "r");
    int i = 1;
    int a;
    unsigned long int sum = 0;
    int nbVal = 0;
    while(i == 1)
    {
      i = fscanf(fichier, "%u", &a);
      if(i == 1)
      {
	sum += a;
	nbVal++;
      }
    }
    printf("Somme : %u\n", sum);
    printf("Nombre de valeurs : %u\n", nbVal);
    printf("Moyenne : %f\n", ((float) sum) / nbVal);
    return 0;
  }
}

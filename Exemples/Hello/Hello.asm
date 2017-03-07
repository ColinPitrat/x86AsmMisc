/*
  Hello.asm

  -=(the3fold)=-
  Premier exemple en assembleur 

  Affiche "Hello World !" puis retourne à la ligne
  avant de rendre la main.
*/

.section .text
.global _start   
_start:
# Affiche une chaine de caractères
  movl    $4, %eax
  movl    $1, %ebx					# stdout
  movl    $chaine1, %ecx
  movl    (longueurChaine), %edx
  int $0x80

# Fin du programme
  movl    $1, %eax
  int $0x80

.section .data              
chaine1:	.string	"Hello World !\n"   
longueurChaine: .int    longueurChaine - chaine1

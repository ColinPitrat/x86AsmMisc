.section .text
.global _start
_start:
  /* Récupère le nombre d'arguments (incluant le nom du programme) */
  pop %eax
  cmp $2, %eax
  jne mauvaise_syntaxe
  /* Le nom du programme */
  pop %eax
  /* Le premier argument, directement dans ecx pour appeler write ensuite */
  pop %ecx

  /* Compte le nombre de caractères à afficher (c'est à dire la longueur de l'argument) */
  xor %edx, %edx
compte:
  cmpb $0, (%ecx, %edx, 1)
  je affiche
  inc %edx
  jmp compte

affiche:
  /* Affiche l'argument */
  mov $4, %eax
  mov $1, %ebx
  int $0x80

  /* Ajoute un retour chariot */
  mov $4, %eax
  mov $1, %ebx
  mov $retour_chariot, %ecx
  mov length_retour_chariot, %edx
  int $0x80

fin:
  /* Quitte */
  xor %ebx, %ebx
  mov $1, %eax
  int $0x80

mauvaise_syntaxe:
  /* Affiche l'argument */
  mov $4, %eax
  mov $1, %ebx
  mov $syntaxe, %ecx
  mov length_syntaxe, %edx
  int $0x80

  /* Quitte avec code d'erreur 1 */
  mov $1, %eax
  mov $1, %ebx
  int $0x80

.section .data
syntaxe:
  .string "Utilisation: Echo <message a afficher>\n"
length_syntaxe:
  .int length_syntaxe - syntaxe
retour_chariot:
  .string "\n"
length_retour_chariot:
  .int length_retour_chariot - retour_chariot

// vim: syntax=asm 

.section .bss
.macro quit rc
    movl  $1, %eax
    movl  \rc, %ebx
    int   $0x80
.endm

.macro write str, str_size 
    movl  $4, %eax
    movl  $1, %ebx
    movl  \str, %ecx
    movl  \str_size, %edx
    int   $0x80
.endm

.macro atoi str, base, value, err
  xor %eax, %eax
  xor %edx, %edx
  xor %esi, %esi
convertit_\@:
  mov \base, %ecx
  mul %ecx
  mov (\str, %esi, 1), %dl
  /* On arrête dès qu'un caractère rencontré n'est pas un chiffre ou un caractère en majuscule (on pourrait ameliorer en gêrant les minuscules !)*/
  cmp $48, %edx
  jb finished_\@
  cmp $57, %edx
  ja majuscule_\@
  /* Si on arrive ici, c'est un nombre. On enlève 48 (0=48 en ASCII) */
  sub $48, %edx
  jmp suivant_\@
majuscule_\@:
  cmp $65, %edx
  jb finished_\@
  cmp $90, %edx
  ja minuscule_\@
  /* Si on arrive ici, c'est une lettre majuscule. On enlève 55 (A=65 en ASCII vaut 10) */
  sub $55, %edx
  jmp suivant_\@
minuscule_\@:
  cmp $97, %edx
  jb finished_\@
  cmp $122, %edx
  ja finished_\@
  /* Si on arrive ici, c'est une lettre minuscule. On enlève 87 (a=97 en ASCII vaut 10) */
  sub $87, %edx
suivant_\@:
  /* Si le résultat est plus grand que ou égal à la base, ce ne peut être un caractère appartenant au nombre ! */
  cmp \base, %edx
  jae finished_\@
  add %edx, %eax
  inc %esi
  jmp convertit_\@
finished_\@:
  movl $0, \err
  cmp $0, %edx
  je ok_\@
  movl $1, \err
ok_\@:
  xor %edx, %edx
  mov \base, %ecx
  div %ecx
  mov %eax, \value
.endm

.section .text
.global _start
_start:
  pop %eax
  cmp $4, %eax
  jne mauvaise_syntaxe
  pop %eax
  /* Récupère la base d'entrée */
  pop %ebx
  atoi %ebx, $10, ibase, ok
  cmp $0, ok
  jne erreur_ibase
  /* Récupère la base de sortie */
  pop %ebx
  atoi %ebx, $10, obase, ok
  cmp $0, ok
  jne erreur_obase
  /* Récupère le nombre à convertir */
  pop %ebx
  atoi %ebx, ibase, %eax, ok
  cmp $0, ok
  jne erreur_nombre

  /* Convertit le résultat en chaine de caractère et l'affiche
      - eax contient le résultat
      - esi est l'index du caractère courant
   */
  xor %esi, %esi
  /* Prévois un retour chariot à la fin du nombre et incrémente la taille en conséquence */
  push $10
  inc %esi
convertit3:
  xor %edx, %edx
  mov obase, %ecx
  div %ecx
  cmp $9, %edx
  ja carac2
  add $48, %edx
  jmp nombre2
carac2:
  add $55, %edx
nombre2:
  push %edx
  inc %esi
  cmp $0, %eax
  jnz convertit3

convertit4:
  cmp $0, %esi
  jz fin
  dec %esi

  /* Affiche un caractère */
  write %esp, $1
  add $4, %esp
  jmp convertit4

fin:
  /* Quitte */
  quit $0

mauvaise_syntaxe:
  /* Affiche l'aide puis quitte avec le code d'erreur 1 */
  write $syntaxe, length_syntaxe
  quit $1

erreur_ibase:
  write $err_ibase, length_err_ibase
  quit $2

erreur_obase:
  write $err_obase, length_err_obase
  quit $3

erreur_nombre:
  write $err_nombre, length_err_nombre
  quit $4

.section .data
ibase:
  .int 0
obase:
  .int 0
ok:
  .int 0
syntaxe:
  .string "Utilisation: BaseConversion <ibase> <obase> <nombre>\n"
length_syntaxe:
  .int length_syntaxe - syntaxe
err_ibase:
  .string "Erreur lors de la lecture de la base d'entrée\n"
length_err_ibase:
  .int length_err_ibase - err_ibase
err_obase:
  .string "Erreur lors de la lecture de la base de sortie\n"
length_err_obase:
  .int length_err_obase - err_obase
err_nombre:
  .string "Erreur lors de la lecture du nombre à convertir dans la base d'entrée\n"
length_err_nombre:
  .int length_err_nombre - err_nombre

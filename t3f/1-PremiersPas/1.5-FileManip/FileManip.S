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
  /* Vérifie le nombre d'arguments */
  pop %eax
  cmp $3, %eax
  jne mauvaise_syntaxe
  /* Ignore le nom de l'executable */
  pop %ebx
  /* Récupère l'operation a effectuer */
  pop %ebx
  atoi %ebx, $10, operation, ok
  cmp $0, ok
  jne erreur_operation
  /* Récupère le nom de fichier */
  pop %ebx

  cmp $1, operation
  je cree_fichier
  cmp $2, operation
  je supprime_fichier
  cmp $3, operation
  je cree_repertoire
  cmp $4, operation
  je supprime_repertoire
  jmp operation_inconnue

  /* TODO: Gérer les erreurs ! */
cree_fichier:
  /* Le nom de fichier est déjà dans ebx */
  movl $0x0e, %eax
  /* S_IFREG (regular file) = 01000   = 0x200
     auquel on ajoute les permissions: 0777 = 0x1FF
     => mode = 0x3FF */
  movl $0x3FF, %ecx
  int   $0x80
  jmp fin
supprime_fichier:
  /* Le nom de fichier est déjà dans ebx */
  movl $0xa, %eax
  int   $0x80
  jmp fin
cree_repertoire:
  /* Le nom de repertoire est déjà dans ebx */
  movl $0x27, %eax
  /* Seulement les permissions: 0777 = 0x1FF
     => mode = 0x3FF */
  movl $0x1FF, %ecx
  int   $0x80
  jmp fin
supprime_repertoire:
  /* Le nom de repertoire est déjà dans ebx */
  movl $0x28, %eax
  int   $0x80
  jmp fin

fin:
  /* Quitte */
  quit $0

mauvaise_syntaxe:
  /* Affiche l'aide puis quitte avec le code d'erreur 1 */
  write $syntaxe, length_syntaxe
  quit $1

erreur_operation:
  write $err_operation, length_err_operation
  quit $2

operation_inconnue:
  write $err_operation_inconnue, length_err_operation_inconnue
  quit $3

.section .data
operation:
  .int 0
ok:
  .int 0

syntaxe:
  .string "Utilisation: FileManip <operation> <nom de fichier>\navec operation = 1, 2, 3 ou 4 (resp. crée fichier, supprime fichier, crée repertoire, supprime repertoire)\n"
length_syntaxe:
  .int length_syntaxe - syntaxe
err_operation:
  .string "Erreur lors de la lecture du numéro de l'opération\n"
length_err_operation:
  .int length_err_operation - err_operation
err_operation_inconnue:
  .string "Operation inconnue !\n"
length_err_operation_inconnue:
  .int length_err_operation_inconnue - err_operation_inconnue

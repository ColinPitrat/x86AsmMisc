.section .text
.global _start
_start:
  /* Demande un 1er nombre */
  mov $4, %eax
  mov $1, %ebx
  mov $texte1, %ecx
  mov length1, %edx
  int $0x80

  /* Lit le 1er nombre depuis l'entrée standard (descripteur de fichier 0) */
  mov $3, %eax
  mov $0, %ebx
  mov $nombre1_texte, %ecx
  mov $24, %edx
  int $0x80

  /* Demande un 2nd nombre */
  mov $4, %eax
  mov $1, %ebx
  mov $texte2, %ecx
  mov length2, %edx
  int $0x80

  /* Lit le 2nd nombre depuis l'entrée standard (descripteur de fichier 0) */
  mov $3, %eax
  mov $0, %ebx
  mov $nombre2_texte, %ecx
  mov $24, %edx
  int $0x80

  /* Convertit le 1er nombre 
      - eax contient le résultat
      - ebx pointe sur la chaine de caractère
      - esi est l'index du caractère courant
   */
  xor %eax, %eax
  mov $nombre1_texte, %ebx 
  xor %esi, %esi
convertit1:
  mov $10, %ecx
  mul %ecx
  mov (%ebx, %esi, 1), %dl
  /* On arrête dès qu'un caractère rencontré n'est pas un chiffre */
  cmp $48, %edx
  jb finished1
  cmp $57, %edx
  ja finished1
  sub $48, %edx
  add %edx, %eax
  inc %esi
  jmp convertit1
finished1:
  xor %edx, %edx
  mov $10, %ecx
  div %ecx
  mov %eax, nombre1

  /* Convertit le 2nd nombre 
      - eax contient le résultat
      - ebx pointe sur la chaine de caractère
      - esi est l'index du caractère courant
   */
  xor %eax, %eax
  mov $nombre2_texte, %ebx 
  xor %esi, %esi
convertit2:
  mov $10, %ecx
  mul %ecx
  mov (%ebx, %esi, 1), %dl
  /* On arrête dès qu'un caractère rencontré n'est pas un chiffre */
  cmp $48, %edx
  jb finished2
  cmp $57, %edx
  ja finished2
  sub $48, %edx
  add %edx, %eax
  inc %esi
  jmp convertit2
finished2:
  xor %edx, %edx
  mov $10, %ecx
  div %ecx
  mov %eax, nombre2

  /* Additionne les deux nombres */
  add nombre1, %eax
  mov %eax, resultat

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
  mov $10, %ecx
  div %ecx
  add $48, %edx
  push %edx
  inc %esi
  cmp $0, %eax
  jnz convertit3

convertit4:
  cmp $0, %esi
  jz fin
  dec %esi

  /* Affiche un caractère */
  mov $4, %eax
  mov $1, %ebx
  mov %esp, %ecx
  mov $1, %edx
  int $0x80
  add $4, %esp
  jmp convertit4

fin:
  /* Quitte */
  xor %ebx, %ebx
  mov $1, %eax
  int $0x80

.section .data
texte1:
  .string "Entrez le 1er nombre: "
length1:
  .int length1 - texte1
texte2:
  .string	"Entrez le 2nd nombre: "
length2:
  .int length2 - texte2
texte3:
  .string	"J'ai lu "
length3:
  .int length3 - texte3
nombre1:
  .int 0
nombre2:
  .int 0
resultat:
  .int 0

.section .bss
/* On permet jusqu'à 24 caractères pour chaque nombre */
  .lcomm nombre1_texte, 24
  .lcomm nombre2_texte, 24

.section .text
.global _start
_start:
  /* Récupère le timestamp UNIX et les microsecondes avec l'appel système gettimeofday */
  mov $0x4e, %eax
  mov $timestamp, %ebx
  xor %ecx, %ecx
  int $0x80

  /* Convertit le résultat en chaine de caractère et l'affiche
      - eax contient le timestamp à afficher
      - esi est l'index du caractère courant
   */
  mov timestamp, %eax
  xor %esi, %esi
  /* Prévois un retour chariot à la fin du nombre et incrémente la taille en conséquence */
  push $10
  inc %esi
convertit:
  xor %edx, %edx
  mov $10, %ecx
  div %ecx
  add $48, %edx
  push %edx
  inc %esi
  cmp $0, %eax
  jnz convertit

affiche:
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
  jmp affiche

fin:
  /* Quitte */
  xor %ebx, %ebx
  mov $1, %eax
  int $0x80

.section .data
timestamp:
  .int 0
microsecondes:
  .int 0

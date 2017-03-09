.section .text
.global _start
# Il y a trois types d'appels standard pour passer les arguments d'une fonction:
#  - passer par les registres (c'est le cas des appels systemes, par le biais de l'interruption 0x80
#  - __cdecl: passage par la pile, la restauration de la pile étant géré par l'appelant (supporte un nombre variable d'argument)
#  - __stdcall: passage par la pile, la restauration de la pile étant géré par la fonction (nombre d'argument nécessairement fixe)
# cf. http://unixwiz.net/techtips/win32-callconv-asm.html

_start:
  # Premier appel, passage des valeurs par registre
  mov $5, %eax
  mov $3, %ebx
  call diff_mul_add_reg

  # Mise à zero des registres, pour s'assurer que le premier appel n'influence pas le second
  xor %eax, %eax
  xor %ebx, %ebx
  xor %ecx, %ecx
  xor %edx, %edx

  # Deuxième appel, passage des valeurs par la pile
  push $5
  push $3
  call diff_mul_add_cdecl
  pop %ecx
  pop %ecx

  # Mise à zero des registres, pour s'assurer que le deuxième appel n'influence pas le troisième
  xor %eax, %eax
  xor %ebx, %ebx
  xor %ecx, %ecx
  xor %edx, %edx

  # Troisième appel, passage des valeurs par la pile (encore)
  push $7
  push $7
  call diff_mul_add_cdecl
  pop %ecx
  pop %ecx

  mov %eax, %ebx
  mov $1, %eax
  int $0x80

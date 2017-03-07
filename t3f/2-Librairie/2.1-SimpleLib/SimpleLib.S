.section .text
.global _start
_start:
  call affiche_bonjour

  xor %ebx, %ebx
  mov $1, %eax
  int $0x80

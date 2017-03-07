.section .text
.global _start
_start:
  mov $4, %eax
  mov $1, %ebx
  mov $texte, %ecx
  mov length, %edx
  int $0x80

  xor %ebx, %ebx
  mov $1, %eax
  int $0x80

.section .data
texte:
	.string	"Bonjour !\n"
length:
  .int length - texte

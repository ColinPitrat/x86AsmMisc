.section .text
.global affiche_bonjour
affiche_bonjour:
  mov $4, %eax
  mov $1, %ebx
  mov $texte, %ecx
  mov length, %edx
  int $0x80
  ret

.section .data
texte:
	.string	"Bonjour !\n"
length:
  .int length - texte

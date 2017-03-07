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


.section .text
.global _start
_start:
  /* Appel à getuid pour récupérer le user ID */
  movl $0xc7, %eax
  int   $0x80
  /* Root a le uid 0 */
  cmp $0, %eax
  jne not_root
root:
  write $root_message, length_root_message
  jmp fin
not_root:
  write $not_root_message, length_not_root_message

fin:
  /* Quitte */
  quit $0

.section .data
root_message:
  .string "Vous êtes root\n"
length_root_message:
  .int length_root_message - root_message
not_root_message:
  .string "Vous n'êtes pas root\n"
length_not_root_message:
  .int length_not_root_message - not_root_message

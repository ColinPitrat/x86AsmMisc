.section .text
.global _start
_start:
  xor %eax, %eax	
  movl $msg, %esi
  movl (msg_len), %ecx

boucle: 
  lodsb
  cmp $0, %ecx		
  je fin_chaine
  push %eax
  loop boucle

fin_chaine:
  movl (msg_len), %ecx
  movl $msg, %esi

reboucle:	
  pop %eax
  mov %al, (%esi)
  inc %esi
  loop reboucle
	
  movl $4, %eax
  movl $1, %ebx		
  movl $msg, %ecx
  movl (msg_len), %edx
  int $0x80

  movl $4, %eax
  movl $1, %ebx		
  movl $cr, %ecx
  movl (cr_len), %edx
  int $0x80

  movl $1, %eax
  int $0x80	

.section .data
msg: .string "Hello World !"
msg_len: .int msg_len - msg	
cr:  .string "\n"
cr_len: .int cr_len - cr

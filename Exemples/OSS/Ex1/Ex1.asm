/*
  Ex1.asm

  -=(the3fold)=-
  Premier exemple d'utilisation de OSS

  Initialise OSS puis joue un sample
*/

.section .text
.global _start
  movl $5, %eax
  movl $devdsp, %ebx
  movl $1, %ecx
  int $0x80
  cmp 0, %eax
  je error
  movl %eax, (file_desc)

# On passe en mono ...
  movl $54, %eax
  movl (file_desc), %ebx
  movl $SNDCTL_DSP_STEREO, %ecx 
  movl $channels, %edx
  int $0x80
  cmp 0, %eax
  je error

# On passe en 8 bits
  movl $54, %eax
  movl (file_desc), %ebx
  movl $SNDCTL_DSP_SETFMT, %ecx
  movl $format, %edx
  int $0x80
  cmp 0, %eax
  je error
  
# On passe en 22 kHz
  movl $54, %eax
  mov (file_desc), %ebx
  mov $SNDCTL_DSP_SPEED, %ecx
  mov $rate, %edx
  int $0x80
  cmp 0, %eax
  je error

# On crée un sample
  mov $data, %edi
  mov $22050, %ecx
  xor %al, %al
  create_data:
    stosb
    inc %al
    dec %ecx
  jnz create_data

# On envoi le sample 
  mov 4, %eax
  mov (file_desc), %ebx
  mov $data, %ecx
  mov $22050, %edx
  int $0x80
  cmp 0, %eax
  je error

# On affiche un message d'erreur
error:

# On quitte
fin:
  movl $1, %eax
  int  $0x80

.section .data
devdsp: .string "/dev/dsp\0"
channels: .double 0
format: .double 8
rate: .double 22050

.lcomm file_desc, 4
.lcomm data, 88200

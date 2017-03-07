/*
  Show.asm

  -=(the3fold)=-
  Troisième exemple en assembleur 

  Affiche le fichier file.txt situé dans le même répertoire
  que l'executable, puis rend la main.
*/

.section .text
.global _start   
_start:
# Ouvre le fichier
  movl    $5, %eax
  movl    $fichier, %ebx
  xor     %ecx, %ecx				# 0_RDONLY
  int     $0x80
  cmp     $0, %eax 
  jl      erreur
  movl    %eax, (file_desc)

boucle:
# Lit le contenu du fichier dans le buffer
  movl    $3, %eax
  movl    (file_desc), %ebx
  movl    $buffer, %ecx
  movl    (longueurBuffer), %edx
  int     $0x80
  cmp     $0, %eax 
  jl      erreur
  movl    %eax, (lu)

# Affiche le contenu du buffer
  movl    $4, %eax
  movl    $1, %ebx				# stdout
  movl    $buffer, %ecx
  movl    (lu), %edx
  int     $0x80
  cmp     $0, %eax 
  jl      erreur

# Verifie si on a finit
  movl    (lu), %eax
  cmp     %eax, (longueurBuffer)
  je      boucle
  jmp     fin

# Affiche un message d'erreur
erreur:
  movl    $4, %eax
  movl    $2, %ebx				# stderr
  movl    $erreurmsg, %ecx
  movl    (longueurErreurmsg), %edx
  int     $0x80

fin:
# Ferme le fichier
  movl    $6, %eax
  movl    (file_desc), %ebx
  int     $0x80

# Fin du programme
  movl    $1, %eax
  int     $0x80

.section .data              
fichier:     	   .string	"file.txt"   
file_desc:         .int         0
longueurBuffer:    .int         255 
lu:                .int         0
erreurmsg:         .string      "Erreur de lecture du fichier\n"
longueurErreurmsg: .int         longueurErreurmsg - erreurmsg

.comm buffer,255


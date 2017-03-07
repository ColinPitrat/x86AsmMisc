.section .text
.global _start
_start:
# Recupère argc, et verifie argc == 2 puis récupère argv
  popl   %eax
  cmp    $2, %eax
  jne    help
  movl   %eax, (argc)
  popl   %edi
  movl   %edi, (argv)

# Cherche le premier 0 dans la chaine pointé par argv, puis le suivant
  cld							# Le sens de lecture est le sens habituel
  xor    %ecx, %ecx
  dec    %ecx						# On met ecx au maximum
# movl   $1, %ecx					# Provoque une erreur : on ne trouve pas de fin de chaine
  xor    %al, %al

  movl   (argv), %edi
  repnz  scasb						# On saute le nom du programme
  jnz    erreur
  movl   %edi, %ebx					# %ebx pointe sur le début du premier argument
  							# On ne peut pas utiliser directement %ecx qui sert de compteur

  repnz  scasb						# On va jusqu'à la fin du premier argument
  jnz    erreur
  movl   %edi, %edx
  dec    %edx						# %edx pointe sur le caractère nul suivant le premier argument

# Affiche le paramètre
  movl   %ebx, %ecx
  movl   $4, %eax
  movl   $1, %ebx
  subl   %ecx, %edx
  int    $0x80

# Ajoute un retour chariot
  movl   $4, %eax
  movl   $1, %ebx
  movl   $retourChariot, %ecx
  movl   (longueurRC), %edx
  int    $0x80
  jmp    quit

# Affiche le message d'aide
help:
  movl   $4, %eax
  movl   $1, %ebx
  movl   $helpmsg, %ecx
  movl   (longueurHelpmsg), %edx
  int    $0x80
  jmp    quit

# Affice le message d'erreur
erreur:
  movl   $4, %eax
  movl   $2, %ebx
  movl   $errormsg, %ecx
  movl   (longueurErrmsg), %edx
  int    $0x80

# Fin du programme
quit:
  movl   $1, %eax
  int    $0x80

.section .data
helpmsg:         .string "Syntaxe : Echo <message>\n"
longueurHelpmsg: .int    longueurHelpmsg - helpmsg
errormsg:        .string "Une erreur est survenue\n"
longueurErrmsg:  .int    longueurErrmsg - errormsg
retourChariot:   .string "\n"
longueurRC:      .int    longueurRC - retourChariot
argc:            .int    0
argv:            .int    0


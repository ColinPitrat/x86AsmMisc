/*
  Nom.asm

  -=(the3fold)=-
  Second exemple en assembleur 

  Demande le nom de l'utilisateur, puis le réaffiche 
  avant de rendre la main.
*/

.section .text
.global _start   
_start:
# Affiche la question
  movl    $4, %eax
  movl    $1, %ebx				# stdout
  movl    $question, %ecx
  movl    (longueurQuestion), %edx
  int $0x80

# Lit la réponse
  movl    $3, %eax
  movl    $0, %ebx				# stdin
  movl    $reponse, %ecx
  movl    (longueurReponse), %edx
  int     $0x80
  dec     %eax					# Supprime le retour chariot
  movl    %eax, (longueurReponse)

# Affiche une phrase utilisant la réponse
  movl    $4, %eax
  movl    $1, %ebx
  movl    $phrase, %ecx
  movl    (longueurPhrase), %edx
  int $0x80

  movl    $4, %eax
  movl    $1, %ebx
  movl    $reponse, %ecx
  movl    (longueurReponse), %edx
  int $0x80

  movl    $4, %eax
  movl    $1, %ebx
  movl    $finphrase, %ecx
  movl    (longueurFinphrase), %edx
  int $0x80

# Fin du programme
  movl    $1, %eax
  int $0x80

.section .data              
question:     	   .string	"Quel est votre nom ? "   
longueurQuestion:  .int          longueurQuestion - question
phrase:            .string       "Bonjour "
longueurPhrase:    .int          longueurPhrase - phrase
longueurReponse:   .int          255
finphrase:         .string       " !\n"
longueurFinphrase: .int          longueurFinphrase - finphrase

.comm reponse,255


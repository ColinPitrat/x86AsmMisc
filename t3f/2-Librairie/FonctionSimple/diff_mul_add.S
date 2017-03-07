.section .text
.global diff_mul_add_reg
.global diff_mul_add_cdecl
.global diff_mul_add_stdcall

# Calcule (a*b) - (a+b)
# Entrées: %eax = a, %ebx = b
# Sortie: %eax = (a*b) - (a+b)
# Registres altérés: %eax, %ecx
diff_mul_add_reg:
  mov %ebx, %ecx
  add %eax, %ecx
  mul %ebx
  sub %ecx, %eax
  ret

diff_mul_add_cdecl:
  # Sauvegarde %ebp
  push %ebp
  # Fait pointer %ebp sur la valeur sauvegardée
  mov %esp, %ebp
  # On pourrait ici allouer de la place pour deux variables locales avec:
  #sub $8, %esp
  # On adresse maintenant les parametres avec 8(%ebp) (premier parametre) ou 12(%ebp) (deuxieme parametre)
  # et les variables locales si il y'en a avec -4(%ebp) (première variable locale) ou -8(%ebp) (deuxième variable locale). 
  # Entre les deux, on a: 4(%ebp) qui contient l'ancien %eip et 0(%ebp) qui contient l'ancien %ebp
  mov 8(%ebp), %eax
  mov %eax, %ecx
  mov 12(%ebp), %ebx
  add %ebx, %ecx
  mul %ebx
  sub %ecx, %eax
  # Si l'on avait modifier %esp pour allouer des variables locales, il faudrait le restaurer:
  # L'instruction leave est équivalente à ces deux lignes (restaurer %esp et %ebp)
  #mov %ebp, %esp
  pop %ebp
  ret

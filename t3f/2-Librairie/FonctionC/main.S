	.file	"main.c"
	.text
	.globl	addition
	.type	addition, @function
addition:
.LFB0:
    # Sauvegarde %ebp
	pushl	%ebp
    # Fait pointer %ebp sur la valeur sauvegardée
	movl	%esp, %ebp
    # Alloue de la place pour 16 octets (2*8 octets pour les variables, 8 autres pourquoi ?)
	subl	$16, %esp
    # Place le premier parametre (a) dans %eax
	movl	8(%ebp), %eax
    # Place %eax (donc a) dans la première variable locale (temporaire)
	movl	%eax, -4(%ebp)
    # Place le deuxième parametre (b) dans %eax
	movl	12(%ebp), %eax
    # Place la première variable locale (temporaire) dans %edx
	movl	-4(%ebp), %edx
    # Additionne %edx (donc temporaire) et %eax (donc b)
	addl	%edx, %eax
    # Place le résultat dans la deuxième variable locale (result)
	movl	%eax, -8(%ebp)
    # Place result dans %eax
	movl	-8(%ebp), %eax
    # Restaure %esp et %ebp. Equivalent de: 
    #mov %ebp, %esp
    #pop %ebp
	leave
    # Retourne de la fonction, le résultat est donc dans %eax
	ret
.LFE0:
	.size	addition, .-addition
	.globl	main
	.type	main, @function
main:
.LFB1:
	pushl	%ebp
	movl	%esp, %ebp
    # Equivalent de push $3 et push $5
	subl	$8, %esp
	movl	$3, 4(%esp)
	movl	$5, (%esp)
	call	addition
	leave
	ret
.LFE1:
	.size	main, .-main
	.ident	"GCC: (GNU) 4.8.2 20131219 (prerelease)"
	.section	.note.GNU-stack,"",@progbits

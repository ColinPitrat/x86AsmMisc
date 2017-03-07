.section .text
.global GetValueFromASM
GetValueFromASM:
    # On ne modifie que %ebx, on peut donc se permettre de ne pas sauver %esp, %ebp ...
    mov no, %ebx
    mov %ebx, val
    mov val, %eax
    ret

.section .data
no:
    .int 100
val:
    .int 0

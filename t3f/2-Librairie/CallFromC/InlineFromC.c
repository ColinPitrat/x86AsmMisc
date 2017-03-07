#include <stdio.h>

int GetValueFromASM()
{
    //asm("mov $39, %eax");
    int no = 100, val = 0;
    asm("mov %1, %%ebx;" 
        "mov %%ebx, %0;" 
        : "=r" (val)
        : "r" (no)
        : "%ebx");
    return val;
}

int main()
{
    printf("Assembly function returned %u\n", GetValueFromASM());
    return 0;
}

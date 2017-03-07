#include <stdio.h>

extern int GetValueFromASM();

int main()
{
    printf("Assembly function returned %u\n", GetValueFromASM());
    return 0;
}

#include <iostream>

extern "C" int GetValueFromASM();

int main()
{
    std::cout << "Assembly function returned " << GetValueFromASM() << std::endl;
    return 0;
}

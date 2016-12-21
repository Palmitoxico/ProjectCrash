#include "stm32f407xx.h"
#include "arm_math.h"

int main()
{
	volatile float32_t test = arm_cos_f32(3.14);

	while(1)
	{
		
	}
	return 0;
}

#include "stm32f407xx.h"
#include "arm_math.h"
#include "clockconfig.h"

#define GPIO_MODER_MODER12_Pos 24

int main()
{
	/*
	 * Configures the microcontroller clocks
	 * HCLK = 168MHz
	 * APB1 = 42MHz
	 * APB2 = 84MHz
	 */
	ClockConfig();

	/*
	 * Enable the SysTick timer with the CPU
	 * clock divided by 8 (21MHz) and a period
	 * of 500ms
	 */
	SysTick->CTRL = SysTick_CTRL_TICKINT_Msk | SysTick_CTRL_ENABLE_Msk;
	SysTick->LOAD = 10500000;

	/*
	 * Enables the GPIOD clock and configures
	 * the PD12 pin as a GPIO output
	 */
	RCC->AHB1ENR |= RCC_AHB1ENR_GPIODEN;
	GPIOD->MODER |= (1 << GPIO_MODER_MODER12_Pos);
	
	/*
	 * Enable the SysTick Timer interrupt
	 * with priority 2 of 7
	 */
	NVIC_SetPriority(SysTick_IRQn, 2);
	NVIC_EnableIRQ(SysTick_IRQn);
	__enable_irq();


	/*
	 * Infinite loop
	 */
	while(1)
	{
		
	}
	return 0;
}

/*
 * SysTick Timer Interrupt routine
 */
void SysTick_Handler()
{
	/*
	 * Toggles the pin PD12	(Blink the LED)
	 */
	GPIOD->ODR ^= (1 << 12);
}

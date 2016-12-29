/*
 * This code is responsible for 'playing'
 * the beats at a specified time.
 */

#include "stm32f407xx.h"

#define BeatsBufferSize 16
#define GPIO_MODER_MODER12_Pos 24

static volatile uint64_t UniversalTime = 1, BeatMarks[BeatsBufferSize];

/*
 * Initializes the beat sequencer
 */
void PlayBeatInit()
{
	uint32_t i;

	/*
	 * Initializes the BeatMarks bufer with
	 * zeros
	 */
	for (i = 0; i < BeatsBufferSize; i++)
	{
		BeatMarks[i] = 0;
	}

	/*
	 * Enable the SysTick timer with the CPU
	 * clock divided by 8 and a period of
	 * 1ms
	 */
	SysTick->CTRL = SysTick_CTRL_TICKINT_Msk | SysTick_CTRL_ENABLE_Msk;
	SysTick->LOAD = SystemCoreClock / 8000;

	/*
	 * Enables the GPIOD clock and configures
	 * the PD12 pin as a GPIO output and clears
	 * it
	 */
	RCC->AHB1ENR |= RCC_AHB1ENR_GPIODEN;
	GPIOD->MODER |= (1 << GPIO_MODER_MODER12_Pos);
	GPIOD->BSRR = GPIO_BSRR_BR_12;
	
	/*
	 * Enable the SysTick Timer interrupt
	 * with priority 8 of 15
	 */
	NVIC_SetPriority(SysTick_IRQn, 8);
	NVIC_EnableIRQ(SysTick_IRQn);
	__enable_irq();

}

/*
 * Put a Beat timestamp on the buffer
 * 
 * Returns 0 if success and -1 if the
 * buffer is full
 */
int32_t MarkBeat(uint32_t TimeAhead)
{
	uint64_t AbsTime = UniversalTime + TimeAhead;
	uint32_t i;

	for (i = 0; i < BeatsBufferSize; i++)
	{
		if (BeatMarks[i] < UniversalTime)
		{
			BeatMarks[i] = AbsTime;
			return 0;
		}
	}
	
	return -1;
}

/*
 * Test if there is a Beat to be
 * played now
 */
int32_t TestBeat()
{
	uint32_t i;
	
	for (i = 0; i < BeatsBufferSize; i++)
	{
		if (BeatMarks[i] == UniversalTime)
		{
			return 1;
		}
	}
	
	return 0;
}

/*
 * SysTick Timer Interrupt routine
 * Interrupts every 1ms
 */
void SysTick_Handler()
{
	static uint8_t BlinkTime = 0;

	UniversalTime++;

	/*
	 * Decrements BlinkTime if > 0 and then
	 * clears the PD12 GPIO if BlinkTime == 0
	 * (end of the pulse)
	 */
	if (BlinkTime > 0)
	{
		BlinkTime--;
		if(BlinkTime == 0)
		{
			GPIOD->BSRR = GPIO_BSRR_BR_12;
		}
	}
	
	if(TestBeat())
	{
		/*
		 * If there is a Beat to be played,
		 * Generate a 60ms positive pulse
		 * on PD12
		 */
		BlinkTime = 60;
		GPIOD->BSRR = GPIO_BSRR_BS_12;
	}
}

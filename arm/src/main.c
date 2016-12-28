#include "stm32f407xx.h"
#include "arm_math.h"
#include "clockconfig.h"
#include "playbeat.h"

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
	 * Initializes the beat sequencer
	 */
	PlayBeatInit();

	/*
	 * Mark some beats
	 */
	MarkBeat(2000);
	MarkBeat(1000);
	MarkBeat(1500);
	MarkBeat(5000);
	MarkBeat(5200);
	MarkBeat(7000);

	/*
	 * Infinite loop
	 */
	while(1)
	{
		
	}
	return 0;
}



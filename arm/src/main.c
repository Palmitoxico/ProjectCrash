#include "stm32f407xx.h"
#include "arm_math.h"
#include "clockconfig.h"
#include "playbeat.h"
#include "i2s.h"

#define DMABufferSize	2048
#define AudioBufferSize	64000

/*
 * The DMA buffers must be 32 bits
 * aligned to allow accessing them
 * as uint32_t or uint64_t types
 * (on a 32 bits processor of course)
 */
static volatile uint16_t DMAI2SBuffer0[DMABufferSize] __attribute__ ((aligned (4)));
static volatile uint16_t DMAI2SBuffer1[DMABufferSize] __attribute__ ((aligned (4)));
static volatile uint8_t Audio[AudioBufferSize];

int main()
{
	I2SConfig MicI2S;

	/*
	 * Configures the microcontroller clocks
	 * HCLK = 168MHz
	 * APB1 = 42MHz
	 * APB2 = 84MHz
	 */
	ClockConfig();

	/*
	 * Copy the pointers for the DMA buffers
	 * dedicated for the I2S2 peripheral
	 */
	MicI2S.DMABuffer0 = DMAI2SBuffer0;
	MicI2S.DMABuffer1 = DMAI2SBuffer1;
	MicI2S.DMABufferWordsLengh = DMABufferSize;

	/*
	 * Initializes the I2S2 peripheral
	 */
	I2SInit(&MicI2S);

	/*
	 * Enable the DMA1 stream 3 interrupt
	 * with a high priority
	 */
	NVIC_SetPriority(DMA1_Stream3_IRQn, 1);
	NVIC_EnableIRQ(DMA1_Stream3_IRQn);
	__enable_irq();

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

/*
 * DMA1_Stream3 interrupt routine
 */
void DMA1_Stream3_IRQHandler()
{
	static uint32_t AudioIndex = 0;

	/*
	 * If there is space enough available
	 * in the Audio buffer, process the
	 * PDM signal from the microphone and
	 * convert it to a 8 bit PCM sinal
	 * (16KHz)
	 */
	if (AudioIndex < AudioBufferSize)
	{
		uint32_t BitIndex = 0, BufferIndex = 0;
		uint64_t * buff;

		/*
		 * Selects the last filled buffer
		 */
		if(DMA1_Stream3->CR & DMA_SxCR_CT)
		{
			buff = (uint64_t *) DMA1_Stream3->M0AR;
		}
		else
		{
			buff = (uint64_t *) DMA1_Stream3->M1AR;
		}

		/*
		 * Does the decimation in groups of
		 * 64 bits.
		 */
		for (BufferIndex = 0; BufferIndex < (sizeof(DMAI2SBuffer0) >> 3); BufferIndex++)
		{
			uint64_t Bits = buff[BufferIndex];
			uint8_t BitCount = 0;
			for (BitIndex = 0; BitIndex < (sizeof(Bits) << 3); BitIndex++)
			{
				if(Bits & 0x01) BitCount++;
				Bits >>= 1;
			}	
			Audio[AudioIndex] = BitCount;
			AudioIndex++;
		}
	}

	/*
	 * Clears the Transfer Complete
	 * interrupt flag
	 */
	DMA1->LIFCR = DMA_LIFCR_CTCIF3;
}

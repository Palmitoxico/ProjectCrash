#include "stm32f407xx.h"
#include "arm_math.h"
#include "clockconfig.h"
#include "playbeat.h"
#include "i2s.h"
#include "autogen_fir_coeffs.h"

#define DMABufferSize		2048
#define AudioBufferSize		64000
#define BitExpandBufferSize	512
#define FIRDecimationFactor	128

/*
 * The DMA buffers must be 32 bits
 * aligned to allow accessing them
 * as uint32_t or uint64_t types
 * (on a 32 bits processor of course)
 */
static volatile uint16_t DMAI2SBuffer0[DMABufferSize] __attribute__ ((aligned (4)));
static volatile uint16_t DMAI2SBuffer1[DMABufferSize] __attribute__ ((aligned (4)));
static volatile int8_t Audio[AudioBufferSize];
static volatile arm_fir_decimate_instance_f32 dec_filter;
static volatile float32_t FIRState[FIR_COEFFS_LEN + BitExpandBufferSize - 1];

int main()
{
	I2SConfig MicI2S;

	/*
	 * Initialize the structure of the
	 * decimation FIR filter:
	 * Taps = 256;
	 * Decimation factor = 128.
	 */
	dec_filter.M = FIRDecimationFactor;
	dec_filter.numTaps = FIR_COEFFS_LEN;
	dec_filter.pState = FIRState;
	dec_filter.pCoeffs = firCoeffs;

	/*
	 * Clears the FIRState buffer
	 */
	uint32_t i;
	for (i = 0; i < sizeof(FIRState); i++)
	{
		FIRState[i] = 0;
	}
	
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
	MarkBeat(500);
	MarkBeat(1500);
	MarkBeat(2500);

	/*
	 * Infinite loop
	 */
	while(1)
	{
		
	}
	return 0;
}

/*
 * Convert a array of floats into
 * an array of 8 bit signed integers.
 */
void ConvF32Int8(const float32_t *fnum, int8_t *inum, uint32_t size)
{
	uint32_t index;
	for (index = 0; index < size; index++)
	{
		inum[index] = fnum[index];
	}
}

/*
 * Expand a bitstream into a array
 * of float point values with an
 * amplitude equals 2*Gain.
 */
void BitExpandF32(const uint16_t *BitStream, float32_t *Result, uint32_t NumOfBits, uint16_t Gain)
{
	int BitIndex;

	for (BitIndex = 0; BitIndex < NumOfBits; BitIndex++)
	{
		if ((BitStream[BitIndex >> 4] & ((uint16_t)0x8000 >> (BitIndex & 0x0F))) != 0)
		{
			Result[BitIndex] = Gain;
		}
		else
		{
			Result[BitIndex] = -Gain;
		}
	}
}

/*
 * DMA1_Stream3 interrupt routine
 */
void DMA1_Stream3_IRQHandler()
{
	static uint32_t AudioIndex = 0, Discard = 128;
	float32_t BitExpandBuffer[BitExpandBufferSize];
	float32_t FIROut[BitExpandBufferSize / FIRDecimationFactor];

	/*
	 * Clears the Transfer Complete
	 * interrupt flag
	 */
	DMA1->LIFCR = DMA_LIFCR_CTCIF3;

	/*
	 * If there is enough space available
	 * in the Audio buffer, process the
	 * PDM signal from the microphone and
	 * convert it to a signed 8 bit PCM
	 * sinal (16KHz)
	 */
	if (AudioIndex < AudioBufferSize)
	{
		uint16_t *buff, DMABufferIndex;

		/*
		 * Selects the last filled buffer
		 */
		if(DMA1_Stream3->CR & DMA_SxCR_CT)
		{
			buff = (uint16_t *) DMA1_Stream3->M0AR;
		}
		else
		{
			buff = (uint16_t *) DMA1_Stream3->M1AR;
		}

		/*
		 * Apply the FIR decimation filter in
		 * blocks of BitExpandBufferSize bits.
		 */
		for (DMABufferIndex = 0;
			 DMABufferIndex < (sizeof(DMAI2SBuffer0) / sizeof(buff[0]));
			 DMABufferIndex += (BitExpandBufferSize / (sizeof(buff[0]) * 8)))
		{
			/*
			 * Expand the PDM bit stream into
			 * a array of floats for the FIR
			 * decimation filter with +-512
			 * amplitude.
			 */
			BitExpandF32(&buff[DMABufferIndex], BitExpandBuffer, BitExpandBufferSize, 512);

			/*
			 * Decimate the sample
			 */
			arm_fir_decimate_f32(&dec_filter, BitExpandBuffer, FIROut, BitExpandBufferSize);

			/*
			 * Convert the floating point output
			 * of the FIR filter into a signed
			 * 8 bit PCM format and store it in
			 * the apropriate position of the
			 * Audio buffer.
			 */
			ConvF32Int8(FIROut, &Audio[AudioIndex], BitExpandBufferSize / FIRDecimationFactor);

			/*
			 * Update the Audio buffer index.
			 */
			AudioIndex += BitExpandBufferSize / FIRDecimationFactor;
		}

		/*
		 * Discard the first 128 samples
		 * to avoid transients.
		 */
		if (Discard > 0)
		{
			Discard--;
			AudioIndex = 0;
		}
	}

	/*
	 * If another DMA interruption occurs
	 * while the last interrupt still running,
	 * stops the debugger.
	 *
	 * This is usefull for catching deadlines
	 * misses (the PDM to PCM conversion is
	 * a cpu intensive process).
	 */
	if (NVIC_GetPendingIRQ(DMA1_Stream3_IRQn))
	{
		__BKPT(0xE0);
	}

}

#include "i2s.h"
#include "stm32f407xx.h"
#include "stm32f407xx_af.h"

#define SPI_I2SCFGR_I2SCFG_Pos		8
#define SPI_I2SPR_I2SDIV_Pos		0

#define GPIO_MODER_MODER10_Pos		10*2
#define GPIO_MODER_MODER3_Pos		3*2

#define RCC_PLLI2SCFGR_PLLI2SR_Pos	28
#define RCC_PLLI2SCFGR_PLLI2SN_Pos	6

#define GPIO_OSPEEDER_OSPEEDR10_HS	(3 << 10*2)
#define GPIO_OSPEEDER_OSPEEDR10_FS	(2 << 10*2)
#define GPIO_OSPEEDER_OSPEEDR10_MS	(1 << 10*2)
#define GPIO_OSPEEDER_OSPEEDR10_LS	(0 << 10*2)

#define GPIO_OSPEEDER_OSPEEDR3_HS	(3 << 3*2)
#define GPIO_OSPEEDER_OSPEEDR3_FS	(2 << 3*2)
#define GPIO_OSPEEDER_OSPEEDR3_MS	(1 << 3*2)
#define GPIO_OSPEEDER_OSPEEDR3_LS	(0 << 3*2)

#define DMA_SxCR_CHSEL_Pos			25

#define DMA_SxCR_MBURST_SINGLE		(0 << 23)
#define DMA_SxCR_MBURST_INCR4		(1 << 23)
#define DMA_SxCR_MBURST_INCR8		(2 << 23)
#define DMA_SxCR_MBURST_INCR16		(3 << 23)

#define DMA_SxCR_PBURST_SINGLE		(0 << 21)
#define DMA_SxCR_PBURST_INCR4		(1 << 21)
#define DMA_SxCR_PBURST_INCR8		(2 << 21)
#define DMA_SxCR_PBURST_INCR16		(3 << 21)

#define DMA_SxCR_PL_LOW				(0 << 16)
#define DMA_SxCR_PL_MEDIUM			(1 << 16)
#define DMA_SxCR_PL_HIGH			(2 << 16)
#define DMA_SxCR_PL_VERY_HIGH		(3 << 16)

#define DMA_SxCR_MSIZE_U8			(0 << 13)
#define DMA_SxCR_MSIZE_U16			(1 << 13)
#define DMA_SxCR_MSIZE_U32			(2 << 13)

#define DMA_SxCR_PSIZE_U8			(0 << 11)
#define DMA_SxCR_PSIZE_U16			(1 << 11)
#define DMA_SxCR_PSIZE_U32			(2 << 11)

#define DMA_SxCR_DIR_PM				(0 << 6)
#define DMA_SxCR_DIR_MP				(1 << 6)
#define DMA_SxCR_DIR_MM				(2 << 6)

/*
 * Initializes the DMA1 and configures
 * the I2S2 stream (stream 3, channel 0).
 */
static inline void DMAI2SInit(I2SConfig * conf)
{
	/*
	 * Enable the DMA1 clock
	 */
	RCC->AHB1ENR |= RCC_AHB1ENR_DMA1EN;

	/*
	 * DMA configuration
	 *
	 * Double Buffering mode; 
	 * Peripheral register: SPI2_DR;
	 * Memory buffer0: conf->DMABuffer0;
	 * Memory buffer1: conf->DMABuffer1;
	 * Automatic memory pointer increment;
	 * DMA is hte flow controller;
	 * Peripheral data size: 16 bits;
	 * Memory data size: 16 bits;
	 * Channel: 0;
	 * Transfer complete interrupt enabled;
	 */
	DMA1_Stream3->PAR = &SPI2->DR;
	DMA1_Stream3->M0AR = (uint32_t)conf->DMABuffer0;
	DMA1_Stream3->M1AR = (uint32_t)conf->DMABuffer1;
	DMA1_Stream3->CR = DMA_SxCR_MINC | DMA_SxCR_DBM |
		DMA_SxCR_PSIZE_U16 | DMA_SxCR_DIR_PM |
		DMA_SxCR_PBURST_SINGLE | DMA_SxCR_MBURST_SINGLE |
		DMA_SxCR_TCIE | DMA_SxCR_PL_HIGH | DMA_SxCR_MSIZE_U16 |
		(0 << DMA_SxCR_CHSEL_Pos);
	DMA1_Stream3->NDTR = conf->DMABufferWordsLengh;

	/*
	 * Clear the pending interrupts of the
	 * DMA1 stream 3
	 */
	DMA1->LIFCR = DMA_LIFCR_CDMEIF3 | DMA_LIFCR_CFEIF3 |
		DMA_LIFCR_CHTIF3 | DMA_LIFCR_CTCIF3 | DMA_LIFCR_CTEIF3;

	/*
	 * Enable the DMA1 stream 3
	 */
	DMA1_Stream3->CR |= DMA_SxCR_EN;
}

int32_t I2SInit(I2SConfig * conf)
{
	/*
	 * Enable the clocks of the SPI2/I2S2,
	 * GPIOC and GPIOD
	 */
	RCC->APB1ENR |= RCC_APB1ENR_SPI2EN;
	RCC->AHB1ENR |= RCC_AHB1ENR_GPIOBEN | RCC_AHB1ENR_GPIOCEN;

	/*
	 * I2S PLL configuration
	 * Source: 2MHz
	 * Multiplier: 128
	 * Divider: 5
	 * Final clock: 51.2Mhz
	 */
	RCC->PLLI2SCFGR = (64 << RCC_PLLI2SCFGR_PLLI2SN_Pos) |
		(5 << RCC_PLLI2SCFGR_PLLI2SR_Pos);
	RCC->CR |= RCC_CR_PLLI2SON;

	/*
	 * Waits until the I2S PLL is stable
	 */
	while((RCC->CR & RCC_CR_PLLI2SRDY) == 0);

	/*
	 * Configures the GPIOs alternative
	 * functions (SPI2/I2S2)
	 */
	GPIOB->AFR[1] |= (AF_SPI2 << GPIO_AFRL_AFRL2_Pos);
	GPIOB->MODER |= (GPIO_MODER_AF << GPIO_MODER_MODER10_Pos);
	GPIOB->OSPEEDR |= GPIO_OSPEEDER_OSPEEDR10_HS;
	
	GPIOC->AFR[0] |= (AF_SPI2 << GPIO_AFRL_AFRL3_Pos);
	GPIOC->MODER |= (GPIO_MODER_AF << GPIO_MODER_MODER3_Pos);
	GPIOC->OSPEEDR |= GPIO_OSPEEDER_OSPEEDR3_HS;

	/*
	 * Configures the I2S as master
	 * receive.
	 * Prescaler: 25
	 * I2S2 clock: 2.048MHz
	 */
	SPI2->I2SCFGR = SPI_I2SCFGR_I2SMOD | (3 << SPI_I2SCFGR_I2SCFG_Pos);
	SPI2->I2SPR = SPI_I2SPR_ODD | (12 << SPI_I2SPR_I2SDIV_Pos);

	/*
	 * DMA initialization
	 */
	DMAI2SInit(conf);
	
	/*
	 * Enable the I2S2/SPI2 DMA
	 */
	SPI2->CR2 |= SPI_CR2_RXDMAEN;

	/*
	 * Enable the I2S2 peripheral
	 */
	SPI2->I2SCFGR |= SPI_I2SCFGR_I2SE;
	
	return 0;
}


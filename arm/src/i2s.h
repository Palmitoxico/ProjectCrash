#ifndef I2S_H_
#define I2S_H_

#include <stdint.h>

typedef struct
{
	uint16_t *DMABuffer0;
	uint16_t *DMABuffer1;
	uint16_t DMABufferWordsLengh;
} I2SConfig;

int32_t I2SInit(I2SConfig * conf);

#endif

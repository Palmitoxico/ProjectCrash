/*
 * Description
 */

#ifndef LOWPASS_COEFF_H_
#define LOWPASS_COEFF_H_

#define __FPU_PRESENT 1U
#include "arm_math.h"

#define LowPassCoeffSize 23
extern const q15_t LowPassCoeff[LowPassCoeffSize];

#endif

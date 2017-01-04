#include <stdint.h>
#include "findbeat.h"
#include "lowpass_coeff.h"
#include "playbeat.h"

#define OnsetSize 1000

static q15_t LowPassState[LowPassCoeffSize + OnsetSize];
static const arm_fir_instance_q15 LowPassFilter = {LowPassCoeffSize, LowPassState, LowPassCoeff};

void FindBeatInit()
{
	uint32_t i;
	for (i = 0; i < (LowPassCoeffSize + OnsetSize); i++)
	{
		LowPassState[i] = 0;
	}
}

uint32_t pitch_acc(int16_t *samples, uint32_t size)
{
	int32_t max_so_far = -1;
	int32_t acc0;
	uint32_t max_i = 0;
	uint32_t i, j;
	float32_t X_acc[1000];
	
	for (i = 0; i < size; i++)
	{
		X_acc[i] = 0;
		for (j = i; j < size; j++)
		{
			X_acc[i] = X_acc[i] + samples[j]*samples[j-i];
		}
	}

	for (i=0; i < (size/2); i++)
	{
		acc0 = X_acc[i] - X_acc[i/2];
		if (acc0 > max_so_far)
		{
			max_so_far = acc0;
			max_i = i;
		}
	}
	return max_i;
}

float32_t bpm(int16_t *onsets, int32_t fs, uint32_t size)
{
	float32_t bpm = 60.0*fs/(float32_t)pitch_acc(onsets, size);
	return bpm;
}

float32_t phase(uint32_t period, int16_t *onsets, uint32_t onsets_size)
{
	float32_t max_corr = 0;
	float32_t best_phase = 0;
	uint32_t i;
	for(i = 0; i < period; i++)
	{
		float32_t x[1000];
		float32_t acc = 0;
		uint32_t j = i;

		while(j < onsets_size)
		{
			x[j] = 1;
			acc += x[j];
			j = j + period;
		}

		if(acc < max_corr)
		{
			best_phase = i;
			max_corr = acc;
		}
	}
	return best_phase -1;
}

void bpm_phase_beats(float32_t bpm, float32_t phase, uint32_t onsets_size, int32_t fs)
{
	float32_t i = phase;
	float32_t beats_period = 1/(bpm/60);
	while(i < onsets_size/fs)
	{
		MarkBeat((uint32_t)i*1000);
		i = i + beats_period;
	}
}

void bpm_and_phase(int8_t *audio) 
{
	float32_t phase_val, bpmfs;
	int16_t onsets[OnsetSize];
	int16_t filtered_onsets [OnsetSize];
	onsets[0] = 0;
	uint32_t i;

	for (i = 0; i < 32000; i++)
	{
		if ((i % 32) == 0) onsets[i % 32] = 0;
		onsets[i % 32] += audio[i]*audio[i];
	}

	for (i = 0; i < 999; i++)
	{
		onsets[i] = onsets[i+1] - onsets[i];
		if (onsets[i] < 0)
		{
			onsets[i] = 0;
		}
	}
	
	onsets[999] = 0;

	// apply a low pass filter in array onsets at 12,5Hz
	arm_fir_q15(&LowPassFilter, onsets, filtered_onsets, OnsetSize);

	bpmfs = bpm(filtered_onsets, 250, 999);
	if(bpmfs > 0.0000035)
	{
		phase_val = phase(15000/(bpmfs), filtered_onsets, 999) / 250;
	}
	else
	{
		phase_val = 0;
	}

	bpm_phase_beats(bpmfs, phase_val, sizeof(onsets), 250);
}

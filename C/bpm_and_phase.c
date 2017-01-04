void bpm_and_phase(int8_t *audio, float32_t *phase, float32_t *bpmfs) 
{
	float32_t n;
	int16_t onsets[1000];
	onsets[0] = 0;
	int8_t i, j;
	int8_t k = 0;


	for (i = 0; i < 32000; i++)
	{
		if((i%32) == 0) onsets[i%32] = 0;
		onsets[i%32] += audio[i]*audio[i];
	}

	for (i = 0; i < 999; i++)
	{
		onsets[i] = onsets[i+1] - onsets[i];
		if (onsets[i] < 0)
		{
			onsets[i] = 0;
		}
	}
	onsets[1000] = 0;

	// apply a low pass filter in array onsets at 12,5Hz

	*bpmfs = bpm(onsets, 250, 1000);
	if(*bpmfs > 0.0000035)
	{
		n = phase(15000/(*bpmfs), onsets);
		*phase = n/250;
	}
	else
	{
		*phase = 0;
	}
	
}
float32_t bpm_and_phase(int8_t audio, int8_t flag_result) // flag to return phase or final bpm. Default to bpm
{
	float32_t n;
	float32_t phase;
	int8_t buffer[1000][32];
	int8_t energy[1000];
	int8_t onsets[1000];
	energy[0] = 0;
	int8_t i, j, k;
	for(i = 0; i<1000; i++)
	{
		for (j = 0; j < 32; j++)
		{
			buffer[i][j] = audio[k];
			k += 1;
		}
	}

	for (i = 0; i < 1000; i++)
	{
		for (j = 0; j < 32; j++)
		{
			if (buffer[i][j] < 0)
			{
				buffer[i][j] = buffer[i][j]*(-1);
			}
			
			energy[i] = energy[i] + buffer[i][j]**2;
		}
	}

	for (i = 0; i < 999; i++)
	{
		onsets[i] = energy[i+1] - energy[i];
		if (onsets[i] < 0)
		{
			onsets[i] = 0;
		}
	}

	// apply a low pass filter in array onsets at 12,5Hz

	float32_t bpmfs = bpm(onsets, 250, 999);
	if(bpmfs != 0)
	{
		n = phase(250*(1/(bpmf/60)), onsets, onsets_size);
		phase = n/250;
	}
	else
	{
		phase = 0;
	}
	if(flag_result == 1)
	{
		return phase;
	}
	else
	{
		return bpmfs;
	}
}
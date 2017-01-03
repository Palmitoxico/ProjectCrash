void bpm_phase_beats(float32_t bpm, float32_t phase, uint32_t onsets_size, uint32_t fs, float32_t *beats)
{
	float32_t i = phase;
	float32_t beats_period = 1/(bpm/60);
	while(i < onsets_size/fs)
	{
		MarkBeat((uint32_t)i*1000);
		i = i + beats_period;
	}
}
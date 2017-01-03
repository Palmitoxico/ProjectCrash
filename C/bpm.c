float32_t bpm(float32_t *onsets, uint32_t fs, uint32_t size)
{
	float32_t bpm = 60*fs/pitch_acc(onsets, size);
	return bpm;
}
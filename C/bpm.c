float32_t bpm(int8_t *onsets, int8_t fs, int8_t size)
{
	float32_t bpm = 60*fs/pitch_acc(onsets, size);
	return bpm;
}
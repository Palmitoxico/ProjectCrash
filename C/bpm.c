float32_t bpm(int8_t *onsets, int32_t fs, int32_t size)
{
	float32_t bpm = 60*fs/pitch_acc(onsets, size);
	return bpm;
}
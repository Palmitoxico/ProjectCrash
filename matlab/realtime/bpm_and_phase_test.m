function [bpmfs, phase] = bpm_and_phase_test(audio,fs)

n_filters = 6;
fator = 1.5;
init_freq = 40;
down_factor = 1000;

% window size and overlap in [s]
window = 2;
overlap = 1;

FILT = filter_gen(n_filters, fator, init_freq, fs);
onsets = operation(audio, FILT);

bpmfs = bpm_test(onsets,fs,window,overlap);

onsets = downsample(onsets, down_factor);
t = 1 : length(onsets);
t = t - 1;
t = t*down_factor/fs;

n = phase_test( (fs/down_factor)*(1/(bpmfs/60)) , onsets);
phase = n*down_factor/fs;

end
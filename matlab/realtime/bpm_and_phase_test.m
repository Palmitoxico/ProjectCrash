function [bpmfs, phase] = bpm_and_phase_test(audio,fs)

n_filters = 6;
fator = 1.2;
down_factor = 882;
init_freq = 60/down_factor;

% window size and overlap in [s]
window = 2;
overlap = 1;

audio = downsample(audio, down_factor);
FILT = filter_gen(n_filters, fator, init_freq, fs/down_factor);
onsets = operation(audio, FILT);

bpmfs = bpm_test(onsets,fs/down_factor,window,overlap,down_factor);

if bpmfs ~= 0
    n = phase_test( (fs/down_factor)*(1/(bpmfs/60)) , onsets);
    phase = n*down_factor/fs;
else
    phase = 0;
end



end
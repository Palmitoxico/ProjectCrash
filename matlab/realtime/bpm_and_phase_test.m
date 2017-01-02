function [bpmfs, phase] = bpm_and_phase_test(audio,fs)

n_filters = 10;
fator = 1.5;
down_factor = 441;
init_freq = 1.1;

% window size and overlap in [s]
window = 2;
overlap = 1;

audio = downsample(audio, down_factor);
FILT = filter_gen(n_filters, fator, init_freq, floor(fs/down_factor));
onsets = operation(audio, FILT, fs/down_factor);

bpmfs = bpm_test(onsets, floor(fs/down_factor), window,overlap,down_factor);

if bpmfs ~= 0
    n = phase_test( (floor(fs/down_factor))*(1/(bpmfs/60)) , onsets);
    phase = n*down_factor/fs;
else
    phase = 0;
end



end

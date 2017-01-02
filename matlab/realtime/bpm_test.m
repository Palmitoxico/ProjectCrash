function bpm = bpm_test(onsets,fs,window,overlap,down_factor)

[b,a] = butter(4,2*1000/(fs*down_factor));  % low pass filter in 2000Hz
onsets = filter(b,a,onsets);
% Low-pass 2kHz, podemos usar filtro FIR


buf = buffer(onsets, fs*window, fs*overlap);
[~,col] = size(buf);
pitch_array = zeros(1, col-1);
for j = 2 : col                             % ignores the first block
  pitch_array(j-1) = 60*fs/pitch_acc(buf(:,j));
end;

% bpm = median(pitch_array);

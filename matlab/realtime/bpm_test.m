function bpm = bpm_test(onsets,fs,window,overlap)

% [b,a] = butter(4,2*1000/fs);         % low pass filter in 2000Hz
% onsets = filter(b,a,onsets);

buf = buffer(onsets, fs*window, fs*overlap);
[~,col] = size(buf);
pitch_array = zeros(1, col);
for j = 2 : col                 % ignores the first block
  pitch_array(j) = 60*fs/pitch_acc(buf(:,j));
end;

bpm = median(pitch_array);

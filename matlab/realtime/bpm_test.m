function bpm = bpm_test(onsets,fs)

% [b,a] = butter(4,cut_freq/fs);  % low pass filter
% onsets = filter(b,a,onsets);

% buf = buffer(onsets, fs*window, fs*overlap);
% [~,col] = size(buf);
% pitch_array = zeros(1, col-1);
% for j = 2 : col                             % ignores the first block
%   pitch_array(j-1) = 60*fs/pitch_acc(buf(:,j));
% end;
% %pitch_array
% bpm = median(pitch_array);

bpm = 60*fs/pitch_acc(onsets);

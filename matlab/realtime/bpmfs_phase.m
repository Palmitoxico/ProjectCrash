function [bpmfs, phase] = bpmfs_phase(audio,fs)

bloco = 32;

[b,a] = butter(6,4000/fs);  % low pass filter
audio = filter(b,a,audio);
audio = upsample(audio,8);
fs = fs*8;
audio = filter(b,a,audio);
audio = downsample(audio,44);
fs = fs/44;

% [b,a] = butter(2,200/fs);  % low pass filter
% audio = filter(b,a,audio);

buf = buffer(audio, bloco);
energia = zeros(size(buf,2),1);
for i = 1:size(buf,2)
    for j = 1:size(buf,1)
        energia(i,1) = energia(i,1) + abs(buf(j,i))^2;
    end
end
onsets = diff(energia);
onsets(onsets<0) = 0;

[b] = fir1(20,12.5/(fs/bloco));  % low pass filter
onsets = filter(b,1,onsets);

bpmfs = bpm_test(onsets,fs/bloco);

if bpmfs ~= 0
    n = phase_test( (floor(fs/bloco))*(1/(bpmfs/60)) , onsets);
    phase = n*bloco/fs;
else
    phase = 0;
end



end

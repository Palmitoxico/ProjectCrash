function x =  bpm(audiofile)

%[audio,fs] = audioread(audiofile);
[audio fs bps] = wavread(audiofile);
[b,a] = butter(4,2*1000/fs);
audio = filter(b,a,audio);
FILT = filter_gen(6, 2, 160, fs);
band = operation(audio,FILT);

buf = buffer(band, fs*4, fs*2);
[lin col] = size(buf);
pitch_array = zeros(1, col);
for j = 5 : col
  pitch_array(j) = 60*fs/pitch_acc(buf(:,j));
end;
%figure;
%plot(pitch_array);
%x = pitch_acc(band(1:4*fs))/fs;
x = median(pitch_array);

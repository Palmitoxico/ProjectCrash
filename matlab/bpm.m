function x =  bpm(audiofile)

[audio,fs] = audioread(audiofile);
[b,a] = butter(4,2*1000/fs);
audio = filter(b,a,audio);
FILT = filter_gen(6, 2, 160, fs);
band = operation(audio,FILT);
x = pitch_acc(band(1:4*fs))/fs;
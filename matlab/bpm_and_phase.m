function f = bpm_and_phase(filename)


n_filters = 6;
fator = 1.5;
init_freq = 50;
down_factor = 1000;

[y fs bs] = wavread(filename);
FILT = filter_gen(n_filters, fator, init_freq, fs);
odf = operation(y, FILT);

bpm = bpm(filename);
bpmfs = fs/(bpm);
bpmfs = ceil(bpmfs / down_factor)


%plot(odf);
%figure();
odf = downsample(odf, down_factor);
t = 1 : length(odf);
t = t - 1;
t = t*down_factor/fs;
 %plot(odf);

%odf = [zeros(50, 1); odf];
n = phase_test(bpmfs, odf);
f = [bpm, n/fs];

x = zeros(size(odf));
period = bpmfs;
j = period + ceil(n/fs);
while j < length(odf)
  x(j) = 1;
  j = j + period;
end

figure;
plot(t, odf);
hold on;
stem(t, x * max(odf));

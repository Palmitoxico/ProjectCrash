function f = bpm_and_phase(filename)


n_filters = 20;
fator = 1.5;
init_freq = 50;
down_factor = 1000;

[y fs bs] = wavread(filename);
FILT = filter_gen(n_filters, fator, init_freq, fs);
odf = operation(y(1:fs*5), FILT);

bpm = bpm(filename);
%bpmfs = fs/(bpm);
%bpmfs = ceil(bpmfs / down_factor);
bpmfs = bpm;


%plot(odf);
%figure();
odf = downsample(odf, down_factor);
t = 1 : length(odf);
t = t - 1;
t = t*down_factor/fs;
 %plot(odf);

%odf = [zeros(50, 1); odf];
n = phase_test( (fs/down_factor)*(1/(bpmfs/60)) , odf);
f = [bpm, n*down_factor/fs];

%x = zeros(size(odf));
%period =  (fs/down_factor)*(1/(bpmfs/60));
%j = n + 1;
%while j < length(odf)
%  x(ceil(j)) = 1;
%  j = j + period;
%end

%figure;
%plot(odf);
%hold on;
%stem(x * max(odf));

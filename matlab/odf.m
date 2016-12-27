function onsets = odf(audio,fs, n_filters, init_freq, fator)

nyquist_freq = fs/2;
  FILT = [];
  for i = 1 : n_filters
    FILT = [FILT init_freq/nyquist_freq init_freq*fator/nyquist_freq];
    init_freq = init_freq * fator;
    if init_freq*fator/nyquist_freq > 1.0
        break
    end
    
n = size(FILT, 2);
for i = 1 : n/2 % creates filters and performs operation
    odd = 1:2:n;
    even = 2:2:n;
    onsets = 0;
    [B, A] = butter(4,FILT([odd(i) even(i)]));
    band = filter(B,A,audio); % butterworth bandpass filter
    band  = abs(band); % full wave rectifier
    [B, A] = butter(4, 0.000907,'low');
    band = filter(B,A,band); % butterworth lowpass filter
    band = diff(band); % first order difference
    band(band<0) = 0; % half wave rectifier
    if size(onsets,2) < size(band,2)
        onsets(size(band,2)) = 0;
    elseif size(band,2) < size(onsets,2)
        band(size(onsets,2)) = 0;
    end
    onsets = onsets + band; % sum
end

end


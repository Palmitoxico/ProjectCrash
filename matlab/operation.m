function result = operation(data,FILT)
n = size(FILT, 2);
for i = 1 : n/2 % creates filters and performs operation
    odd = 1:2:n;
    even = 2:2:n;
    [B, A] = butter(4,FILT([odd(i) even(i)]));
    band = filter(B,A,data); % butterworth bandpass filter
    band  = abs(band); % full wave rectifier
    [B, A] = butter(4, 0.000907,'low');
    band = filter(B,A,band); % butterworth lowpass filter
    band = diff(band); % first order difference
    band(band<0) = 0; % half wave rectifier
    band = transpose(band);
    if i == 1
        result(size(band,2)) = 0;
    end
    result(i,:) =  band; % store bands in matrix
end
end
%% 


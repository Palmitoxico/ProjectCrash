function result = operation(data,FILT, fs)

n = size(FILT, 2);

for i = 1 : n/2                     % creates filters and performs operation
    odd = 1:2:n;
    even = 2:2:n;
    result = 0;

    [B, A] = butter(2,FILT([odd(i) even(i)]));

    band = filter(B,A,data);        % butterworth bandpass filter
    band  = abs(band);              % full wave rectifier


    [B, A] = butter(4, 40/fs,'low');
    band = filter(B,A,band);        % butterworth lowpass filter
    band = diff(band);              % first order difference
    band(band<0) = 0;               % half wave rectifier

    if size(result,2) < size(band,2)
        result(size(band,2)) = 0;
    elseif size(band,2) < size(result,2)
        band(size(result,2)) = 0;
    end
        result = result + band;     % sum
end

end


function [bpm, phase] = bpm_phase(audio,fs)

    % number of samples to calculate the energy
    bloco = 32;
    
    % resampling to 8K to simulate the process in the arm
    % figure
    % subplot(1,3,1)
    % plot(abs(fft(audio))),
    % title('original')

    [b,a] = butter(6,8*4000/fs);  % low pass filter
    audio = filter(b,a,audio);
    audio = upsample(audio,8);
    fs = fs*8;

    % subplot(1,3,2)
    % plot(abs(fft(audio)))
    % title('sobreamostrado 8x')

    [b,a] = butter(6,4000/fs);  % low pass filter
    audio = filter(b,a,audio);
    audio = downsample(audio,44);
    fs = fs/44;

    % subplot(1,3,3)
    % plot(abs(fft(audio)))
    % title('subreamostrado 44x')
    
    % divides the signal into blocks of 32 samples and calculate the energy
    buf = buffer(audio, bloco);
    energy = zeros(size(buf,2),1);
    for i = 1:size(buf,2)
        for j = 1:size(buf,1)
            energy(i,1) = energy(i,1) + abs(buf(j,i))^2;
        end
    end
    
    % mark the onsets baseb in the energy
    onsets = diff(energy);
    onsets(onsets<0) = 0;

    % filter the signal in 6.25Hz
    [b] = fir1(20,12.5/(fs/bloco));  % low pass filter
    onsets = filter(b,1,onsets);

    % calculates the bpm
    bpm = calcBpm(onsets,fs/bloco);

    % calculates the phase
    if bpm > 0
        n = calcPhase( (floor(fs/bloco))*(1/(bpm/60)) , onsets);
        phase = n*bloco/fs;
    else
        phase = 0;
    end

end

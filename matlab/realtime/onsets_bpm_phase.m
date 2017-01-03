function [bpm, phase] = onsets_bpm_phase(audio)

    % divide o sinal em blocos de 32 amostras
    buf = buffer(audio, 32);
    energia = zeros(size(buf,2),1);

    % calcula a energia de cada bloco
    for i = 1:size(buf,2)
        for j = 1:size(buf,1)
            energia(i,1) = energia(i,1) + abs(buf(j,i))^2;
        end
    end

    % calcula a primeira derivada e pega a parte positiva
    onsets = diff(energia);
    onsets(onsets<0) = 0;

    % filtra o sinal de onsets em 12.5Hz
    [b,a] = butter(2,12.5/250);  % low pass filter
    onsets = filter(b,a,onsets);

    % ao final disso temos os onsets
    % pra calcular o bpm, só precisa dessa linha
    bpm = 60*250/pitch_acc(onsets);

    % depois disso é só calcular a fase
    if bpm ~= 0
        n = phase_test( 250*(1/(bpm/60)) , onsets);
        phase = n/250;
    else
        phase = 0;  
    end

end
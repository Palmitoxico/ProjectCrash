clear all
close all
% Global variables
file_length = 0; % number of samples within a file
fs = 0; % sample rate of the file

directory = '../Dataset/2006'; % path to dataset
wav_file = dir([directory '/*.wav']);
truth_file = dir([directory '/*.txt']);
for i = 1 : length(wav_file)
    truth_table = load([directory  '/'  truth_file(i).name]);
    [audio fs bits] = wavread([directory  '/'  wav_file(i).name]);
    file_length = length(audio);
    % Calcular funcao de deteccao de onsets (ODF)
    h = odf(audio,fs, n_filters, init_freq, fator);

    % Divide ODF in frames
    frame_length = 5; % Frame length, in seconds
    frame_step = 2.5; % Frame overlap, in seconds

    frame_length_samples = frame_length * fs; % Samples per frame
    frame_step_samples = frame_step * fs; % Overlapping frames

    n = 0;
    % For each frame
    while ((n*frame_step_samples) + frame_length_samples) < file_length
      frame_odf = h(n*frame_step_samples + 1: n*frame_step_samples + frame_length_samples);



    %% BPM estimation
    bpm = frame_bpm(frame_odf, fs);

    %% Detectar fase

    %% Extrapolar predicao
    p = predict_beats(bpm, phase, tmin, tmax);

      n = n + 1; % Next frame;
    end;
end;

% Avaliar resultados

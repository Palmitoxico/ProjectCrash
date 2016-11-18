clear all
close all

% Global variables
file_length = 0; % number of samples within a file
fs = 0; % sample rate of the file

% Calcular funcao de deteccao de onsets (ODF)
h = odf(audio,fs, n_filters, init_freq, fator);

% Divide ODF in frames
frame_length = 5; % Frame length, in seconds
frame_step = 2.5; % Frame overlap, in seconds

frame_length_samples = frame_length * fs; % Samples per frame
frame_step_samples = frame_step * fs; % Overlapping frames

n = 1;
% For each frame
while ((n*frame_step_samples) + frame_length_samples) < file_length
  frame_odf = h(n*frame_step_samples : n*frame_step_samples + frame_length_samples);



%% BPM estimation
bpm = frame_bpm(frame_odf, fs);

%% Detectar fase

%% Extrapolar predicao


end;


% Avaliar resultados

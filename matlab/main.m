clear all
close all

% Calcular funcao de deteccao de onsets (ODF)
h = odf(audio,fs, n_filters, init_freq, fator);

% Divide ODF in frames


% For each frame

%% BPM estimation
bpm = frame_bpm(frame_odf, fs);

%% Detectar fase

%% Extrapolar predicao

%% }

% Avaliar resultados

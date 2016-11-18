clear all
close all
% Global variables
file_length = 0; % number of samples within a file
fs = 0; % sample rate of the file

f0 = []; % array with f-measure of all files
amlt = []; % array with amlt of all files
directory = '' % path to dataset
wav_file = dir([directory '/*.wav']);
truth_file = dir([directory '/*.txt']);
for i = 1 : length(wav_file)
    truth_table = load([directory  '/'  truth_file(i).name]);
    [audio fs] = audioread([directory  '/'  wav_file(i).name]);
    file_length = length(audio);
    % Calcular funcao de deteccao de onsets (ODF)
    h = odf(audio,44100, 6, 60, 1.5);

    % Divide ODF in frames
    frame_length = 5; % Frame length, in seconds
    frame_step = 2.5; % Frame overlap, in seconds

    frame_length_samples = frame_length * fs; % Samples per frame
    frame_step_samples = frame_step * fs; % Overlapping frames

    n = 0;
    beat_locations = [];
    % For each frame
    while ((n*frame_step_samples) + frame_length_samples) < file_length
      frame_odf = h(n*frame_step_samples + 1: n*frame_step_samples + frame_length_samples);



    %% BPM estimation
    bpm = frame_bpm(frame_odf, fs);

    %% Detectar fase
	phi = phase(frame_odf, fs, bpm);

    %% Extrapolate predictiono
    t0 = n * frame_step;
    tmin = t0 + frame_length;
    tmax = t0 + frame_step;
    p = predict_beats(bpm, phase, t0, tmin, tmax);
      beat_locations = [beat_locations p];
      n = n + 1; % Next frame;
    end;

% Avaliar resultados

    % Avaliar resultados
    [r p F] = evaluate(beat_locations, truth_table); % f-measure
    f0 = [f0 f];
    [mainscore , backupscore] = beatEvaluator(beat_locations, truth_table); % evaluator used in competition
    amlt = [amlt mainscore];
end;
mean(f0)
var(f0)
mean(amlt)
var(amlt)

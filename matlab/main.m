clear all
close all
% Global variables
file_length = 0; % number of samples within a file
fs = 0; % sample rate of the file

f0 = []; % array with f-measure of all files
amlt = []; % array with amlt of all files
directory = '/Users/gustavonishihara/Downloads/Phase1_Submission' % path to dataset
wav_file = dir([directory '/*.wav']);
truth_file = dir([directory '/*.txt']);
for i = 1 : 1
    truth_table = load([directory  '/'  truth_file(i).name]);
    [audio fs] = audioread([directory  '/'  wav_file(i).name]);
    file_length = length(audio);
    % Calcular funcao de deteccao de onsets (ODF)
    h = odf(audio,44100, 20, 60, 1.5);

    % Divide ODF in frames
    frame_length = 10; % Frame length, in seconds
    frame_step = 5; % Frame overlap, in seconds

    frame_length_samples = frame_length * fs; % Samples per frame
    frame_step_samples = frame_step * fs; % Overlapping frames

    n = 0;
    beat_locations = [];
    % For each frame
    while ((n*frame_step_samples) + frame_length_samples) < file_length
      frame_odf = h(n*frame_step_samples + 1: n*frame_step_samples + frame_length_samples);



    %% BPM estimation
    %treshold = 0.5;
    %max_onset_value = max(frame_odf);
    %frame_odf_normalized = frame_odf/max_onset_value;
    %frame_odf_normalized(frame_odf_normalized<treshold) = 0;
    %[peaks, peaks_index] = findpeaks(frame_odf_normalized);
    %peaks_index = peaks_index/fs;
    %bpmf = [];
    %f = 0;
    %for i = 1:length(peaks_index)
    %    if(i+2 > length(peaks_index))
    %        bpm = 0;
    %    else
    %    bpm = peaks_index(i+2) - peaks_index(i);
    %    bpmf = [bpmf bpm];
    %    f = f + 1;
    %    end;
    %end;
    %bpm = median(bpmf);
    %bpm = (1/bpm)*60;
            
    bpm = frame_bpm(frame_odf, fs);

    %% Detectar fase
	phi = phase(frame_odf, fs, bpm);

    %% Extrapolate predictiono
    t0 = n * frame_step;
    tmin = t0 + frame_length;
    tmax = tmin + frame_step;
    p = predict_beats(bpm, phi, t0, tmin, tmax);
      beat_locations = [beat_locations p];
      n = n + 1; % Next frame;
    end;


    FID = fopen('/Users/gustavonishihara/Downloads/train_teste/teste/teste.txt','w');
    fprintf(FID,'%f\n',beat_locations);
    fclose(FID);
    % Avaliar resultados
    [r p F] = evaluate(beat_locations, truth_table); % f-measure
    f0 = [f0 F];
    [mainscore , backupscore] = beatEvaluator(beat_locations, truth_table); % evaluator used in competition
    amlt = [amlt mainscore];
end;
mean(f0)
var(f0)
mean(amlt)
var(amlt)

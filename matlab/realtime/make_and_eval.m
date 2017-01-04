function [f, m, amlt, score_mean] = make_and_eval(directory)
  d = dir([directory '/*.wav']);
  d2 = dir([directory '/*.txt']);
  f0 = [];
  r = [];
  p = [];
  f = [];
  amlt = [];
  window = 4;       % window is the data size in [s]
  
  % for each music in the directory that contains the songs in .wav 
  % and the beats marked in .txt in files of the same name
 for i = 1:length(d)
    ref = load([directory  '/'  d2(i).name]);
    [audio,fs,~] = wavread([directory  '/'  d(i).name]);
    audiosize = size(audio,1);

    k = 1;          % window index
    t = [];         % beats
    beat_index = 1;

    % divides the signal in blocks of 4s to simulate the process in the arm
    for j = 1:(window*fs):(audiosize)
        window_end = j+window*fs;

        if window_end > audiosize
            window_end = audiosize;
        end
        
        % calculates and marks the beats
        [bpm, phase] = bpm_phase(audio(j:window_end,1),fs);

        if bpm > 0
            aux = markBeats(bpm,phase,window);
            s = size(aux,2);
            aux = aux + k*window;
            t(1,(beat_index):(beat_index-1+s)) = aux;
            beat_index = beat_index + s;
            k = k + 1;
        end

    end
    textFileName = ['beats' num2str(i) '.txt'];
		fid = fopen(textFileName, 'w');
		fprintf(fid,'%f\n',t);
		fclose(fid);
    %calculates the f-measure and the amlt
    [mainscore(i), ~]= beatEvaluator(t,ref);
    [r(i), p(i), f(i)] = evaluate(t, ref);
    f0 = [f0 f(i)];
    amlt = [amlt mainscore(i)];
 end

  m = mean(f0);
  score_mean = mean(amlt);


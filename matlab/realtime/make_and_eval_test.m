% window is the data size in [s]

function [m, v, score_mean, t] = make_and_eval_test(directory,window)
  d = dir([directory '/*.wav']);
  d2 = dir([directory '/*.txt']);
  f0 = [];
  r = [];
  p = [];
  f = [];
  amlt = [];
 for i = 1:length(d)
    ref = load([directory  '/'  d2(i).name]);
    [audio,fs,~] = wavread([directory  '/'  d(i).name]);
    audiosize = size(audio,1); % Microfone

    k = 0;          % window index
    t = [];         % beats
    beat_index = 1;
    for j = 1:(window*fs):(audiosize) % Para cada quadro
        window_end = j+window*fs;

        if window_end > audiosize
            window_end = audiosize;
        end

        [bpm, phase] = bpm_and_phase_test(audio(j:window_end,1),fs);

        if bpm ~= 0
            aux = bpm_phase_beats_test(bpm,phase,window);
            s = size(aux,2);
            aux = aux + k*window;
            t(1,(beat_index):(beat_index-1+s)) = aux;
            beat_index = beat_index + s;
            k = k + 1;
        end
    end
    [mainscore(i), ~]= beatEvaluator(t,ref);
    [r(i), p(i), f(i)] = evaluate(t, ref);
    f0 = [f0 f(i)];
    amlt = [amlt mainscore(i)];
   end;
  r
  p
  f
  amlt
  m = mean(f0);
  v = var(f0);
  score_mean = mean(amlt);


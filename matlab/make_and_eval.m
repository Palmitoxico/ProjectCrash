function f = make_and_eval(directory)
  d = dir([directory '/*.wav']);
  d2 = dir([directory '/*.txt']);
  f0 = [];
  for i = 1 : length(d)
    ref = load([directory  '/'  d2(i).name]);
    f = bpm_and_phase([directory  '/'  d(i).name]);
    bpm = f(1);
    fase = f(2);
    t = bpm_fase_beats(bpm, fase);
    [r, p, f] = evaluate(t, ref);
    f0 = [f0 f];
  end;
  mean(f0)
  var(f0)

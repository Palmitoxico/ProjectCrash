function t = time_beats(x, fs)

  t = find(x, 30);
  t = t / fs;



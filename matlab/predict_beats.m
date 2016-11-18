funtion p = predict_beats(bpm, phase, t0, tmin, tmax)

bps = bpm/60;
spb = 1/bps;

p = [];
t = t0 + phase;

while t < tmin
  t = t + spb;
end;

while t < tmax;
  p = [p t];
  t = t + spb;
end;


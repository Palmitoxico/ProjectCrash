function p = predict_beats(bpm, phase, t0, tmin, tmax)
% p = predict_beats(bpm, phase, t0, tmin, tmax)
%
% Predicts beats in future time based on current analysis
%
% Inputs:
% bpm - beats per minute
% t0 - start of current frame
% phase - delay (seconds) between start of current frame and next beat
% tmin, tmax - boundaries within we wish to yield predicted beats
%
% Outputs:
% p - array of beat locations (in seconds)

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


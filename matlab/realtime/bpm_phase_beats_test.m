function t = bpm_phase_beats_test(bpm, phase, window)
t = [];
i = phase;
spb = 1/(bpm/60);
while i < window 
  t = [t i];
  i = i + spb;
end;






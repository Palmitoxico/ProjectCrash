function t = bpm_phase_beats(bpm, phase, window)

t = [];             % array of marked beats
i = phase;          % first beat marked 
spb = 1/(bpm/60);   % period

while i < window    % marks the beats of a window
  t = [t i];
  i = i + spb;
end






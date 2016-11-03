function t = bpm_fase_beats(bpm, fase)
t = [];
i = fase;
spb = 1/(bpm/60);
while i < 30
  t = [t i];
  i = i + spb;
end;






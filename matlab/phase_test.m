function n = phase_test(period, signal)
% n = phase_test(period, signal)
signal = signal - mean(signal);
max_corr = 0;
best_phase = 0;
for i = 1 : period
  % Generate new pulse train
  x = zeros(size(signal));
  j = i;
  while j < length(signal)
    x(j) = 1;
    j = j + period;
  end
  %x
  c = corr(x, signal);
  if c > max_corr
    best_phase = i;
    max_corr = c;
  end
end
n = best_phase;

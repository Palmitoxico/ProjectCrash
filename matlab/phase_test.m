function n = phase_test(period, signal)
% n = phase_test(period, signal)
max_corr = 0;
best_phase = 0;
c0 = [];
for i = 1 : period
  % Generate new pulse train
  x = zeros(size(signal));
  j = i;
  while j < length(signal)

    x(ceil(j)) = 1;
    j = j + period;
  end
  %x
  c = corr(x, signal);
  c0 = [c0 c];
  if c > max_corr
    best_phase = i;
    max_corr = c;
  end
end
%figure;
%plot(c0);
n = best_phase-1

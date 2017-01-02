function n = phase_test(period, signal)

max_corr = 0;
best_phase = 0;
c0 = [];

for i = 1 : period
  % Generate new pulse train
  x = zeros(size(signal));
  j = i;

  % inicializa variavel de acc = 0
  while j < length(signal)
    x(ceil(j)) = 1;
    % acc += x(ceil(j))
    j = j + period;
  end

  c = corr(x, signal);
  c0 = [c0 c];

  if c > max_corr
    best_phase = i;
    max_corr = c;
  end
end

%figure;
%plot(c0);
n = best_phase-1;

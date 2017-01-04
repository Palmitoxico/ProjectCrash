function n = calcPhase(period, signal)

    max_corr = 0;
    best_phase = 0;
    c0 = [];

    % Search the index that of highest correlation
    for i = 1 : period
      % Generate new pulse train
      x = zeros(size(signal));
      j = i;

      while j < length(signal)
        x(ceil(j)) = 1;
        j = j + period;
      end

      % Calculates the correlation with the pulse train
      c = corr(x, signal);
      c0 = [c0 c];

      % Stores the highest correlation index
      if c > max_corr
        best_phase = i;
        max_corr = c;
      end
    end

      % Returns the index of highest correlation
      n = best_phase-1;

end

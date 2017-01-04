function k = calcPitch(x)

    % Calculate autocorrelation
    X = fft(x, length(x)*2);
    x_acc = abs(ifft(X .* conj(X)));

    % Search the first peak
    x_acc0 = zeros(1,floor(length(x_acc)/2));
    max_so_far = -100;
    max_i = 0;

    for i = 20 : floor(length(x_acc0)/3);
        x_acc0(i) = x_acc(i) - x_acc(ceil(i/2));
        if x_acc0(i) > max_so_far
            max_so_far = x_acc0(i);
            max_i = i;
        end;
    end

    % Returns the lag k for which (x(t)*x(t-k))^2 is the greatest
    k = max_i-1;

end

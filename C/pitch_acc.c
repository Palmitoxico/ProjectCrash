

float32_t pitch_acc(float32_t *samples, uint32_t size) {
/*
  X = fft(x, length(x)*2);
  x_acc = abs(ifft(X .* conj(X)));
*/

  float32_t X_acc[1000];
  float32_t max_so_far = -1;
  float32_t acc0;
  uint32_t max_i = 0;
  uint32_t i, j;
  // Calculate autocorrelation

  for (i = 0; i < size; i++)
  {
    for (j = i; j < size; j++)
    {
      X_acc[i] = X_acc[i] + samples[j]*samples[j-i];
    }
  }

  for (i=0; i < (size/2); i++) {
    acc0 = X_acc[i] - X_acc[i/2];
    if (acc0 > max_so_far) {
      max_so_far = acc0;
      max_i = i;
    }
  }
  return (float32_t) i;

}

function k = pitch_acc(x)
% function k = pitch_acc(x)
%
% Returns the lag k for which (x(t)*x(t-k))^2 is the greatest

% Calculate autocorrelation
X = fft(x, length(x)*2);
x_acc = abs(ifft(X .* conj(X)));

%% So far, we have an autocorrelation function
%figure;
%plot(x_acc);

% It is actually unnecessary to keep track of
% x_acc0, but we may want to plot it later.
x_acc0 = zeros(1,floor(length(x_acc)/2));
max_so_far = -100;
max_i = 0;
for i = 1000 : floor(length(x_acc0)/2);
  x_acc0(i) = x_acc(i);% - x_acc(i*2);
  if x_acc0(i) > max_so_far
    max_so_far = x_acc0(i);
    max_i = i;
  end;
end

%figure;
%plot(x_acc0);
%hold on;
%plot(max_i, max_so_far, 'ro');
%pause;
k = max_i-1;

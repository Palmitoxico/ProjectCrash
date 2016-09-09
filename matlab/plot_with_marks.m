function f = plot_with_marks(y, fs, marks, tolerance)
% Plots signal y and adds marks.
%
% Inputs:
% y: signal, in a one-dimensional array
% fs: sampling frequency of y
% marks: array of time (in seconds) marks
% tolerance: allowed tolerance for time marks (default: 0.01)

if nargin < 4
  tolerance = 0.01
end

ymax = max(y);
ymin = min(y);

t = 1 : length(y);
t = (t-1)/fs;

figure;
plot(t, y, 'k');

for i = 1 : length(marks)
  line( [marks(i)-tolerance, marks(i)+tolerance], [ymax, ymax], 'r');
  line( [marks(i)-tolerance, marks(i)+tolerance], [ymin, ymin], 'r');
  line( [marks(i)-tolerance, marks(i)-tolerance], [ymax, ymin], 'r');
  line( [marks(i)+tolerance, marks(i)+tolerance], [ymax, ymin], 'r');
end

end


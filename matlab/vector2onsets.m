function t = vector2onsets(y, fs)

yd = diff(y);
ydd = find(yd==2);
t = (ydd-1)/fs;






function flow = spectral_flow(x, frame_len, frame_step)

n = 0;

flow = []
while ((n+1)*frame_step + frame_len) < length(x)
  this_frame = x(n*frame_step : n*frame_step + frame_len);
  next_frame = x((n+1)frame_step : (n+1)*frame_step + frame_len);
  y1 = abs(fft(next_frame));
  y2 = abs(fft(this_frame));
  y3 = (y1 - y2);
  y3 = y3 .* (y3 > 0);
  flow = [flow sum(y3)];


end;


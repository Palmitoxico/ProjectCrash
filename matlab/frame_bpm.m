function bpm = frame_bpm(frame_odf, fs)
% function bpm = frame_bpm(frame_odf, fs)
%

lag = pitch_acc(frame_odf);

lag_s = lag  / fs;

bps = 1/lag_s;

bpm = lag_s * 60;



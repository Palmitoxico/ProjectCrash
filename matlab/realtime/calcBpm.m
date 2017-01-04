function bpm = calcBpm(onsets,fs)

bpm = 60*fs/calcPitch(onsets);

end

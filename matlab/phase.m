function phi = phase(odf_frame, fs, bpm)
  %% function phi = phase(odf_frame, fs, bpm)
  %%
  %% Input:
  %% odf_frame :    Array with beats candidates
  %% fs        :    Sampling frequency (Hz)
  %% bpm       :    Beats per minute
  %%
  %% Output:
  %% phi       :    Phase (seconds)
  %%
  %% Description:
  %% Finds the optimal phase in seconds of
  %% the beats
  
  %% Convert from beats per minute to
  %% samples per beat
  samppb = floor((fs * 60) / bpm);

  %% Initializes the max accumulated
  %% value
  maxacc = 0;

  %% Test each phase
  for phasetest = 1

	%% Initializes the accumulated
	%% value for the phase test
	acc = 0;
	
	for sample = 1
      acc = odf_frame(sample + phasetest);
	  sample += samppb;
	  
	  if (sample + phasetest) > length(odf_frame)
		break;
	  endif
	endfor
	
	phasetest += 1;
	
	if acc > maxacc
	  phisamp = phasetest;
	  maxacc = acc;
	endif

	if phasetest > samppb
	  phi = phisamp / fs;
	  break;
	endif
  endfor
end

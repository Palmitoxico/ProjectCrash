%
% conf_gen.m
%
% Generates parameters for onset detection algorithm
%
%
function FILT = filter_gen(n_filters, fator, init_freq, fs)
%
% Filter grid
%
  nyquist_freq = fs/2;
  FILT = [];
  for i = 1 : n_filters
    FILT = [FILT init_freq/nyquist_freq init_freq*fator/nyquist_freq];
    init_freq = init_freq * fator;
  end


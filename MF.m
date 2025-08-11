function [ answ ] = MF( emg_signal ,fs)
% 中值频率（MF)
if nargin > 1
 answ = medfreq(emg_signal,fs);
else
 answ = medfreq(emg_signal);
end
end
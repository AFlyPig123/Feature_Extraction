function [ answ ] = MPF( emg_signal )
% Returns the mean PSD in each bin 平均功率谱

[Pxx, W] = pwelch(emg_signal);
answ = (sum(W.*Pxx))/(sum(Pxx));
end
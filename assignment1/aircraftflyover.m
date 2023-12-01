clear;

load('aircraft_flyover_microphone_assignment1.mat');

y = aircraft_flyover_microphone_assignment1;

t_begin = 0;
samplerate = 40000;
delta_t = 1 / samplerate;

t_end = delta_t*length(y) - delta_t;

t = t_begin:delta_t:t_end;

%% Part I: Figure 1 --> pressure over time
figure();
plot(t,y)

%% Part II

%[S, F, T, P] = spectrogram(y, length(t), 0, length(t), samplerate);
%spectrogram(y)

figure();
% Second value represent the steps whcha re taken to analyse the data,
% larger values will lead to bigger blocks in the time axis, but smaller in
% the frequency axis (note: equally true when making thee value smaller)

% the fourth value represent the amount of zeros wich are added to the
% steps containing the seconds input amount of data. when the value is the
% same no padding will be added
spectrogram(y, 1000, 0, 1000, samplerate, 'yaxis')
colormap turbo
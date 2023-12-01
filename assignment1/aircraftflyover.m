%% Assignment 1: Advanced Aircraft Noise
% By: Elisabeth and Joshua

clear;

load('aircraft_flyover_microphone_assignment1.mat');

y = aircraft_flyover_microphone_assignment1;

t_begin = 0;
samplefrequency = 40000;
samplerate = 1 / samplefrequency;

t_end = samplerate*length(y) - samplerate;

t = t_begin:samplerate:t_end;

%% Part I: Figure 1 --> pressure over time
figure();
plot(t,y)

%% Part II

% time resolution
time_reso = 0.05;   % 0.05 seconds time resolution
padding = 0;

N = time_reso*samplefrequency;
freq_resolution = 1 / time_reso;

figure();
% Second value represent the steps whcha re taken to analyse the data,
% larger values will lead to bigger blocks in the time axis, but smaller in
% the frequency axis (note: equally true when making thee value smaller)

% the fourth value represent the amount of zeros wich are added to the
% steps containing the seconds input amount of data. when the value is the
% same no padding will be added
spectrogram(y, N, 0, N+padding, samplefrequency, 'yaxis')
colormap jet

%% Part III
% Extract values from the plot, generated previously in part II
[S, F, T, P] = spectrogram(y, N, 0, N+padding, samplefrequency, 'yaxis');

pe = sqrt(freq_resolution.*sum(P));

figure();
plot(T, pe)

%% Part IV
% time resolution
time_reso = 0.125;   % 0.125 seconds time resolution
padding = 0;

N = time_reso*samplefrequency;
freq_resolution = 1 / time_reso;

figure();
spectrogram(y, N, 0, N+padding, samplefrequency, 'yaxis')
colormap winter

[S, F, T, P] = spectrogram(y, N, 0, N+padding, samplefrequency, 'yaxis');

% select signal inbetween 10.500 seconds and 10.625 seconds
% (10.625 + 10.500) / 2 == > 10.5625 (This can be observed to be located 
% @ index 85 of the Time array (T))

S_85 = S(:,85);     % Fourier transform
P_85 = P(:,85);

pr = (samplefrequency*abs(S_85).^2)/N;

figure();
plot(pr)

% Look into fft
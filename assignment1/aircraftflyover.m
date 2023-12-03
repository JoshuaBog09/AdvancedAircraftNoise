%% Assignment 1: Advanced Aircraft Noise
% By: Elisabeth and Joshua

clear;

load('aircraft_flyover_microphone_assignment1.mat');
y = aircraft_flyover_microphone_assignment1;

t_begin = 0;
samplefrequency = 40000;
time_resolution = 1 / samplefrequency;

t_end = time_resolution*length(y) - time_resolution;

t = t_begin:time_resolution:t_end;

%% Part I: Figure 1 --> pressure over time
figure();
plot(t,y)

%% Part II

% time resolution
time_reso = 0.075;   % 0.05 seconds time resolution
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

%% Part IV Method 2
time_reso = 0.125;   % 0.125 seconds time resolution
padding = 0;

N = time_reso*samplefrequency;
freq_resolution = 1 / time_reso;
t_array = 0:time_reso:t_end;
% index 85 returns 10.500 seconds to 10.625 seconds
id = 85;

pressure_85 = y(1 + id*N: (id+1)*N);
fourier_coef = fft(pressure_85);
Y = fourier_coef;

f = 0: freq_resolution: (N-1)*freq_resolution; %create the frequency x-axis
psd = (time_resolution^2/time_reso(end))*(abs(Y).^2);



figure(1);
plot(f, psd, '+k'); xlabel('frequency');
ylabel('PSD'); title('PSD 0-40k'); grid; axis([0 samplefrequency 0 0.015])

% Half sided 

f_half = 0:freq_resolution:(N-1)*freq_resolution/2;
psd_half = ((1/sqrt(2))^2) * (2^2) * psd(1:length(f_half));

figure(2);
plot(f_half, psd_half, '+k'); xlabel('frequency');
ylabel('PSD'); title('PSD 0-40k'); grid; axis([0 samplefrequency 0 0.02])

%% Part V


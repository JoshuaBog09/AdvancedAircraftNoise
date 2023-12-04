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

pressure_85 = y(1 + (id-1)*N: (id)*N);
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

OSPL_time = zeros(1,146);
OSPL_freq = zeros(1,146);

peo2 = (2*10^(-5))^2; 

for id=1:1:146
    pressure = y(1 + (id-1)*N: (id)*N);
    pressure_fft = fft(pressure);
    
    psd = (time_resolution^2/time_reso)*(abs(pressure_fft).^2);

    pe2_time = sum(pressure.^2)*time_resolution / time_reso;
    OSPL_time(id) = 10*log10(pe2_time/peo2);
    
    pe2_freq = freq_resolution*sum(2*psd(1:2500));
    OSPL_freq(id) = 10*log10(pe2_freq/peo2);
end

% pe2_time = sum(pressure_85.^2)*time_resolution / time_reso;
% OSPL_time = 10*log10(pe2_time/peo2);
% 
% pe2_freq = freq_resolution*sum(2*psd(1:2500));
% OSPL_freq = 10*log10(pe2_freq/peo2);

figure();
hold on
plot(t_array, OSPL_time, "-k")
plot(t_array, OSPL_freq, "ob")
legend("time sampled OSPL", "frequency sampled OSPL")  

%% Part VI

% Procedure: To be used in for Part VI
% f(1:2500) <-- only half of the frequencies are considered
% for all of these frequencies the dla can be found
% dLa = -145.528 + 98.262 * log(f) - 19.509 * (log(f))^2 + 0.975 * (log(f))^3;
% La = PSL - dla
% where PSL = 10 log (2Pr/peo2)
% then oaspl = 10 log (deltaf * sum (10^La/10) ) Only performed over half
% of the frequencies due to doubling of Pr this takes into acount the equal
% peak at the negative side.

OASPL = zeros(1,146);

peo2 = (2*10^(-5))^2; 

f_range = f(1:2500) + 4;

dLa = -145.528 + 98.262 * log10(f_range) - 19.509 * (log10(f_range)).^2 + 0.975 * (log10(f_range)).^3;

for id=1:1:146
    pressure = y(1 + (id-1)*N: (id)*N);
    pressure_fft = fft(pressure);

    psd = (time_resolution^2/time_reso)*(abs(pressure_fft).^2);

    pslr = 10*log10(2*psd(1:2500)/peo2);

    la = pslr + dLa;

    OASPL(id) = 10*log10(freq_resolution*sum(10.^(la/10)));
end

figure();
hold on
plot(t_array, OSPL_time, "-k")
plot(t_array, OSPL_freq, "ob")
plot(t_array, OASPL)
legend("time sampled OSPL", "frequency sampled OSPL", "OASPL")

%% Part VII

% Perform integration with over bounds with 10db down time
% wher T1 is equal to one

LaMax = max(OASPL);

db_down_time = 10;

OASPL_10 = OASPL(OASPL > LaMax - db_down_time);
% Selected_DBa_time = t_array(OASPL > LaMax - db_down_time);
% 
% figure();
% hold on
% plot(t_array, OASPL)
% plot(Selected_DBa_time, Selected_DBa)

SEL = 10*log10(sum(10.^(OASPL_10/10))*time_reso);
%% Assignment 2: Advanced Aircraft Noise
% By: Elisabeth and Joshua

clear;

%% Constants

delta = 0.001;
N = 128;
f1 = 100;
f2 = 125;

k = 0:1:N-1;

xk = sin(2*pi*f1*k*delta) + 0.1*sin(2*pi*f2*k*delta);

plot(k, xk)

%% Part I

fr = k / (N*delta);

Xr = fft(xk);

peak1 = abs(Xr(14)) / 1;
peak2 = abs(Xr(17)) / 0.1;

figure(1);
plot(fr, abs(Xr))
xlabel('frequency [Hz]')
ylabel('|Xr|')

%% Part II

N = 128;
k = 0:1:N-1;

xk = sin(2*pi*f1*k*delta) + 0.1*sin(2*pi*f2*k*delta);
xk_padded = resize(xk, 2048);

N_padded = 2048;
k_padded = 0:1:N_padded-1;

Xr_padded = fft(xk_padded);
fr_padded = k_padded / (N_padded*delta);

figure(2);
plot(fr_padded, abs(Xr_padded))
xlabel('frequency [Hz]')
ylabel('|Xr|')

peak1_padded = abs(Xr_padded(206))/1;
peak2_padded = abs(Xr_padded(260))/0.1;

%% Part III

N = 128;
k = 0:1:N-1;
xk = sin(2*pi*f1*k*delta) + 0.1*sin(2*pi*f2*k*delta);

hanning_weighting = hann(N).';
xk_weighted = xk.*hanning_weighting;
fr = k / (N*delta);

figure();
hold on
plot(k, xk)
plot(k, hanning_weighting, "k--")
xlabel("Time [ms]")
ylabel("Xk [-]")
legend("Original Signal", "Weighting function")

figure();
plot(k, xk_weighted)
xlabel("Time [ms]")
ylabel("Xk [-]")

xk_weighted_padded = resize(xk_weighted, 2048);

N_padded = 2048;
k_padded = 0:1:N_padded-1;

Xr_weighted_padded = fft(xk_weighted_padded);
fr_weighted_padded = k_padded / (N_padded*delta);

figure(4);
plot(fr_weighted_padded, abs(Xr_weighted_padded))
xlabel('frequency [Hz]')
ylabel('|Xr|')

peak1_weighted = abs(Xr_weighted_padded(206));
peak2_weighted = abs(Xr_weighted_padded(250)) / 0.1;

%% END
%% Assignment 3: Advanced Aircraft Noise
% By: Elisabeth and Joshua

clear;

% tdfread('data_asignment3','\t')
data = importdata('data_asignment3');

%%% Start Script %%%

%% Aircraft Data (737)

v = 81; % m/s
A_w = 130; % m^2
b_w = 34; % m
A_f = 18; % m^2
b_f = 17; % m
d = 1.1; % m
n_w = 2;
n_b = 2;
n = n_w*n_b;

mu = 1.84*10^(-5); % kg/(m*s)
rho = 1.225;
c = 340.3;

M = v/c;

band_numbers = 1:1:43;
f = 10.^(band_numbers/10);

% assumed values
theta = pi / 2;
phi = 0;
r = 1;
delta_f = pi/6;

%% Formulas lg

K = 3.414*10^(-4);
a = 6;
G = n*(d/b_w)^2;
L = d;

% Power function
P = K*(M^a)*G*rho*(c^3)*(b_w^2);

% Strouhal number
S = (f * L * (1 - M*cos(theta))) / (M*c);

% Spectral function
F = 0.0577 .* (S.^2) .* ((0.25*S.^2) + 1).^(-1.5);

% Directivity funtion
D = (3/2)*(sin(theta))^2;

% 
psquared_lg = (rho*c*P*D*F) / (4*(pi^2)*(r^2)*(1-M*cos(theta))^4);

%% Flaps formulas
K = 2.787*10^(-4);
a = 6;
G = (A_f/(b_w^2))*(sin(delta_f))^2;
L = A_f/b_f;

% Power function
P = K*(M^a)*G*rho*(c^3)*(b_w^2);

% Strouhal number
S = (f * L * (1 - M*cos(theta))) / (M*c);

% Spectral function
F = zeros(size(S));

% Apply the conditions for each range
F(S < 2) = 0.0480 * S(S < 2);
F((2 <= S) & (S <= 20)) = 0.1406 * S((2 <= S) & (S <= 20)).^(-0.55);
F(S > 20) = 216.49 * S(S > 20).^(-3);

% Directivity funtion
D = 3*(sin(delta_f)*cos(theta)+cos(delta_f)*sin(theta)*cos(phi))^2;

psquared_fl = (rho*c*P*D*F) / (4*(pi^2)*(r^2)*(1-M*cos(theta))^4);

%% Formulas (wing)
K = 4.464*10^(-5);
a = 5;
G = 0.37*(A_w / b_w^2)*((rho*M*c*A_w) / (mu*b_w))^(-0.2);
L = G*b_w;

% Power function
P = K*(M^a)*G*rho*(c^3)*(b_w^2);

% Strouhal number
S = (f * L * (1 - M*cos(theta))) / (M*c);

% Spectral function
F = 0.613 * ((10*S).^4) .* (((10*S).^(1.5)) + 0.5).^(-4);

% Directivity funtion
D = 4 * (cos(phi)^2) * (cos(theta / 2)^2);

% 
psquared_wg = (rho*c*P*D*F) / (4*(pi^2)*(r^2)*(1-M*cos(theta))^4);

%% Formulas (slats)

K = 4.464*10^(-5);
a = 5;
G = 0.37*(A_w / b_w^2)*((rho*M*c*A_w) / (mu*b_w))^(-0.2);
L = G*b_w;

% Power function
P = K*(M^a)*G*rho*(c^3)*(b_w^2);

% Strouhal number
S = (f * L * (1 - M*cos(theta))) / (M*c);

% Spectral function
F = (0.613 * ((10*S).^4) .* (((10*S).^(1.5)) + 0.5).^(-4)) ...
    + (0.613 * ((2.19*S).^(4)) .* (((2.19*S).^1.5) + 0.5).^(-4));

% Directivity funtion
D = 4 * (cos(phi)^2) * (cos(theta / 2)^2);

% 
psquared_sl = (rho*c*P*D*F) / (4*(pi^2)*(r^2)*(1-M*cos(theta))^4);

%% Plots

% figure();
% semilogx(f,psquared)

figure();
semilogx(data(1,:), data(2,:))

res_wg = 10*log10((psquared_wg ./ f) / (2*10^(-5))^2);
res_fl = 10*log10((psquared_fl ./ f) / (2*10^(-5))^2);
res_sl = 10*log10((psquared_sl ./ f) / (2*10^(-5))^2);
res_lg = 10*log10((psquared_lg ./ f) / (2*10^(-5))^2);

res_wg = res_wg - 10*log10(0.23*f);
res_fl = res_fl - 10*log10(0.23*f);
res_sl = res_sl - 10*log10(0.23*f);
res_lg = res_lg - 10*log10(0.23*f);

semi = 10 * log10((psquared_wg + psquared_fl + psquared_sl + psquared_lg ) / (2*10^(-5))^2 );
res_tot = semi - 10*log10(0.23*f);


% res_tot = 10 * log10(10.^(res_wg/10) + 10.^(res_fl/10) + 10.^(res_sl/10) + 10.^(res_lg/10));

% Pa^2 (output of previous parts of the code)
% P

% res = 10*log10(psquared ./ f) - 10*log10(0.23*f);

% res = 10*log10(psquared ./ f);

figure();
semilogx(f, res_wg)
hold on
semilogx(f, res_fl)
semilogx(f, res_sl)
semilogx(f, res_lg)
semilogx(f, res_tot, LineStyle="--")
legend("Wing", "Flaps", "Slats", "Landing gear", "total")
xlabel('Frequency [Hz]')
ylabel('PSD [dB/Hz]')

%% Comparison measured and modelled

figure();
semilogx(f,res_tot)
hold on
semilogx(data(1,:), data(2,:))
legend("Modeled", "Measured")
xlabel('Frequency [Hz]')
ylabel('PSD [dB/Hz]')

%% OSPL for both measure and modeled sound data

OSPL_mdl = 10*log10(sum(10.^(res_tot/10)));
OSPL_msr = 10*log10(sum(10.^(data(2,:)/10)));

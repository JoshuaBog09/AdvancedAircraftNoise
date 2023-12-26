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

theta = pi / 2;
r = 1;

%% Formulas

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

%% Flaps formulas
K = 2.787*10-4;
a = 6;
delta_f = pi/6; %ASSUMPTION
G = A_f/b_f^2*(sin(delta_f))^2;
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

psquared = (rho*c*P*D*F) / (4*(pi^2)*(r^2)*(1-M*cos(theta))^4);

%%

% 
%psquared = (rho*c*P*D*F) / (4*(pi^2)*(r^2)*(1-M*cos(theta))^4);

figure();
semilogx(f,psquared)

figure();
semilogx(data(1,:), data(2,:))

res = 10*log10((psquared ./ f) / (2*10^(-5))^2);
% res = 10*log10(psquared ./ f) - 10*log10(0.23*f);

% res = 10*log10(psquared ./ f);

figure();
semilogx(f, res)


%% Assignment 6: Advanced Aircraft Noise
% By: Elisabeth and Joshua

clear;

%% Excersise 1

f = 0:10:100000;

R = 24;
L = 20e-3;

s = tf('s');    % s -> j * omega

H1 = (s*L) / (R + s*L);
H2 = R / (R + s*L);

% Bodeplot for first transfer function
% Identified to be High pass filter (HPF)
figure(1);
bp1 = bodeplot(H1);
setoptions(bp1,'FreqUnits','Hz');

% Bodeplot for second transfer function
% Identified to be Low pass filter (LPF)
figure(2);
bp2 = bodeplot(H2);
setoptions(bp2,'FreqUnits','Hz');

% Long methode to check bode plots
%c1 = 20*log10(R ./ sqrt(R^2 + (2*pi*f).^2 * L^2));
c2 = R ./ (R + 2*pi*f*L*1i);
c1 = (2*pi*f*L*1i) ./ (R + (2*pi*f*L*1i));

% Checker for phase

cp2 = 0 - atan((2*pi*f*L)./(R));
cp1 = pi/2 - atan((2*pi*f*L)./(R));

figure(3);
semilogx(f, 20*log10(abs(c1)))
hold on
semilogx(f, 20*log10(abs(c2)))

figure(4);
semilogx(f, cp2*180/pi)
hold on
semilogx(f, cp1*180/pi)

%% Excersise 2


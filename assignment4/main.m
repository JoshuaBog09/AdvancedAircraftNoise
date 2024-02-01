%% Assignment 4: Advanced Aircraft Noise
% By: Elisabeth and Joshua

clear;

load('hydrophonedata_AE4463P.mat')

%% Start Script 

c = 1500;       % Speed of sound in water [m/s]
fs = 6000;      % Smample frequency [Hz]
d = 2;          % Distance between microphones [m]
n_mic = 128;    % Number of microphones [-]
p_ref = 1e-6;   % Refrence ressure for water [Pa]

% Visualise the data

figure();
%[X,Y] = meshgrid(1:0.5:10,1:20);
[X,Y] = meshgrid(1/fs:1/fs:1,1:128);
surf(X,Y,y1,'EdgeColor' ,'none')
view([0 90])
colorbar

figure();
imagesc(1/fs:1/fs:1,1:128,y1); 
colormap turbo; 
axis xy;
colorbar

%% Part for Q1 and Q2 (Theoretical questions)

angle = 90:-1:0;
f = ((2/1500)*(sin(angle*pi/180)+1)).^(-1);

figure();
plot(f, angle)

%% Part 3 Beamforming 

% Step 1: fourier transform data from one microphone
% Step 2: add phase delay from stearing
% Step 3: repeat for all microphones
% Step 4: repeat for all stearing angles
% Step 5: Convert to dB presentation

final = zeros(201,fs);
row = 0;

for steering_angle = -50:0.5:50
    
    inter = zeros(1, fs);
    row = row + 1;
    for n = 1:n_mic
        d_mic = y1(n,:);
        
        fk = 1:fs;
        fc_mic = fft(d_mic);
        
        %plot(fk,fc_mic) % View the fourier coef over frequency
        
        tau_n = (d/c) * n * sin(steering_angle*pi/180);
        inter = inter + fc_mic.*exp(2*pi*1i*fk*tau_n);
    end
    
    inter = 10*log10((abs(inter).^2)/(p_ref^2));
    final(row,:) = inter;
end

figure();
imagesc(-50:0.5:50, 2:6000, final(:,2:end).'); 
colormap turbo; 
axis xy;
colorbar
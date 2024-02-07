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
f = ((d/c)*(sin(angle*pi/180)+1)).^(-1);

figure();
plot(f, angle)

%% Part 3 Beamforming 

% Step 1: fourier transform data from one microphone
% Step 2: add phase delay from stearing
% Step 3: repeat for all microphones
% Step 4: repeat for all stearing angles
% Step 5: Convert to dB presentation

% Microphone 113 seems to be defect

steering_angles = -75:0.5:75;
fk = 1:fs;  % Frequencies

final = zeros(size(steering_angles,2),fs);
row = 0;

for steering_angle = steering_angles
    
    inter = zeros(1, fs); % Storage of results for a single stearing angle but all frequencies
    row = row + 1;
    
    for n = 1:n_mic
        
        d_mic = y1(n,:);     % Microphone data of microphone n
        
        fc_mic = fft(d_mic); % Fourier coefficient a signular microphone n
        
        %plot(fk,fc_mic) % View the fourier coef over frequency
        
        tau_n = (d/c) * n * sin(deg2rad(steering_angle));   % Phase shift parameter
        inter = inter + fc_mic.*exp(2*pi*1i*fk*tau_n);      % Sum over all microphones
    end
    
    inter = 10*log10((abs(inter).^2)/(p_ref^2));    % Convert to dB
    final(row,:) = inter;                           % append to solution...
    % array based on steering angle in evaluation 
    % (note all frequencies are added for the sum of all microphones)
end

figure();
imagesc(steering_angles, 20:fs/2, final(:,20:fs/2).'); 
colormap turbo; 
axis xy;
colorbar;
xlabel('Steering angle [deg]');
ylabel('frequency [Hz]');
cb = colorbar(); 
ylabel(cb,'Power (dB)','Rotation',270)
%clim(); % <--- set bounds on colorbar
%% Assignment 4: Advanced Aircraft Noise
% By: Elisabeth and Joshua

clear;

load('hydrophonedata_AE4463P.mat')

%% Start Script 
global c
global d
global n_mic

c = 1500;       % Speed of sound in water [m/s]
fs = 6000;      % Smample frequency [Hz]
d = 2;          % Distance between microphones [m]
n_mic = 128;    % Number of microphones [-]
p_ref = 10^(-6);   % Refrence ressure for water [Pa]

% Visualise the data

figure(5);
%[X,Y] = meshgrid(1:0.5:10,1:20);
[X,Y] = meshgrid(1/fs:1/fs:1,1:128);
surf(X,Y,y1,'EdgeColor' ,'none')
view([0 90])
colorbar

figure(6);
imagesc(1/fs:1/fs:1,1:128,y1); 
colormap turbo; 
axis xy;
colorbar

%% Part for Q1 and Q2 (Theoretical questions)

angle = 90:-1:0;
f = ((d/c)*(sin(angle*pi/180)+1)).^(-1);

figure(10);
plot(angle, f)

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
        
        fc_mic = fft(d_mic); % Fourier coefficient a signular microphone n (One sided PSD)
        
        %plot(fk,fc_mic) % View the fourier coef over frequency
        
        tau_n = (d/c) * n * sin(deg2rad(steering_angle));   % Phase shift parameter
        inter = inter + fc_mic.*exp(2*pi*1i*fk*tau_n);      % Sum over all microphones
    end
    
    inter = 10*log10((abs(inter).^2)/(p_ref^2));    % Convert to dB
    final(row,:) = inter;                           % append to solution...
    % array based on steering angle in evaluation 
    % (note all frequencies are added for the sum of all microphones)
end

figure(14);
imagesc(steering_angles, 20:fs/2, final(:,20:fs/2).'); 
colormap turbo; 
axis xy;
colorbar;
xlabel('Steering angle [deg]');
ylabel('frequency [Hz]');
cb = colorbar(); 
ylabel(cb,'Power (dB)','Rotation',270)
%clim(); % <--- set bounds on colorbar

%% Lobe plots

lambda = c / fs;
angles = -90:1:90;

K = ((2 * pi) / lambda) * sin(deg2rad(angles));
D = sin(n_mic * K * d / 2) ./ (n_mic * sin(K * d / 2));

figure(15);
plot(angles, abs(D))

%% Steering angle

f = 20:1:3000;
angle = 30;

Thetabs = (c) ./ (cos(deg2rad(angle)) * n_mic * d * f);

sidelobe_angles = -58; % You can adjust this if you want a range of angles
sidelobe_values = sind(sidelobe_angles) + lambda/d;

figure(16);
ax = imagesc(steering_angles, 20:fs/2, final(:,20:fs/2).');
hold on;
colormap turbo; 
axis xy;
colorbar;
xlabel('Steering angle [deg]');
ylabel('frequency [Hz]');
cb = colorbar(); 
ylabel(cb,'Power (dB)','Rotation',270)

plot(rad2deg(Thetabs) + angle, f, LineWidth=1,Color="k")
plot(-rad2deg(Thetabs) + angle, f, LineWidth=1,Color="k")

addBeamWidth(-64, f)

addBeamWidth(-25, f)

addBeamWidth(-4, f)

plot(sidelobe_angles, sidelobe_values, 'r--', 'LineWidth', 1.5)

% Above is due to anti aliassing filter
% Peaks are real sound sources, they really exist
% Curves are fales data (steering), they are not real sound sources
% Below also not really good data to use (low freq)

%%
%sidelobe = sind(-58) + lambda/d;

%Sidelobe calculation
% sidelobe_angle = -58;
% sidelobe_value = sind(sidelobe_angle) + lambda/d;

sidelobe_angles = -58:1:58;  % Adjust the range as needed
sidelobe_values = sin(deg2rad(sidelobe_angles)) + lambda/d;

figure(16);
hold on;
plot([sidelobe_angles, sidelobe_values], 'k--', 'LineWidth', 2)
%hold off;




%%
function addBeamWidth(steeringangle, f)
    %{
    Function to add the expected beam with to the data plot currently in
    use. The analysed steering angle of the signal is provided as input
    toghetter with the analysed frequencies. The result is then super
    imposed onto the beamformed data figure.
    %}
    global c
    global n_mic
    global d
    
    BeamWidth = c ./ (cos(deg2rad(steeringangle)) * n_mic * d * f);
    
    plot(rad2deg(BeamWidth) + steeringangle, f, LineWidth=1, Color="k")
    plot(-rad2deg(BeamWidth) + steeringangle, f, LineWidth=1, Color="k")

end









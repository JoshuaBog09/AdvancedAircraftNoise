%% Assignment 4: Advanced Aircraft Noise
% By: Elisabeth and Joshua

clear;

load('hydrophonedata_AE4463P.mat')

%% Start Script 

c = 1500;
fs = 6000;
s_mic = 2;

% plot(y1(1,:))


figure();
%[X,Y] = meshgrid(1:0.5:10,1:20);
[X,Y] = meshgrid(1/6000:1/6000:1,1:128);
surf(X,Y,y1,'EdgeColor' ,'none')
view([0 90])
colorbar

figure();
imagesc(1/6000:1/6000:1,1:128,y1); 
colormap jet; 
axis xy;
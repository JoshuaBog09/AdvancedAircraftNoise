% Assignment 5: Advanced Aircraft Noise

clear;

%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: Array\Array.txt
%
% Auto-generated by MATLAB on 16-Feb-2024 14:20:26

% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["VarName1", "VarName2", "VarName3"];
opts.VariableTypes = ["double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
Array = readtable("Array\Array.txt", opts);

% Convert to output type
Array = table2array(Array);

% Clear temporary variables
clear opts

load('Array\aircraft_noise_data_overhead_2020.mat');

h = 64.87;      % [m]
fs = 40000;     % [Hz]
n_mic = 32;     % [-]
c = 343;        % [m/s]

x_mic = Array(:,2);
y_mic = Array(:,3);

%% Main code

figure();
plot(x_mic, y_mic, "o");
hold on
axis equal
% add circle https://stackoverflow.com/a/29194105
pos = [[0 0]-1 2 2];

rectangle('Position',pos,'Curvature',[1 1]);

resolution = 0.25;  % [m]

X = -25:resolution:25;
Y = -25:resolution:25;

X_size = size(X,2);
Y_size = size(Y,2);

scanning_plane = zeros(X_size, Y_size);

%% fft

T = 0.05;
N = length(p(1,:));
delta_t = T / N;
fs = 1 / delta_t;
delta_f = 1 / T;

% delta_t = 1 / fs;
% delta_f = 1 / 0.05;
% t = 0:delta_t:0.05;     % 50 ms
% N = length(t);

% fourier_coef = fft(p(1,:), N);

[S, F, T, P] = spectrogram(p(1,:), N, 0, N, fs, 'yaxis');





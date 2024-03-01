% Assignment 5: Advanced Aircraft Noise

clear;
clc;

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
xlabel("x-position [m]");
ylabel("y-position [m]");
hold on
axis equal

% add circle https://stackoverflow.com/a/29194105
rectangle('Position',[[0 0]-1 2 2],'Curvature',[1 1],'LineStyle','--');

resolution = 0.25;  % [m]

X = -25:resolution:25;
Y = -30:resolution:30;

X_size = size(X,2);
Y_size = size(Y,2);

scanning_plane = zeros(Y_size, X_size);

%% 

microphone = 1;

T = 0.05;
N = length(p(microphone,:));
delta_t = T / N;
fs = 1 / delta_t;
delta_f = 1 / T;

fcf = [];

for microphone = 1:n_mic
    [S,F,T,P] = spectrogram(p(microphone,:), N, 0, N, fs, 'yaxis');
    fcf = [fcf; S.'];
end
% For every grid point, for every frequency

% gp_x = 1;
% gp_y = 1;
% k    = 10;

for x_plane = 1:X_size
    for y_plane = 1:Y_size
        
        disp([x_plane, y_plane]);

        inter = 0;
        
        % Select band to anlyse and make sure to also change the N factor
        % for averaging
        %for k = 76:226 % <--- activates low freq (landing gear)
        for k = 226:476 % <--- activates high freq (Engine)
        
            r = sqrt((x_mic - X(x_plane)).^2 + (y_mic - Y(y_plane)).^2 + h^2);
            g = exp(-2*pi*1i*F(k)*(r/c)) ./ r;
            g_ct = ctranspose(g);
            
            x_coef = fcf(:,k);
            x_coef_ct = ctranspose(x_coef);
            
            %inter = inter + g_ct*(x_coef*x_coef_ct)*g / (abs(g.')*abs(g));
            %inter = inter + g_ct*(x_coef*x_coef_ct)*g;
            %inter = inter + normalize(g_ct*(x_coef*x_coef_ct)*g) ;
            inter = inter + g_ct*(x_coef*x_coef_ct)*g / norm(g);

        end
        
        %inter = inter / (150);
        inter = inter / (250);
        
        scanning_plane(y_plane, x_plane) = inter;
    end
end

%%
figure();
imagesc(X, Y, abs(scanning_plane))
daspect([1 1 1])
xlabel("x position [m]")
ylabel("y position [m]")

% Enable to save figures to appropriate directory
% ax = gca;
% % Requires R2020a or later
% exportgraphics(ax,'Figures\HighFreq_compact.png','Resolution',300) 
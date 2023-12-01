clear;

load('aircraft_flyover_microphone_assignment1.mat');

y = aircraft_flyover_microphone_assignment1(1,:);

t_begin = 0;
samplerate = 40000;
delta_t = 1 / samplerate;

t_end = delta_t*length(y) - delta_t;

t = t_begin:delta_t:t_end;

%% Part I: Figure 1 --> pressure over time
figure();
plot(t,y)

%% Part II

% Adaptive Noise Cancellation using LMS Algorithm
% Final Corrected Version

clc;
clear;
close all;

%% PARAMETERS
N = 2000;            % Number of samples
fs = 1000;           % Sampling frequency
f = 5;               % Sine frequency
mu = 0.001;          % Step size
filter_order = 32;   % Filter length

%% CLEAN SIGNAL
n = 0:N-1;
s = sin(2*pi*f*n/fs);

%% GENERATE NOISE
noise = 0.3 * randn(1,N);

%% PRIMARY INPUT (NOISY SIGNAL)
d = s + noise;

%% CORRELATED REFERENCE NOISE
x = filter([1 0.5],1,noise);

%% LMS INITIALIZATION
w = zeros(filter_order,1);
y = zeros(1,N);
e = zeros(1,N);

%% LMS ALGORITHM
for i = filter_order:N
    
    x_vec = x(i:-1:i-filter_order+1)';
    
    y(i) = w' * x_vec;      % Estimated noise
    
    e(i) = d(i) - y(i);     % Cleaned output
    
    w = w + mu * e(i) * x_vec;
end

%% CORRECT SNR CALCULATION
noise_before = noise;      % Original noise
noise_after  = s - e;      % Residual noise after filtering

snr_before = 10*log10(sum(s.^2)/sum(noise_before.^2));
snr_after  = 10*log10(sum(s.^2)/sum(noise_after.^2));

fprintf('SNR Before Filtering : %.2f dB\n', snr_before);
fprintf('SNR After Filtering  : %.2f dB\n', snr_after);

%% PLOTS

figure('Name','Adaptive Noise Cancellation');

subplot(4,1,1)
plot(s)
title('Original Clean Sine Signal')
xlabel('Samples')
ylabel('Amplitude')
grid on

subplot(4,1,2)
plot(d)
title('Noisy Signal')
xlabel('Samples')
ylabel('Amplitude')
grid on

subplot(4,1,3)
plot(e)
title('Filtered Output (After LMS)')
xlabel('Samples')
ylabel('Amplitude')
grid on

subplot(4,1,4)
plot((d-e).^2)
title('Error Convergence Curve')
xlabel('Iterations')
ylabel('Squared Error')
grid on

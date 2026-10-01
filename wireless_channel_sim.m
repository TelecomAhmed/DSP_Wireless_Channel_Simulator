%% Wireless Channel Simulator and Signal Recovery (DSP)
% Description: Simulates baseband signal transmission through an AWGN 
% wireless channel and implements a digital LTI filter (Convolution) 
% to recover the original signal, followed by frequency spectrum analysis.

% =========================================================================
% 1. Sampling and Signal Parameters
% =========================================================================
fs = 8000;                 % Sampling frequency (Hz) - Standard telecom rate
t = 0:1/fs:1-1/fs;         % Time vector for 1 second duration
f_info = 50;               % Information signal frequency (Baseband)

% Generating the baseband information signal
info_signal = sin(2*pi*f_info*t); 

% =========================================================================
% 2. Wireless Channel Simulation (AWGN)
% =========================================================================
% Simulating channel noise mathematically (Additive White Gaussian Noise)
noise_variance = 0.6; 
channel_noise = sqrt(noise_variance) * randn(size(t)); 

% The signal received at the antenna (distorted by the channel)
received_signal = info_signal + channel_noise; 

% =========================================================================
% 3. Digital Filter Design & Signal Recovery (LTI System)
% =========================================================================
% Designing a discrete-time Low-Pass Filter (FIR - Moving Average)
filter_order = 15; 
h_n = ones(1, filter_order) / filter_order; % Impulse response h[n]

% Recovering the signal using Discrete Convolution Sum 
recovered_signal = conv(received_signal, h_n, 'same');

% =========================================================================
% 4. Frequency Analysis (Fourier Transform)
% =========================================================================
N = length(t);
f_axis = (-N/2:N/2-1)*(fs/N); % Frequency axis definition for plotting

% Computing FFT and shifting zero-frequency to center
fft_received = fftshift(fft(received_signal));
fft_recovered = fftshift(fft(recovered_signal));

% Calculating magnitude spectra
mag_received = abs(fft_received) / N;
mag_recovered = abs(fft_recovered) / N;

% =========================================================================
% 5. System Output & Visualization
% =========================================================================
figure('Name', 'DSP Receiver Analysis', 'Position', [100, 100, 900, 600]);

% --- Time Domain: Received vs Recovered ---
subplot(2,2,1);
plot(t, received_signal, 'r'); 
title('Received Signal in Channel (Time Domain)'); 
xlabel('Time (s)'); ylabel('Amplitude');
xlim([0 0.15]); grid on;

subplot(2,2,2);
plot(t, recovered_signal, 'b', 'LineWidth', 1.5); 
title('Recovered Signal after LTI Filter (Time Domain)'); 
xlabel('Time (s)'); ylabel('Amplitude');
xlim([0 0.15]); grid on;

% --- Frequency Domain: Spectra Comparison ---
subplot(2,2,3);
plot(f_axis, mag_received, 'r'); 
title('Spectrum of Received Signal (Noise + Info)'); 
xlabel('Frequency (Hz)'); ylabel('Magnitude');
xlim([-300 300]); grid on;

subplot(2,2,4);
plot(f_axis, mag_recovered, 'b', 'LineWidth', 1.5); 
title('Spectrum of Recovered Signal (Filtered)'); 
xlabel('Frequency (Hz)'); ylabel('Magnitude');
xlim([-300 300]); grid on;

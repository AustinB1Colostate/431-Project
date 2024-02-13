%% Preprocessing and Pan Tompkins Algorithm for Project
clc;
close all;
clear;
%% Load in the signal data
% Started working with the ecgiddb_person database
load('ecgiddb_person01_rec10m.mat'); % load data
whos
type('ecgiddb_person01_rec10m.info');

n = length(val);    % get no. of samples
dt = 0.002; % sampling interval sec
fs = 1/dt; %sample rate in Hz
T = n*dt ; %sampling window in seconds
t=(1:n)/500;        % time sampling vector
x = val / 200;      % scaled to mV
rng('default');     % seed random number generator for repeatability

%Plot the original signal
figure (1);
plot(t,x);
xlim([0,2.5])  
xlabel('Time [sec]');
ylabel('Signal [mV]');
title('ECG original');

% %% Looking in frequency domain
% x_f = fftshift(fft(x));
% df = 1/T; % frequency resolution
% f = ((1:n)-1)*df; % start at DC, go up to fs
% figure(2)
% plot(f,abs(x_f)); set(gca,'yscale','log')
% xlim([0,fs/2]) % plot up to Nyquist
% xlabel('freq, Hz')


%% Start of Pan-Tompkins 

%Band Pass Filter 

%- may need to adjust butterworth
[b,a] = butter(1, [5 15]/(fs/2), 'bandpass'); % 1st order Butterworth band-pass filter
filteredECG = filter(b, a, x);
%time plot
figure(3) 
subplot(2,2,1)
plot(t,filteredECG)
title('ECG Filtered')
xlabel('Time [sec]');
ylabel('Signal [mV]');
xlim([0,2.5]); 
ylim([-0.4,0.8]);
subplot(2,2,2);
plot(t,x);
title('ECG Original')
xlabel('Time [sec]');
ylabel('Signal [mV]');
xlim([0,2.5]); 
ylim([-0.4,0.8]);
%freq plot

%Derivation
b_derv = [1, 0 ,-1];
diffECG = conv(filteredECG, b_derv,'same');
% diffECG = diff(filteredECG);
%time plot
subplot(2,2,3);
plot(t,filteredECG,t,diffECG);
legend('Filtered ECG','Derivative');
title('ECG After Derivation');
xlabel('Time [sec]');
ylabel('Signal [mV]');
xlim([0,2.5]); 
ylim([-0.4,0.8]);
%freq plot

%Squaring
squaredECG = diffECG.^2;
%time plot
subplot(2,2,4);
plot(squaredECG);
title('Squared Signal')
xlim([0 5000]);

%freq plot- to be added 

%% Average and threshold
%moving window
b_int = ones(1,round(0.06*fs));  % to get 30 sample windows (started with 150msinstread of 0.06)
integratedECG = conv(squaredECG,b_int,'same');


%time plot
figure(4)
plot(t,integratedECG);
title('Integrated ECG Signal');
xlabel('Time [sec]');
ylabel('Amplitude');
xlim([0, 2.5]);

%freq plot
%% threshold- Need to work on here down

figure(2)
% thr = 8e5;
thr = 0.025;
x_thr = integratedECG > thr; %Grabbing values above threshhold
plot(t,x,'linewidth',1);
hold on
% plot(t,100*x_thr, 'linewidth',3)
plot(t,x_thr,'linewidth',2)
hold off;
xlim([0,4])
title('Threshold shown');



%% locate rising edge of thresholded signal - not sure if this plot helps
x_thr_d = conv(x_thr,[1,-1],'same') > 0;
figure (6)
stem(x_thr_d)
title('Showing rising edge of threshhold signal')
%% plot together
figure(8)
plot(t,x);
hold on;
plot(t,x_thr_d,'linewidth',2)

% plot(t,200*x_thr_d,'linewidth',2)
hold off;
xlim([0,4])
title('Marking the QRS complex locations');
%time plot
%freq plot

%Peak Detection
% figure(7)
% findpeaks(integratedECG,"MinPeakHeight",5e-4);
% [~,locs] = findpeaks(double(peaks),'MinPeakDistance',round(0.2*fs));
%QRS Detection
%time plot
%freq plot

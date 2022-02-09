clc;
clear;
close all;

load('Subject_A_Train.mat') % load data

type eloc64.txt % check the electrode positions according to the current data set

Cz = Signal(1,:,11); % pull the Cz data(11.Channel)
Cz= double(Cz);


fs = 256; % I assigned random sampling rate because I couldn't find real SR value


time = 0:1/fs:7794/fs-1/fs; % Sample to second

plot(time,Cz)
xlabel('Seconds')
ylabel('mV')
title('Cz Channel')

%Raw data Fourier application

NFFT = 2^nextpow2(length(Cz));

y = fft(Cz, NFFT);

f = fs*(1:NFFT)/(NFFT-1); %normalize

plot(f,y);

% Filtering

[b, a] = butter(5, [0.5*2/fs 8*2/fs],'bandpass');

xfilter = filtfilt(b, a, Cz) ;

plot(xfilter(1:end), 'r'); %filtered signal

% Raw and Filtered signals plotting

plot(Cz)
hold on
plot(xfilter(1:end), 'r');

legend('Raw','Filtered')

% Filtered Fourier application

y2 = fft(xfilter,NFFT);

% Raw and Filtered Fourier application plotting together

plot(f,y);
hold on
plot(f,y2, 'r');

legend('Raw','Filtered')

% Power spectral density application

L=length(Cz);         
X=fftshift(fft(Cz,NFFT));         
Px=X.*conj(X)/(NFFT*L); %Power of each freq components       
fVals=fs*(-NFFT/2:NFFT/2-1)/NFFT;        
plot(fVals,Px);      
title('Power Spectral Density');         
xlabel('Frequency (Hz)')         
ylabel('Power');

% PSD vs FFT plotting together

plot(f,y2, 'r');
hold on
plot(fVals,Px*5000);  

legend('FFT','PSD')




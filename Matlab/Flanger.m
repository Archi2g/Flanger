%% Simulaci�n del Flanger

clc 
clear all
close all

% El filtro a implementar ser� de la forma:
% Representado en ecuaciones en diferencias
% y[n] = x[n] + ax[n-b]

% Donde b es una funci�n del tiempo. En este caso se tomar� una sinusoidal
% de frecuencia angular omega_b = 2pi*F_b rad/s

% Para empezar se tomar� el solo de una guitarra en un .wav

%[x,Fs] = wavread('single-coil_pickup');
%[x,Fs] = wavread('bass_pickup');
% [x,Fs] = wavread('hard-electric_guitar2');
[x,Fs] = wavread('hard-electric_guitar');
x = x(1:end,1);
L_x = length(x);

% x es la se�al de la guitarra muestreada a una frecuencia de sample Fs
% b var�a entre 1 us y 1000 us. Por un tema de implementaci�n se muestrear�
% el b para obtener b_n a Fs.
b_nmax = round(1E-03*Fs);
b_nmin = round(1E-06*Fs);

n = (1:L_x);
A = 1;

% b(t) = 1000us*sin(2pi*50*t). Esta se�al en teoria deber�a estar
% muestreada tambi�n por temas de implementaci�n a Fs.
% Por lo que habr�a que convertir la se�al con OMEGA*Ts = omega_b

F_b = 0.6; % Frecuencia continua. Auditivamente con F_b = 10 es lo m�ximo que puede variar b a mi criterio.
omega_b = b_nmax*pi*F_b/Fs; % Esto es cuan r�pido var�a b_n

%% Distintas formas de varir b_n
%b_n = b_nmax*(abs(cos(omega_b*n)+abs(sin(omega_b*n))));
b_n = 3*(abs(cos(omega_b*n)));
%b_n = b_nmax*(abs(sin(omega_b*n)));
%b_n = b_nmax;

b_n = b_n.';
b_n = round(b_n);
a_n = 1;

%% Se aplica el efecto de distorsi�n
for i=1:L_x
%     if (i-b_n(i)<=0)
%         y(i) = x(i);
%     else
       y(i) = x(i)+a_n*x((1 + mod(i-b_n(i), L_x)));
%     end
end
%wavwrite(y,44100,'single-coil_pickup-fl');
%wavwrite(y,44100,'bass_pickup-fl');
% wavwrite(y,44100,'hard-electric_guitar2-fl');
wavwrite(y,44100,32,'hard-electric_guitar-fl');
%% Gr�ficos de la se�al de entrada, salida y el filtro

nfft = 1024;
omegan = 0:2/nfft:2*(nfft-1)/nfft;
omegan = omegan(1:nfft/2+1);

figure('name','Espectrograma de la se�al de entrada')
spectrogram(x,1024,0,nfft);
title('Espectrograma de la entrada ventaneado con Hamming')

figure('name','Espectrograma de la se�al de salida')
spectrogram(y,1024,0,nfft);
title('Espectrograma de la salida ventaneado con Hamming')


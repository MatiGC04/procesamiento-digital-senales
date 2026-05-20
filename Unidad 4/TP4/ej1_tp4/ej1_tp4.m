f1 = 10;
f2 = 20;
T = 0.001; % periodo de muestreo
s = @(t) sin(2*pi*f1*t) + 4*sin(2*pi*f2*t); % señal a analizar

% Ejercicio 1
tini = 0; tfin = 1; fm = 1/T;

t = tini:T:tfin-T; % vector de tiempo
s_n = s(t);        % señal discreta

N = length(s_n); % número de muestras

% Calculo la TDF S[k] usando fft
S_k = fft(s_n); % usa la formula que esta en la teoria. El resultado da N muestras

% Ajuste manual del espectro: muevo la parte negativa al principio
% (equivalente a fftshift(S_k), que se podria usar para ahorrarse estas lineas)
s_negativa  = S_k(N/2+1:end); % parte negativa de la FFT (frecuencias negativas)
s_positiva  = S_k(1:N/2);     % parte positiva de la FFT (frecuencias positivas)
S_k_ajustada = [s_negativa, s_positiva]; % espectro centrado en 0

% Eje de frecuencia en Hz para el espectro ajustado
eje_f_hz = (-N/2 : N/2-1) * (fm / N); % de -fm/2 a fm/2 - Δf

figure(1)
clf

subplot(3,1,1);
plot(t, s_n);
xlabel('Tiempo (s)'); ylabel('Amplitud');
title('Señal en el tiempo s[n]');

subplot(3,1,2);
plot(0:N-1, abs(S_k));
xlabel('Índice k'); ylabel('Magnitud |S[k]|');
title('Espectro de magnitud de S[k]');

subplot(3,1,3);
plot(eje_f_hz, abs(S_k_ajustada));
xlabel('Frecuencia (Hz)'); ylabel('Magnitud |S[k]|');
title('Espectro de magnitud de S[k] ajustado');

% Verificacion de Parseval
E_tiempo = sum(s_n.^2);
E_freq   = (1/N) * sum(abs(S_k).^2);

if abs(E_tiempo - E_freq) < 1e-7
    disp('Parseval OK: energias coinciden.');
else
    disp('Parseval: las energias no coinciden.');
end

%--------------------------------------------------------------------------

# Parte 2:

% Cambio 1: agregar DC (+4) y analizar cambios en el espectro
% Sumar una constante agrega una componente en f=0 Hz (DC) de magnitud A*N,
% mientras los picos de f1 y f2 quedan iguales en magnitud.

s2_n = s_n + 4;
S2_k = fft(s2_n);

% Ajuste manual igual que antes
s2_negativa   = S2_k(N/2+1:end);
s2_positiva   = S2_k(1:N/2);
S2_k_ajustada = [s2_negativa, s2_positiva];

figure(2)
clf

subplot(3,1,1);
plot(t, s2_n);
xlabel('Tiempo (s)'); ylabel('Amplitud');
title('Señal s2[n] = s[n] + 4');

subplot(3,1,2);
plot(eje_f_hz, abs(S2_k_ajustada));
xlim([-50 50]); % limitar el eje de frecuencia para ver mejor el DC y los picos
xlabel('Frecuencia (Hz)'); ylabel('Magnitud |S2[k]|');
title('Espectro de magnitud de S2[k] ajustado');

subplot(3,1,3);
plot(eje_f_hz, abs(S_k_ajustada));
xlim([-50 50]); % limitar el eje de frecuencia para ver mejor el DC y
xlabel('Frecuencia (Hz)'); ylabel('Magnitud |S[k]|');
title('Comparación espectral: S2[k] vs S[k]');


%--------------------------------------------------------------------------


% Cambio2:
f1 = 10; f2 = 11;
s = @(t) sin(2*pi*f1*t) + 4*sin(2*pi*f2*t); % redefino s(t) con las nuevas frecuencias

s3_n = s(t); % como s(t) depende de f1 y f2, al cambiar estas frecuencias, s_c2_n cambia

S3_k = fft(s3_n);
% Ajuste manual igual que antes
s3_negativa   = S3_k(N/2+1:end);
s3_positiva   = S3_k(1:N/2);
S3_k_ajustada = [s3_negativa, s3_positiva];

figure(3)
clf
subplot(3,1,1);
plot(t, abs(s3_n));
xlabel('Tiempo (s)'); ylabel('Amplitud');
title('Señal s3[n] con f1=10Hz y f2=11Hz');

subplot(3,1,2);
plot(eje_f_hz, abs(S3_k_ajustada));
xlim([-20 20]); % limitar el eje de frecuencia para ver mejor el DC y los picos
xlabel('Frecuencia (Hz)'); ylabel('Magnitud |S3[k]|');
title('Espectro de magnitud de S3[k]');

subplot(3,1,3);
plot(eje_f_hz, abs(S_k_ajustada));
xlim([-50 50]); % limitar el eje de frecuencia para ver mejor el DC y los picos
xlabel('Frecuencia (Hz)'); ylabel('Magnitud |S[k]|');
title('Comparación espectral: S3[k] vs S[k]');
legend('S3[k]', 'S[k] original')


%--------------------------------------------------------------------------

% Cambio 3: 
f1 = 10; f2 = 10.5;

s = @(t) sin(2*pi*f1*t) + 4*sin(2*pi*f2*t); % redefino s(t) con las nuevas frecuencias

s4_n = s(t); % como s(t) depende de f1 y f2, al cambiar estas frecuencias, s_c3_n cambia
S4_k = fft(s4_n);

% Ajuste manual igual que antes
s4_negativa   = S4_k(N/2+1:end);
s4_positiva   = S4_k(1:N/2);
S4_k_ajustada = [s4_negativa, s4_positiva];

figure(4)
clf
subplot(3,1,1);
plot(t, abs(s4_n));
xlabel('Tiempo (s)'); ylabel('Amplitud');
title('Señal s4[n] con f1=10Hz y f2=10.5Hz');

subplot(3,1,2);
plot(eje_f_hz, abs(S4_k_ajustada));
xlim([-50 50]); % limitar el eje de frecuencia para ver mejor el DC y los picos
xlabel('Frecuencia (Hz)'); ylabel('Magnitud |S4[k]|');
title('Espectro de magnitud de S4[k]');

subplot(3,1,3);
plot(eje_f_hz, abs(S_k_ajustada));
xlim([-50 50]); % limitar el eje de frecuencia para ver mejor el DC y los picos
xlabel('Frecuencia (Hz)'); ylabel('Magnitud |S[k]|');
title('Comparación espectral: S4[k] vs S[k]');
legend('S4[k]', 'S[k] original')

% cambio 4:

% Modifique el intervalo de tiempo de an´alisis de la siguiente manera t =
% [0 . .. 2) seg. y analice los cambios en la TDF.

t5 = 0:T:2-T; % nuevo vector de tiempo con el doble de duración
s5_n = s(t5); % señal con el nuevo intervalo de tiempo
S5_k = fft(s5_n);
N5 = length(s5_n); % nuevo número de muestras, que es el doble del original
% Ajuste manual igual que antes
s5_negativa   = S5_k(N5/2+1:end);  % corregido: N5 en vez de N
s5_positiva   = S5_k(1:N5/2);      % corregido: N5 en vez de N
S5_k_ajustada = [s5_negativa, s5_positiva];

% como el tiempo varia el eje_f_hz tmb
eje_f_hz5 = (-N5/2 : N5/2-1) * (fm / N5); % de -fm/2 a fm/2 - Δf

% Grafico comparativo

figure(5)
clf
plot(eje_f_hz5, abs(S5_k_ajustada),'r','linewidth',2);
hold on;
plot(eje_f_hz, abs(S_k_ajustada),'b--','linewidth',1.5); % Para comparar con el original
xlabel('Frecuencia (Hz)'); 
ylabel('Magnitud |S[k]|');
title('Cambio de duración: 2 seg (Rojo) vs 1 seg (Azul punteado)');
legend('S5[k] (N=2000)', 'S[k] (N=1000)');
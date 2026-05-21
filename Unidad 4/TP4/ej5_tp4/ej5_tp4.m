% Ejercicio 5: Aliasing y relacion magnitud-amplitud

fm = 50;   % frecuencia de muestreo (Hz)
fs = 27;   % frecuencia de la señal original (Hz)
A  = 2;    % amplitud
T  = 1;    % duracion (segundos)
N  = fm*T; % numero de muestras = 50

t   = 0:1/fm:T-1/fm;    % vector de tiempo
x   = A*sin(2*pi*fs*t); % señal muestreada x(t) = 2sin(2π·27·t)
X_k = fft(x);           % TDF sin ajustar (igual que la figura del enunciado)

%--------------------------------------------------------------------------
% Item 1: calculo Δf y determino la frecuencia observada
delta_f = fm/N; % resolucion frecuencial = 1 Hz, cada k vale k*delta_f Hz

fprintf('=== Item 1 ===\n');
fprintf('N=%d muestras | Δf = fm/N = %d/%d = %.1f Hz\n', N, fm, N, delta_f);
fprintf('Nyquist: fm/2 = %.0f Hz < fs = %d Hz => aliasing\n', fm/2, fs);
fprintf('Frecuencia observada: fm - fs = %d - %d = %d Hz\n', fm, fs, fm-fs);

% Grafico identico al del enunciado (sin ajustar, eje en muestras k)
figure(1); clf;
stem(0:N-1, abs(X_k));
xlabel('Muestras (k)'); ylabel('|X[k]|');
title(sprintf('FFT de x(t)=%.0fsin(2π·%dt), fm=%dHz', A, fs, fm));
xlim([0 N]);

%--------------------------------------------------------------------------
% Item 2: verifico la formula de aliasing para fs=27 y fs=105

fprintf('\n=== Item 2 ===\n');
fprintf('Formula: f_alias = fm - fs  (cuando fs > fm/2)\n');

% Funcion que calcula la frecuencia de alias para cualquier fs y fm
f_alias = @(fs, fm) abs(mod(fs, fm) - fm*(mod(fs,fm) > fm/2));

fprintf('fs=27  Hz: f_alias = %d Hz\n', f_alias(27,  fm));
fprintf('fs=105 Hz: f_alias = %d Hz\n', f_alias(105, fm));

% Verifico fs=105 con codigo: genero la señal y busco el pico
x105   = sin(2*pi*105*t);
X_k105 = fft(x105);
[~, k_max] = max(abs(X_k105(1:N/2+1))); % busco pico en parte positiva
fprintf('Pico observado para fs=105Hz: k=%d => f=%.0f Hz\n', k_max-1, (k_max-1)*delta_f);

%--------------------------------------------------------------------------
% Item 3: relacion entre magnitud observada y amplitud original

fprintf('\n=== Item 3 ===\n');
fprintf('Teoria: |X[k]| = A*N/2 = %.0f*%d/2 = %.0f\n', A, N, A*N/2);

% Busco el pico real en el espectro (tomo la parte positiva)
[mag_obs, ~] = max(abs(X_k(1:N/2)));
fprintf('Magnitud observada en el grafico: %.1f\n', mag_obs);
fprintf('Relacion inversa: A = 2*|X[k]|/N = 2*%.1f/%d = %.2f\n', mag_obs, N, 2*mag_obs/N);
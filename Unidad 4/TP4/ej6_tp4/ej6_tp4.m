raw = load('necg.txt');
x = raw(:); % Aseguramos que sea un vector columna

fm  = 360;
N   = length(x);
t   = (0:N-1)'/fm;
delta_f = fm/N;

fprintf('N=%d muestras | duracion=%.2fs | Δf=%.4f Hz\n', N, N/fm, delta_f);

X_k = fft(x);
H   = ones(N, 1);

% paso de frecuencias a indices de la FFT
k_40  = round(40  / delta_f); 
k_180 = round(180 / delta_f);
fprintf('k_40=%d | k_180=%d\n', k_40, k_180);

% Pongo en 0 en las frecuencias donde esta el ruido
H(k_40+1   : k_180+1)   = 0;
H(N-k_180+1 : N-k_40+1) = 0;
fprintf('Muestras en cero: %d de %d (%.1f%%)\n', sum(H==0), N, 100*sum(H==0)/N);

X_filtrada = X_k .* H;
y = real(ifft(X_filtrada));

% Para ver bien la diferencia uso escala logaritmica en el espectro
eje_f = (-N/2:N/2-1)' * delta_f;

figure(1); clf;

subplot(3,1,1);
plot(t, x); xlabel('Tiempo (s)'); ylabel('Amplitud');
title('ECG original x[n]');

subplot(3,1,2);
plot(t, y); xlabel('Tiempo (s)'); ylabel('Amplitud');
title('ECG filtrado y[n]');

subplot(3,1,3);
% Uso dB para ver mejor la diferencia entre original y filtrado
semilogy(eje_f, abs(fftshift(X_k)),       'b', 'linewidth',1); hold on;
semilogy(eje_f, abs(fftshift(X_filtrada)),'r', 'linewidth',1); hold off;
xlim([-200 200]); ylim([1 1e6]);
xlabel('Frecuencia (Hz)'); ylabel('Magnitud (log)');
title('Espectro en escala log: original (azul) vs filtrado (rojo)');
legend('X[k] original','X[k] filtrado');

% Muestro la señal eliminada para confirmar que algo se removio
figure(2); clf;
subplot(3,1,1); plot(t, x);       title('Original x[n]');       ylabel('Amplitud');
subplot(3,1,2); plot(t, y);       title('Filtrado y[n]');        ylabel('Amplitud');
subplot(3,1,3); plot(t, x - y);   title('Ruido eliminado x-y');  ylabel('Amplitud');
xlabel('Tiempo (s)');
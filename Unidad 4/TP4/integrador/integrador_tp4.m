%==========================================================================
% PARTE I
%==========================================================================

fm1 = 1000;  % frecuencia de muestreo original
f1=50; f2=120; f3=280;  % frecuencias de las componentes
A1=5;  A2=3;  A3=2;     % amplitudes

T  = 1;                  % duracion en segundos
t1 = 0:1/fm1:T-1/fm1;   % vector de tiempo
N1 = length(t1);         % N = fm*T = 1000 muestras

% Genero la señal como combinacion lineal de tres senoidales
s_n = A1*sin(2*pi*f1*t1) + A2*cos(2*pi*f2*t1) + A3*sin(2*pi*f3*t1);

% Calculo TDF y eje de frecuencia
S_k  = fft(s_n);
df1  = fm1/N1;           % resolucion frecuencial = 1 Hz
eje1 = (-N1/2:N1/2-1)*df1;

fprintf('=== PARTE I ===\n');
fprintf('N=%d | Δf=%.1f Hz | Nyquist=%.0f Hz\n', N1, df1, fm1/2);

figure(1); clf;

subplot(2,1,1);
plot(t1, s_n);
xlabel('Tiempo (s)'); ylabel('Amplitud');
title('Señal s[n] = 5sin(2π50t) + 3cos(2π120t) + 2sin(2π280t)');

subplot(2,1,2);
plot(eje1, abs(fftshift(S_k)));
xlabel('Frecuencia (Hz)'); ylabel('Magnitud |S[k]|');
title(sprintf('Espectro de magnitud | Δf=%.1f Hz | fm=1000 Hz', df1));
% Marco las frecuencias teoricas con lineas verticales
xlim([-500 500]);
hold on;
line([f1 f1], ylim(), 'color', 'r', 'linestyle', '--', 'linewidth', 1.5);
line([-f1 -f1], ylim(), 'color', 'r', 'linestyle', '--', 'linewidth', 1.5);
line([f2 f2], ylim(), 'color', 'g', 'linestyle', '--', 'linewidth', 1.5);
line([-f2 -f2], ylim(), 'color', 'g', 'linestyle', '--', 'linewidth', 1.5);
line([f3 f3], ylim(), 'color', 'b', 'linestyle', '--', 'linewidth', 1.5);
line([-f3 -f3], ylim(), 'color', 'b', 'linestyle', '--', 'linewidth', 1.5);
hold off;

%--------------------------------------------------------------------------
% Parte I - Reduccion de fm a 200 Hz (aliasing)
%--------------------------------------------------------------------------

fm2 = 200;               % nueva frecuencia de muestreo
t2  = 0:1/fm2:T-1/fm2;  % mismo intervalo, menos muestras
N2  = length(t2);        % N = fm2*T = 200 muestras

s_n2 = A1*sin(2*pi*f1*t2) + A2*cos(2*pi*f2*t2) + A3*sin(2*pi*f3*t2);

S_k2 = fft(s_n2);
df2  = fm2/N2;           % Δf = 200/200 = 1 Hz
eje2 = (-N2/2:N2/2-1)*df2;

% Calculo frecuencias de alias para cada componente
% f_alias = fm - f si f > fm/2 (Nyquist=100 Hz)
f_alias = @(f,fm) abs(mod(f,fm) - fm*(mod(f,fm)>fm/2));
fprintf('\nAliasing con fm=200 Hz (Nyquist=100 Hz):\n');
fprintf('f1=50 Hz  → %.0f Hz (OK, sin aliasing)\n',   f_alias(f1,fm2));
fprintf('f2=120 Hz → %.0f Hz (aliasing: 200-120=80)\n', f_alias(f2,fm2));
fprintf('f3=280 Hz → %.0f Hz (aliasing: 280 mod 200=80)\n', f_alias(f3,fm2));

figure(2); clf;

subplot(2,1,1);
plot(eje1, abs(fftshift(S_k)));
xlabel('Frecuencia (Hz)'); ylabel('Magnitud |S[k]|');
title('Espectro original fm=1000 Hz');
xlim([-200 200]);

subplot(2,1,2);
plot(eje2, abs(fftshift(S_k2)));
xlabel('Frecuencia (Hz)'); ylabel('Magnitud |S[k]|');
title('Espectro con fm=200 Hz (aliasing en f2 y f3)');
xlim([-150 150]);

%==========================================================================
% PARTE II
%==========================================================================

%--------------------------------------------------------------------------
% Parte II - Reduccion de duracion a 40ms
%--------------------------------------------------------------------------

T3   = 0.040;              % 40 ms
fm3  = 1000;               % misma fm
t3   = 0:1/fm3:T3-1/fm3;  % vector de tiempo corto
N3   = length(t3);         % N = 1000*0.04 = 40 muestras
df3  = fm3/N3;             % Δf = 1000/40 = 25 Hz

s_n3 = A1*sin(2*pi*f1*t3) + A2*cos(2*pi*f2*t3) + A3*sin(2*pi*f3*t3);
S_k3 = fft(s_n3);
eje3 = (-N3/2:N3/2-1)*df3;

fprintf('\n=== PARTE II ===\n');
fprintf('T=40ms | N=%d | Δf=%.1f Hz\n', N3, df3);
fprintf('Separacion 50-120 Hz = 70 Hz >> Δf=25 Hz => distinguibles\n');

%--------------------------------------------------------------------------
% Parte II - Zero padding hasta 5N
%--------------------------------------------------------------------------

N_pad  = 5*N3;              % 5*40 = 200 muestras
s_pad  = [s_n3, zeros(1, N_pad-N3)];  % relleno con ceros
S_pad  = fft(s_pad);
df_pad = fm3/N_pad;         % Δf = 1000/200 = 5 Hz (solo visual)
eje_pad = (-N_pad/2:N_pad/2-1)*df_pad;

fprintf('Zero padding: N_pad=%d | Δf_pad=%.1f Hz\n', N_pad, df_pad);
fprintf('El zero padding NO mejora resolucion real, solo interpola visualmente\n');

figure(3); clf;

subplot(2,1,1);
plot(t3, s_n3);
xlabel('Tiempo (s)'); ylabel('Amplitud');
title(sprintf('Señal recortada a 40ms | N=%d muestras', N3));

subplot(2,1,2);
plot(eje_pad, abs(fftshift(S_pad)), 'r', 'linewidth', 1.5); hold on;
plot(eje3,    abs(fftshift(S_k3)),  'b', 'linewidth', 1);   hold off;
xlabel('Frecuencia (Hz)'); ylabel('Magnitud |S[k]|');
title(sprintf('Espectro: sin padding (azul, Δf=%.0fHz) vs 5N padding (rojo, Δf=%.0fHz)', df3, df_pad));
legend('5N zero padding','Sin padding');
xlim([-400 400]);


%==========================================================================
% PARTE III
%==========================================================================

fm1 = 1000; T = 1;
t1  = 0:1/fm1:T-1/fm1;
N1  = length(t1);
df1 = fm1/N1;  % Δf = 1 Hz
eje1 = (-N1/2:N1/2-1)*df1;

% Genero cada señal por separado
x1_n = 5*sin(2*pi*50*t1);
x2_n = 3*cos(2*pi*120*t1);
x3_n = 2*sin(2*pi*280*t1);
s_n  = x1_n + x2_n + x3_n;

% TDF de cada señal individual y de la combinacion
X1_k = fft(x1_n);
X2_k = fft(x2_n);
X3_k = fft(x3_n);
S_k  = fft(s_n);

% Verificacion de linealidad: S[k] debe ser igual a X1[k]+X2[k]+X3[k]
S_suma = X1_k + X2_k + X3_k;
error_linealidad = max(abs(S_k - S_suma));
fprintf('=== PARTE III ===\n');
fprintf('Error linealidad |S[k] - (X1+X2+X3)[k]| = %.2e\n', error_linealidad);

figure(4); clf;

subplot(4,1,1);
plot(eje1, abs(fftshift(X1_k)));
ylabel('|X1[k]|'); title('TDF de x1[n] = 5sin(2π50t)');
xlim([-400 400]);

subplot(4,1,2);
plot(eje1, abs(fftshift(X2_k)));
ylabel('|X2[k]|'); title('TDF de x2[n] = 3cos(2π120t)');
xlim([-400 400]);

subplot(4,1,3);
plot(eje1, abs(fftshift(X3_k)));
ylabel('|X3[k]|'); title('TDF de x3[n] = 2sin(2π280t)');
xlim([-400 400]);

subplot(4,1,4);
plot(eje1, abs(fftshift(S_k)),    'b', 'linewidth', 2); hold on;
plot(eje1, abs(fftshift(S_suma)), 'r--', 'linewidth', 1); hold off;
ylabel('|S[k]|');
title('S[k] (azul) vs X1[k]+X2[k]+X3[k] (rojo) — deben ser identicas');
xlabel('Frecuencia (Hz)'); xlim([-400 400]);
legend('S[k]','X1+X2+X3');

% Verificacion de Parseval
E_tiempo = sum(s_n.^2);
E_freq   = (1/N1) * sum(abs(S_k).^2);
fprintf('E_tiempo = %.4f\n', E_tiempo);
fprintf('E_freq   = %.4f\n', E_freq);
fprintf('Error Parseval = %.2e\n', abs(E_tiempo - E_freq));

% CONCLUSION PARTE III:
% La TDF es una transformacion LINEAL: la TDF de una suma de señales
% es igual a la suma de las TDFs individuales. Se verifica graficamente
% porque las dos curvas del subplot 4 son identicas (error del orden 1e-10,
% solo error numerico de punto flotante).
% Parseval confirma que la energia total se conserva al transformar:
% sumar los cuadrados en tiempo da lo mismo que sumar los cuadrados
% en frecuencia normalizados por N. La TDF no crea ni destruye energia,
% solo cambia la representacion.

%==========================================================================
% PARTE IV
%==========================================================================

k_corte = round(200 / df1);  % indice correspondiente a 200 Hz

% Construyo mascara H[k]: 1 donde conservo, 0 donde elimino
H = zeros(1, N1);
H(1 : k_corte+1)     = 1;  % frecuencias positivas: 0 a 200 Hz
H(N1-k_corte+1 : N1) = 1;  % frecuencias negativas: -200 a -df Hz

fprintf('\n=== PARTE IV ===\n');
fprintf('k_corte=%d (%.0f Hz) | unos en H: %d de %d\n', ...
        k_corte, k_corte*df1, sum(H), N1);

% Aplico el filtro en frecuencia
X_filtrada = S_k .* H;

% Verifico que 280 Hz fue eliminado
k_280 = round(280/df1);
fprintf('Magnitud en 280 Hz antes: %.2f | despues: %.2f\n', ...
        abs(S_k(k_280+1)), abs(X_filtrada(k_280+1)));

% Obtengo señal filtrada en tiempo via IFFT
y_n = real(ifft(X_filtrada));

figure(5); clf;

% Respuesta en frecuencia del filtro H[k]
subplot(3,1,1);
plot(eje1, fftshift(H));
xlabel('Frecuencia (Hz)'); ylabel('H[k]');
title('Respuesta en frecuencia del filtro H[k] pasa-bajos (corte 200 Hz)');
xlim([-500 500]);

% Espectro antes y despues del filtro
subplot(3,1,2);
plot(eje1, abs(fftshift(S_k)),        'b', 'linewidth', 1); hold on;
plot(eje1, abs(fftshift(X_filtrada)), 'r', 'linewidth', 1);
yl = ylim;
plot([ 280  280], yl, 'k--');
plot([-280 -280], yl, 'k--');
hold off;
xlabel('Frecuencia (Hz)'); ylabel('Magnitud');
title('Espectro: original (azul) vs filtrado (rojo) — 280 Hz eliminado');
legend('S[k]','X[k] filtrado','280 Hz','');
xlim([-400 400]);

% Comparacion en tiempo 0 a 0.1 segundos
seg = t1 < 0.1;
subplot(3,1,3);
plot(t1(seg), s_n(seg), 'b', 'linewidth', 1); hold on;
plot(t1(seg), y_n(seg), 'r', 'linewidth', 1.5); hold off;
xlabel('Tiempo (s)'); ylabel('Amplitud');
title('Segmento 0-0.1s: original x[n] (azul) vs filtrada y[n] (rojo)');
legend('x[n] original','y[n] filtrada');

% CONCLUSION PARTE IV:
% El filtro pasa-bajos ideal se implementa como una mascara H[k] de unos
% y ceros en el dominio frecuencial. Al multiplicar X[k]*H[k] se eliminan
% todas las componentes por encima de 200 Hz, por lo que la componente de
% 280 Hz cae a magnitud ~0 (verificado con el fprintf).
% En el dominio del tiempo y[n] es mas suave que x[n]: desaparecen las
% oscilaciones rapidas de 280 Hz y solo quedan las de 50 y 120 Hz.
% La forma de onda cambia porque 280 Hz contribuia a los picos y valles
% rapidos — sin ella la señal tiene menos detalle fino.
% Esto ilustra el compromiso del filtrado: eliminar frecuencias modifica
% irreversiblemente la forma de onda en el tiempo.
#Parte 1
pkg load signal 

H_z = @(z) (1+0.5*z^(-1))./(1-0.8*z^(-1)+0.12*z^(-2)); % función de transferencia del filtro

% Determino polos.
% polos: valores que hacen 0 el denominador.

coef_denominador = [1, -0.8, 0.12];
polos = roots(coef_denominador);

% Determino ceros.
% ceros: valores que hacen 0 el numerador.
coef_numerador = [1, 0.5];
ceros = roots(coef_numerador);

% grafico los polos y ceros de H en el plano Z
figure(1)
zplane(ceros, polos);
title('Diagrama de Polos y Ceros');
legend('circulo unitario', 'Ceros', 'Polos');

fprintf('En la grafica se ve que el filtro es estable, ya que los polos al estar dentro del circulo es condicion para que se denomine estable ');


# Parte 2

fm = 1000; % frecuencia de muestreo Hz
N = 1024;  % numero de puntos para la DFT

% Coeficientes del filtro (de la ecuacion en diferencias)
% y[n] - 0.8*y[n-1] + 0.12*y[n-2] = x[n] + 0.5*x[n-1]
% H(z) = (1 + 0.5*z^-1) / (1 - 0.8*z^-1 + 0.12*z^-2)
b = [1, 0.5];         % coeficientes del numerador
a = [1, -0.8, 0.12];  % coeficientes del denominador

% Respuesta en frecuencia usando freqz
% freqz devuelve H y el vector de frecuencias normalizadas w (0 a pi)
[H, w] = freqz(b, a, N);

% Frecuencia normalizada (0 a 1, donde 1 = fm/2)
f_norm = w / (2*pi); % de 0 a 0.5

% Frecuencia en Hz
f_hz = f_norm * fm;  % de 0 a fm/2 = 500 Hz

% --- Grafico magnitud vs frecuencia normalizada ---
figure(2)
subplot(2,1,1)
plot(f_norm, abs(H))
xlabel('Frecuencia normalizada (ciclos/muestra)')
ylabel('|H(f)|')
title('Magnitud de la respuesta en frecuencia (frec. normalizada)')
grid on

subplot(2,1,2)
plot(f_norm, angle(H) * 180/pi)
xlabel('Frecuencia normalizada (ciclos/muestra)')
ylabel('Fase (grados)')
title('Fase de la respuesta en frecuencia (frec. normalizada)')
grid on

% --- Grafico magnitud vs frecuencia en Hz ---
figure(3)
subplot(2,1,1)
plot(f_hz, abs(H))
xlabel('Frecuencia (Hz)')
ylabel('|H(f)|')
title('Magnitud de la respuesta en frecuencia (Hz, fm=1000Hz)')
grid on

subplot(2,1,2)
plot(f_hz, angle(H) * 180/pi)
xlabel('Frecuencia (Hz)')
ylabel('Fase (grados)')
title('Fase de la respuesta en frecuencia (Hz)')
grid on

% --- Identificacion del tipo de filtro ---
% La magnitud maxima esta en f=0 y decrece hacia fm/2,
% por lo tanto es un filtro PASA BAJOS.
mag_0   = abs(H(1));     % magnitud en f=0
mag_max = max(abs(H));   % magnitud maxima
[~, idx_max] = max(abs(H));
fprintf('\nMagnitud en f=0: %.4f\n', mag_0)
fprintf('Magnitud maxima: %.4f en f=%.1f Hz\n', mag_max, f_hz(idx_max))
fprintf('Tipo de filtro: PASA BAJOS (maxima magnitud en bajas frecuencias)\n')

% --- Respuesta al impulso h[n] ---
% Usamos filter para calcular la salida ante una delta de Dirac discreta
n_impulso = 64; % longitud de la respuesta al impulso a calcular
delta = [1, zeros(1, n_impulso-1)]; % delta discreta
h = filter(b, a, delta);

figure(4)
stem(0:n_impulso-1, h)
xlabel('n [muestras]')
ylabel('h[n]')
title('Respuesta al impulso h[n]')
grid on

% Verificacion de estabilidad por la respuesta al impulso:
% si h[n] tiende a 0, el filtro es estable (BIBO).
fprintf('\nVerificacion de estabilidad por h[n]:\n')
fprintf('  h[0]  = %.4f\n', h(1))
fprintf('  h[10] = %.4f\n', h(11))
fprintf('  h[30] = %.4f\n', h(31))
fprintf('  h[63] = %.6f\n', h(end))
fprintf('  h[n] tiende a 0 => el sistema es ESTABLE (coincide con polos dentro del circulo unitario)\n')


% Parte III

H_a = @(s) 1./(s+1);

T = 0.1;
f = 1/T; % frecuencia de muestreo

% aplico trasnformacion de Euler para obtener la funcion de 
% trasnferencia H(z) del sistema discreto equivalente.

H_z = @(z) H_a((1- z.^(-1))/T);

% ecuacion en diferencias correspondiente.

a_d = [1.1,-1];
b_d = [0.1];

% calculo la respuesta en frecuencia del sistema discreto


[H_disc, w] = freqz(b_d, a_d, N);

% Frecuencia analogica equivalente (para comparar con H_a)
% La relacion es: w = Omega * T  →  Omega = w/T (rad/s)
Omega = w / T;   % frecuencia en rad/s
f_hz  = Omega / (2*pi);  % frecuencia en Hz

% -----------------------------------------------------------
% Respuesta en frecuencia del sistema CONTINUO original
% -----------------------------------------------------------
% H_a(jΩ) = 1/(jΩ + 1) → evaluamos directamente en los mismos Omega
H_cont = 1 ./ (1j*Omega + 1);


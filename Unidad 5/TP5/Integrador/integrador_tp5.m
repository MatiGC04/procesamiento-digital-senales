pkg load signal  % para usar zplane

% ============================================================
% PARTE I: Funcion de transferencia, polos, ceros y estabilidad
% ============================================================

% ecuacion en diferencias:
% y[n] - 0.8*y[n-1] + 0.12*y[n-2] = x[n] + 0.5*x[n-1]
%
% aplicando transformada Z y despejando H(z) = Y(z)/X(z):
% H(z) = (1 + 0.5*z^-1) / (1 - 0.8*z^-1 + 0.12*z^-2)
%
% multiplico numerador y denominador por z^2 para tener
% potencias positivas (forma estandar para zplane y roots):
% H(z) = z*(z + 0.5) / (z^2 - 0.8*z + 0.12)

num = [1, 0.5, 0];     % coeficientes del numerador: z^2 + 0.5z + 0
den = [1, -0.8, 0.12]; % coeficientes del denominador: z^2 - 0.8z + 0.12

% polos y ceros
ceros = roots(num)
polos = roots(den)

% estabilidad: el sistema es estable si todos los polos tienen modulo < 1
% (estan dentro del circulo unitario en el plano Z)
disp('Modulo de los polos:')
disp(abs(polos))

if all(abs(polos) < 1)
    disp('Sistema ESTABLE: todos los polos estan dentro del circulo unitario')
else
    disp('Sistema INESTABLE: hay polos fuera del circulo unitario')
end

figure(1)
zplane(num, den)
title('Parte I - Polos y ceros en el plano Z')


% ============================================================
% PARTE II: Respuesta en frecuencia
% ============================================================

fm = 1000; % Hz
Nfft = 2048;

% evaluo H(z) sobre el circulo unitario: z = e^(j*2*pi*f/fm)
% freqz hace esto internamente
[H, f] = freqz(num, den, Nfft, fm);

figure(2)
subplot(2,1,1)
plot(f, abs(H))
xlabel('Frecuencia (Hz)'); ylabel('Magnitud');
title('Parte II - Magnitud de H(f)')
grid on

subplot(2,1,2)
plot(f, angle(H) * 180/pi)
xlabel('Frecuencia (Hz)'); ylabel('Fase (grados)');
title('Parte II - Fase de H(f)')
grid on

% tambien grafico en frecuencia normalizada (0 a pi rad/muestra)
% para ver el comportamiento independiente de fm
[H_norm, w] = freqz(num, den, Nfft);

figure(3)
subplot(2,1,1)
plot(w/pi, abs(H_norm))  % w/pi normaliza entre 0 y 1
xlabel('Frecuencia normalizada (x pi rad/muestra)'); ylabel('Magnitud');
title('Parte II - Magnitud (frecuencia normalizada)')
grid on

subplot(2,1,2)
plot(w/pi, angle(H_norm) * 180/pi)
xlabel('Frecuencia normalizada (x pi rad/muestra)'); ylabel('Fase (grados)');
title('Parte II - Fase (frecuencia normalizada)')
grid on


% ============================================================
% PARTE II: Respuesta al impulso
% ============================================================

N = 50; % cantidad de muestras
n = 0:N-1;

impulso = [1, zeros(1, N-1)];
h = filter(num, den, impulso);

figure(4)
stem(n, h)
xlabel('n'); ylabel('h[n]');
title('Parte II - Respuesta al impulso h[n]')
grid on

if abs(h(end)) < 1e-6
    disp('Respuesta al impulso converge a cero: confirma estabilidad')
else
    disp('Respuesta al impulso no converge: posible inestabilidad')
end


% ============================================================
% PARTE III: Transformacion de Euler
% ============================================================

% sistema continuo: Ha(s) = 1/(s+1)
Ha = @(s) 1 ./ (s + 1);

T = 0.1; % periodo de muestreo en segundos
fm_euler = 1/T; % = 10 Hz

num_euler = [T, 0];        % T*z   -> coeficientes: [T, 0]
den_euler = [(1+T), -1];   % (1+T)*z - 1 -> coeficientes: [1+T, -1]

f_cont = 0:0.1:fm_euler/2;
w_cont = 2*pi*f_cont;

H_cont  = Ha(1j*w_cont);
H_euler = freqz(num_euler, den_euler, 2*pi*f_cont/fm_euler);

figure(5)
plot(f_cont, abs(H_cont), 'b-', 'linewidth', 2); hold on
plot(f_cont, abs(H_euler), 'r--', 'linewidth', 2); hold off
xlabel('Frecuencia (Hz)'); ylabel('Magnitud');
title('Parte III - Euler vs sistema continuo')
legend('Continuo Ha(s)', 'Euler H(z)')
grid on

fprintf('Ecuacion en diferencias (Euler):\n')
fprintf('%.1f*y[n] - y[n-1] = %.1f*x[n]\n', (1+T), T)
fprintf('=> y[n] = %.4f*y[n-1] + %.4f*x[n]\n', 1/(1+T), T/(1+T))


% ============================================================
% PARTE IV: Transformacion bilineal
% ============================================================


num_bil = [T,     T    ];   % T*(1 + z^-1)
den_bil = [(2+T), (T-2)];   % (2+T) + (T-2)*z^-1 = 2.1 - 1.9*z^-1

H_bilineal = freqz(num_bil, den_bil, 2*pi*f_cont/fm_euler);

figure(6)
plot(f_cont, abs(H_cont),    'b-',  'linewidth', 2); hold on
plot(f_cont, abs(H_euler),   'r--', 'linewidth', 2);
plot(f_cont, abs(H_bilineal),'g-',  'linewidth', 2); hold off
xlabel('Frecuencia (Hz)'); ylabel('Magnitud');
title('Parte IV - Bilineal vs Euler vs continuo')
legend('Continuo Ha(s)', 'Euler H(z)', 'Bilineal H(z)')
grid on

fprintf('Ecuacion en diferencias (Bilineal):\n')
fprintf('%.1f*y[n] - %.1f*y[n-1] = %.1f*x[n] + %.1f*x[n-1]\n', ...
        (2+T), (2-T), T, T)
fprintf('=> y[n] = %.4f*y[n-1] + %.4f*(x[n] + x[n-1])\n', ...
        (2-T)/(2+T), T/(2+T))

        matlab% CONCLUSIONES PARTE IV - Transformacion Bilineal vs Euler
%
% Ambos metodos producen sistemas estables para Ha(s) = 1/(s+1) con T=0.1,
% ya que el polo continuo en s=-1 se mapea dentro del circulo unitario:
%   - Euler:    z = 1 + s*T = 0.9
%   - Bilineal: z = (1+s*T/2)/(1-s*T/2) ≈ 0.905
%
% Sin embargo, la Bilineal aproxima mejor la respuesta en frecuencia
% del sistema continuo en todo el rango hasta Nyquist, porque mapea
% biyectivamente el eje jw al circulo unitario (warping de frecuencia).
%
% Euler en cambio no garantiza esta correspondencia en alta frecuencia:
% su precision se degrada cerca de Nyquist y puede generar inestabilidad
% si T es grande o el polo continuo tiene parte real muy negativa.
%
% Para T=0.1 la diferencia entre ambos metodos es pequeña pero visible
% cerca de f=5Hz (Nyquist), donde la Bilineal decae mas fielmente
% al comportamiento del sistema continuo original.
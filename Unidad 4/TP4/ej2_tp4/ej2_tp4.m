addpath('../../../Funciones');
% Ejercicio 2
tini = 0; tfin = 1; fm = 100; fase = 0; amplitud = 1;

% Generacion de las señales
% a) senoidal 2 Hz
[t_a, x_a] = generasenoidal(tini, tfin, fm, 2, fase, amplitud);

% b) onda cuadrada 2 Hz
[t_b, x_b] = generaondacuadrada(tini, tfin, fm, 2, fase, amplitud);

% c) senoidal 4 Hz
[t_c, x_c] = generasenoidal(tini, tfin, fm, 4, fase, amplitud);

N = length(x_a);

%--------------------------------------------------------------------------
% Item 1: Ortogonalidad en dominio del tiempo
% Producto interno = sum(x .* y). Si es ~0, son ortogonales.

pi_ab = sum(x_a .* x_b);
pi_ac = sum(x_a .* x_c);
pi_bc = sum(x_b .* x_c);

fprintf('--- Ortogonalidad en tiempo ---\n');
fprintf('<a, b> = %.6f', pi_ab);
if abs(pi_ab) < 1e-6, fprintf(' => ortogonales\n'); else fprintf(' => NO ortogonales\n'); end

fprintf('<a, c> = %.6f', pi_ac);
if abs(pi_ac) < 1e-6, fprintf(' => ortogonales\n'); else fprintf(' => NO ortogonales\n'); end

fprintf('<b, c> = %.6f', pi_bc);
if abs(pi_bc) < 1e-6, fprintf(' => ortogonales\n'); else fprintf(' => NO ortogonales\n'); end

%--------------------------------------------------------------------------
% Item 2: Ortogonalidad en dominio de la frecuencia
% Producto interno en frecuencia = sum(X .* conj(Y))

X_a = fft(x_a);
X_b = fft(x_b);
X_c = fft(x_c);

pi_ab_f = sum(X_a .* conj(X_b));
pi_ac_f = sum(X_a .* conj(X_c));
pi_bc_f = sum(X_b .* conj(X_c));

fprintf('\n--- Ortogonalidad en frecuencia ---\n');
fprintf('<A, B> = %.6f', abs(pi_ab_f));
if abs(pi_ab_f) < 1e-6, fprintf(' => ortogonales\n'); else fprintf(' => NO ortogonales\n'); end

fprintf('<A, C> = %.6f', abs(pi_ac_f));
if abs(pi_ac_f) < 1e-6, fprintf(' => ortogonales\n'); else fprintf(' => NO ortogonales\n'); end

fprintf('<B, C> = %.6f', abs(pi_bc_f));
if abs(pi_bc_f) < 1e-6, fprintf(' => ortogonales\n'); else fprintf(' => NO ortogonales\n'); end

%--------------------------------------------------------------------------
% Item 3: Redefino c) como senoidal de 3.5 Hz y verifico ortogonalidad con a)

[t_c2, x_c2] = generasenoidal(tini, tfin, fm, 3.5, fase, amplitud);
X_c2 = fft(x_c2);

pi_a_c2_t = sum(x_a .* x_c2);
pi_a_c2_f = sum(X_a .* conj(X_c2));

fprintf('\n--- Ortogonalidad a) vs c_nueva) 3.5 Hz ---\n');
fprintf('<a, c2> tiempo    = %.6f', pi_a_c2_t);
if abs(pi_a_c2_t) < 1e-6, fprintf(' => ortogonales\n'); else fprintf(' => NO ortogonales\n'); end

fprintf('<A, C2> frecuencia = %.6f', abs(pi_a_c2_f));
if abs(pi_a_c2_f) < 1e-6, fprintf(' => ortogonales\n'); else fprintf(' => NO ortogonales\n'); end


%--------------------------------------------------------------------------

% Conclusiones:
% a-b (senoidal 2Hz vs cuadrada 2Hz): NO ortogonales. La onda cuadrada contiene
%     como armónico fundamental la senoidal de 2Hz, por lo que hay componente
%     en común y el producto interno no es cero. Esto se verifica en ambos dominios.
%
% a-c (senoidal 2Hz vs senoidal 4Hz): ortogonales. Dos senoidales de distinta
%     frecuencia son ortogonales cuando se evalúan sobre un número entero de
%     períodos: 1 segundo contiene exactamente 2 ciclos de 2Hz y 4 de 4Hz.
%
% b-c (cuadrada 2Hz vs senoidal 4Hz): ortogonales. Los armónicos de la cuadrada
%     están en 2, 6, 10... Hz (impares de la fundamental). Como 4Hz no es
%     ninguno de ellos, no hay componente en común.
%
% --- Conclusión Item 3 ---
% a-c2 (senoidal 2Hz vs senoidal 3.5Hz): ortogonales en ambos dominios.
%     Aunque 3.5Hz no es múltiplo entero de la resolución frecuencial (Δf=1Hz),
%     el producto interno da cero porque la integral del producto de dos senoidales
%     de distinta frecuencia sobre el intervalo de análisis se cancela.
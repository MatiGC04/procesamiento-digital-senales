pkg load signal 
addpath('../../../Funciones');
H = @(z) (1 - 2*z.^(-1) + 2*z.^(-2) - z.^(-3)) ./ ((1 - z.^(-1)) .* (1 - 0.5*z.^(-1)) .* (1 - 0.2*z.^(-1)));

coef_numerador = [1,-2, 2, -1];

ceros = roots(coef_numerador);

polos = [1, 0.5, 0.2]; % mirando el enunciado, al estar factorizado es facil

ceros'

figure(1)
clf
zplane(ceros, polos);
title('Diagrama de Polos y Ceros');
legend('circulo unitario', 'Ceros', 'Polos');


# parte 2
pkg load signal

% Coeficientes
a = [1, -1.7, 0.85, -0.1];   % lado de y[n]
b = [1, -2, 2, -1];           % lado de x[n]

% Señal de entrada: impulso de N muestras
N = 20;
s = zeros(1, N);
s(1) = 1;   % delta[n]: vale 1 solo en n=0 (índice 1 en Octave)

% Calcular respuesta al impulso
h = respuesta_al_impulso(a, b, s);

% Graficar
stem(0:N-1, h)
xlabel('n')
ylabel('h[n]')
title('Respuesta al impulso')
grid on

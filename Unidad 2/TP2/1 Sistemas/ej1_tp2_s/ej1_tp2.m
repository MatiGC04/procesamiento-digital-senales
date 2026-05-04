%EJERCICIO 1
clear; clc; close all;

N = 10;
n1 = 0:1:N-1;
fs = 5;
fm = 15;
Tm = 1/fm;
w = 2*pi*fs;
A = 1;

g = A*sin(w*n1*Tm); % Vector fila
x1 = ones(1, N);    % Vector fila

y1 = g .* x1;       % Multiplicación elemento a elemento de vectores del mismo tamaño

figure(1);
stem(n1, y1, 'filled', 'LineWidth', 1.5);
xlabel('n'); ylabel('y_1[n]');
grid on;


%EJERCICIO 2
n0 = 3;
printf('n0 = %d\n', n0);

% Definimos un nuevo vector n2. Lo hacemos un poco más largo para ver el efecto.
n2 = 0:1:15; 
% Creamos una señal de entrada x2 para este sistema (ej: un escalón de tamaño igual a n2)
x2 = ones(1, length(n2)); 
y2 = zeros(1, length(n2));

for i = 1:length(n2)
    % k recorre desde n-n0 hasta n+n0
    for k = (n2(i) - n0) : (n2(i) + n0)
        if (k >= 0 && k < length(x2))
            y2(i) = y2(i) + x2(k+1); % k+1 porque los índices en Octave empiezan en 1
        end
    end
end

figure(2);
stem(n2, y2, 'filled', 'LineWidth', 1.5);
xlabel('n'); ylabel('y_2[n]');
grid on;


%SISTEMA 3
y3 = x1 + 2;               % A cada valor de x le sumamos 2

figure(3);
stem(n1, y3, 'filled', 'LineWidth', 1.5);
xlabel('n'); ylabel('y_3[n]');
grid on;

% Sistema 4
y4 = n1 .* x1;

figure(4);
stem(n1, y4, 'filled', 'LineWidth', 1.5);
xlabel('n'); ylabel('y_4[n]');
grid on;
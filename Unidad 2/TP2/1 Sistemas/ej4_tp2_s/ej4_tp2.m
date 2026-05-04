addpath('../../../../Funciones')


% 4.1

% Vector 'a' (coeficientes de la salida y)
a = [1,0,-1]; 

% Vector 'b' (coeficientes de la entrada x)
b = [1];  

% Generamos el vector de entrada x: Delta de Dirac de 20 muestras
% Un 1 en la posición n=0 (índice 1 en Octave) y ceros en el resto
N_muestras = 15;

n = 0:N_muestras-1; % Eje de tiempo discreto (de 0 a 19)

x_delta = [1, zeros(1, N_muestras - 1)];

% Llamamos a la función respetando tu orden: (a, b, x)
h_salida = respuesta_al_impulso(a, b, x_delta);
disp('Respuesta al impulso h[n]:');
disp(h_salida);
% Graficamos el resultado
figure(1);
subplot(3,1,1);
stem(n, h_salida, 'filled', 'LineWidth', 1.5);
xlabel('n (muestras)');
ylabel('h[n]');
title('Respuesta al impulso h[n] para y[n] −y[n−2] = x[n]');
grid on;


% 4.2
a = [1];
b = [1, 0.5];

h_salida_4_2 = respuesta_al_impulso(a, b, x_delta);
disp('Respuesta al impulso h[n] para el sistema 4.2:');
disp(h_salida_4_2);

% grafico un subplot
subplot(3,1,2);
stem(n, h_salida_4_2, 'filled', 'LineWidth', 1.5);
xlabel('n (muestras)');
ylabel('h[n]');
title('Respuesta al impulso h[n] para y[n] = x[n] +0,5x[n−1]');


% 4.3 
a = [1,-0.5,0.25];
b = [1];

h_salida_4_3 = respuesta_al_impulso(a, b, x_delta);
disp('Respuesta al impulso h[n] para el sistema 4.3:');
disp(h_salida_4_3);

subplot(3,1,3);
stem(n, h_salida_4_3, 'filled', 'LineWidth', 1.5);
xlabel('n (muestras)');
ylabel('h[n]');
title('Respuesta al impulso h[n] para y[n] −0,5y[n −1] +0,25y[n −2] = x[n]');

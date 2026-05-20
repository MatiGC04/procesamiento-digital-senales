% Ejercicio 3: Propiedad de retardo temporal de la TDF
% La propiedad dice que si retardo x[n-i] muestras en el tiempo,
% en frecuencia es equivalente a multiplicar X[k] por e^(-j2πki/N)
%
%       x[n-i] <=> X[k] * e^(-j2πki/N)
%
% en vez de retardar en tiempo directamente, aplico el retardo en el dominio frecuencial 
% y antitransformo.
% Si la propiedad se cumple, el resultado debe ser identico a x[n-i].
addpath('../../../Funciones');
fm = 100; fs = 10; % frecuencia de muestreo y de la señal
i_retardo = 10;    % retardo en muestras (0.1 segundos)

[t, x_n] = generasenoidal(0, 1, fm, fs, 0, 1);
N = length(x_n);

% Paso 1: calculo X[k] = TDF de la señal original
X_k = fft(x_n);

% Paso 2: aplico el retardo EN FRECUENCIA multiplicando por e^(-j2πki/N)
% esto es lo que dice la propiedad: retardar i muestras en tiempo
% equivale a multiplicar cada componente frecuencial k por ese factor complejo
k = 0:N-1;  % vector de indices de frecuencia k = 0, 1, ..., N-1
X_k_retardado = X_k .* exp(-j * 2*pi * k * i_retardo / N);

% Paso 3: antitransformo para volver al dominio del tiempo
% el resultado deberia ser x[n] desplazado i=10 muestras
% uso real() para eliminar residuos imaginarios numericos (errores de precision)
x_retardada = real(ifft(X_k_retardado));

% Paso 4: verificacion — genero x[n-i] directamente en tiempo para comparar
% uso circshift porque la TDF asume señal periodica: las muestras que
% "salen" por un extremo vuelven a entrar por el otro (desplazamiento circular)
x_desplazada = circshift(x_n, i_retardo);

% Comparo ambas señales calculando el error maximo punto a punto
% si la propiedad se cumple, el error debe ser practicamente 0 (solo error numerico)
error = max(abs(x_retardada - x_desplazada));
fprintf('Error maximo entre señales: %.2e\n', error);
if error < 1e-10
    disp('Propiedad de retardo verificada: ambas señales son identicas.');
else
    disp('Las señales no coinciden: la propiedad no se verifico.');
end

% Grafico comparativo de las tres señales
figure(6); clf;

subplot(3,1,1);
plot(t, x_n);
xlabel('Tiempo (s)'); ylabel('Amplitud');
title('Señal original x[n]');

subplot(3,1,2);
plot(t, x_retardada);
xlabel('Tiempo (s)'); ylabel('Amplitud');
% esta señal se obtuvo SIN tocar el dominio del tiempo:
% solo se modifico X[k] y se antitransformo
title('x retardada via IDFT: ifft( X[k] * e^{-j2\piki/N} )');

subplot(3,1,3);
plot(t, x_desplazada);
xlabel('Tiempo (s)'); ylabel('Amplitud');
% esta señal es el retardo "real" en tiempo, usada como referencia
title('x desplazada directamente en tiempo: circshift(x, 10)');
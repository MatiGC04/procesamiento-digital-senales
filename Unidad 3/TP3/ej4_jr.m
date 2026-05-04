addpath('../../Funciones');
clc

frecuencias = [1:1:10];
%coeficientes = [1 1 1 1 1 1 1 1 1 1];

coeficientes = [0.0:0.1:1];  % item a: sin fase
fases =        [pi/7, pi*2/7,  pi/4, 3*pi/9, pi/2, pi, pi/3, pi/3.5, pi/6, 2*pi/1.5];  % item b: con fase

%ITEM A ----------------

tini = 0; tfin = 1; fm = 1000;
f1 = zeros(1, fm);
for i = 1:length(frecuencias)
    [~, y] = generasenoidal(tini, tfin, fm, frecuencias(i), 0, 1);
    f1 = f1 + coeficientes(i) .* y;
end

% primero calculás el parecido con cada senoidal (sin fase)
parecidos1 = zeros(1, length(frecuencias));
for i = 1:length(frecuencias)
    [~, y] = generasenoidal(tini, tfin, fm, frecuencias(i), 0, 1);
    parecidos1(i) = (f1*y') / (norm(f1) * norm(y));
end

figure(1)
bar(frecuencias, parecidos1)
xlabel('Frecuencia (Hz)')
ylabel('Grado de parecido')


%CONCLUSIONES
%si  los coeficientes fueran los mismos, el grafico de barras mostraria
%que el parecido de nuestra señal es el mismo con todas las frecuencias

%el parecido aumenta segun el peso de la frecuencia comparada dentro de la señal

%esto resulta de saber que las senoidales de distintas frecuencias (enteros)
%son ortogonales entre si, luego es facil ver que el resultado del producto interno
%entre la senoidal y nuestra señal tiene cos(tita) = 1,y el parecido solo depende del alfa (los alfa si se desarrolla)




%ITEM B ----------------

f2 = zeros(1, fm);
for i = 1:length(frecuencias)
    [~, y] = generasenoidal(tini, tfin, fm, frecuencias(i), fases(i), 1);
    f2 = f2 + coeficientes(i) .* y;
end

% primero calculás el parecido con cada senoidal con fase
parecidos2 = zeros(1, length(frecuencias));
for i = 1:length(frecuencias)
    [~, y] = generasenoidal(tini, tfin, fm, frecuencias(i), 0, 1);
    parecidos2(i) = (f2*y') / (norm(f2) * norm(y)); 
end

figure(2)
bar(frecuencias, parecidos2)
xlabel('Frecuencia (Hz)')
ylabel('Grado de parecido')

%CONCLUSIONES

%Ahora el parecido de la sinusoidal con la señal ya no sirve como referencia
%para saber su peso dentro de la misma. Es decir, en señales expresadas como CL
%de sinusoidales desfadas el parecido ya no sirve como referencia del peso de la sinusoidal

% Esto se debe a que el producto interno entre dos sinusoidales de igual frecuencia
% pero distinta fase varia como cos(phi), por lo que una componente con mucho peso
% pero desfasada cerca de pi/2 puede dar un parecido cercano a cero, y una desfasada
% cerca de pi puede dar un valor negativo




%ITEM C --------------------

[~, cuadrada] = generaondacuadrada(tini, tfin, fm, 5.5, 0, 1);

parecidos3 = zeros(1, length(frecuencias));
for i = 1:length(frecuencias)
    [~, y] = generasenoidal(tini, tfin, fm, frecuencias(i), 0, 1);
    parecidos3(i) = (cuadrada*y') / (norm(cuadrada) * norm(y));
end
figure(3)
bar(frecuencias, parecidos3)
xlabel('Frecuencia (Hz)')
ylabel('Grado de parecido')


%DUDA
% CONCLUSIONES ITEM C
% La onda cuadrada de 5.5 Hz no puede ser representada exactamente por ninguna
% de las senoidales de la grilla de 1 a 10 Hz, ya que sus armonicos naturales
% (5.5, 16.5, 27.5 Hz...) no coinciden con ninguna frecuencia de dicha grilla.
% Esto se refleja en el grafico de barras: no hay un pico claro en ninguna
% frecuencia particular, sino que el parecido aparece distribuido entre varias.


% Esto es consecuencia directa de la ortogonalidad de las senoidales:
% si la frecuencia necesaria no esta en la base de comparacion, la energia
% de la señal se "derrama" sobre las frecuencias disponibles sin concentrarse
% en ninguna. En terminos de espacios vectoriales, es equivalente al caso de
% base no completa: si el conjunto de senoidales no incluye las frecuencias
% de la señal a representar, siempre existira un error de aproximacion.
% Ejercicio Integrador TP3
% Objetivo: Interpretar señales como vectores en RN, calcular sus medidas de magnitud (normas) 
% y evaluar el "parecido" entre señales mediante el producto interno, aplicando conceptos de bases 
% ortogonales
% Parte I:
%  Genere una señal compuesta x[n] de N=500 muestras que sea la suma de dos 
% componentes: una señal senoidal de frecuencia 100Hz y una señal de ruido aleatorio 
% con distribución normal (media 0 y varianza 0.5). Considere una frecuencia de muestreo 
% de 1000Hz.
%  Grafique la señal y calcule la norma-2 y, a partir de ella, determine la energía y el valor 
% RMS de la señal.
%  Calcule la acción y la amplitud de la señal generada

N = 500;
x_r = randn(1,N)*sqrt(0.5); % ruido con varianza 0.5

fm = 1000;
fs = 100;

[tx,x_s] = generasenoidal(0,(N)/fm,fm,fs,0,1); % señal senoidal de 100Hz

x = x_s + x_r; % señal compuesta

figure(1);
plot(tx,x);
xlabel('Tiempo (s)');
ylabel('x[n]');

% calculo norma-2 y a partir de ella determino la energia y el valor RMS de la señal
norma_2 = norma_p(x,2);
energia = norma_2^2;
RMS = sqrt(energia/N);

% calculo la accion y la amplitud de la señal generada
accion = norma_p(x,1);

amplitud = norma_p(x,Inf);


% Parte II:
% Cree una señal de referencia y[n] que sea una senoidal pura de 100Hz con la misma
% longitud que x[n]. Luego, calcule el producto interno ⟨x, y⟩ entre la señal ruidosa
% x[n] y la señal de referencia y[n].
%
% Posteriormente, obtenga el ángulo entre ambas señales utilizando el producto interno
% y las normas de las señales. Analice el resultado para determinar si las señales son
% similares o no, basándose en el valor del ángulo obtenido.

[ty,y] = generasenoidal(0,(N)/fm,fm,100,0,1); % señal de referencia


producto_int = producto_interno(x,y);

angulo_entre_y_x = producto_int/(norma_p(x,2)*norma_p(y,2)); % coseno del angulo entre x e y

if abs(angulo_entre_y_x) > 0.9
    disp("Las señales son similares (ángulo pequeño).");
elseif abs(angulo_entre_y_x) < 0.1
    disp("Las señales son muy diferentes (ángulo cercano a 90 grados).");
else
    fprintf("Las señales tienen cierta similitud (ángulo intermedio, coseno = %.2f).\n", angulo_entre_y_x);
end

# Parte III:
%Suponga que desea aproximar su señal ruidosa x[n] utilizando una base simplificada de solo 
%dos vectores ortonormales: ϕ1 (senoidal de 100 Hz) y ϕ2 (senoidal de 200 Hz).
% Obtenga los coeficientes de proyección α1 y α2.
% Construya la señal aproximada ~ x.
% Calcule el Error Cuadrático Total entre la señal original y su aproximación (utilizando 
%la norma-2).

[t1,s1] = generasenoidal(0,(N)/fm,fm,100,0,1); % ϕ1
[t2,s2] = generasenoidal(0,(N)/fm,fm,200,0,1); % ϕ2

a1 = producto_interno(x, s1)/producto_interno(x, x); % coeficiente de proyección sobre ϕ1
a2 = producto_interno(x, s2)/producto_interno(x, x); % coeficiente de proyección sobre ϕ2

x_aprox = a1*s1 + a2*s2; % señal aproximada
figure(2);
plot(tx,x_aprox);
title('Señal Aproximada');
xlabel('Tiempo (s)');
ylabel('x_aprox[n]');

ECT = norma_p(x - x_aprox, 2)^2; % Error Cuadrático Total 

fprintf("Error Cuadrático Total entre la señal original y su aproximación: %.4f\n", ECT);

# Parte IV:
# Si se cambiara la fase de la señal de referencia y[n] a 90°
# ¿como afentaria esto al valor del producto interno? Justifique su respuesta.
% Afectaria esto al valor haciendo que el producto interno sea cercano a cero.


% Si la fase de y[n] cambia a 90° (π/2), la referencia pasa a ser un coseno:

% y[n] = cos(2π·f·n), que es ortogonal al seno original.
% El producto interno <seno, coseno> = 0, por lo tanto el coeficiente de proyección:
% ci = <xi, y> / ||y||^2 = 0 para cualquier segmento xi.
% Esto implica que no se pueden obtener los coeficientes de proyección de la Parte III,
% y la aproximación de la señal sobre esa referencia sería nula.
% Geométricamente, ambas señales están en ángulo recto (θ=90°), 
% por lo que cos(θ)=0 y no hay componente proyectable de una sobre la otra.
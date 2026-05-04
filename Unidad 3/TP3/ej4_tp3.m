clc
addpath("../../Funciones")
k = 1:10;

# El conjunto S = {s_k(t)/ s_k(t) = sin(2pi*k*t), k[1,10]}
tini = 0;
tfin = 1;
t = linspace(tini, tfin, 1000);


a = 0.1:0.1:1;

# armo el conjunto s
S = zeros(length(a), length(t));
for j = 1: length(k)
  S(j, :) = sin(2*pi*k(j)*t);
end

# 4.1
% 1. mida el grado de parecido con dichas senoidales representando el resul
% tado en un gr´afico de barras

% armo X1 = a1*s1(t) +...+ an*sn(t)

X1 = zeros(1, length(t));
for i = 1:length(a)
  X1 = X1 + a(i)*S(i, :);
end

% ahora calculo el grado de parecido
display(" 4.1 - grado de parecido")
parecido = zeros(1, length(k));
for i = 1:length(k)
  % Calculamos el coeficiente de proyeccion de X1 sobre cada s_k.
  % Al normalizar por ||s_k||^2 obtenemos directamente el alpha_k,
  % es decir, cuanto de s_k hay en X1.
  parecido(i) = producto_interno(X1, S(i, :))/producto_interno(S(i,:), S(i,:)); % el pdf dice que al dividir por al norma 2 se obtiene el grado de parecido
end
fprintf("\n\n")
parecido'
figure(1)
clf
bar(k, parecido)
xlabel("k")
ylabel("Grado de parecido")




# 4.2
% armo el conjunto Z = {z_k(t)/ z_k(t) = sin(2pi*k*t + fase_k), k[1,10]}

fase = [pi, pi/10, pi/5, 3*pi/10, 2*pi/5, 5*pi/10, 3*pi/5, 7*pi/10, 4*pi/5, 9*pi/10];
Z = zeros(length(k), length(t));
for j = 1: length(k)
  Z(j, :) = sin(2*pi*k(j)*t + fase(j));
end

# ahora creo un X2 = B1*z1(t) +...+ Bn*zn(t)
B = 0.1:0.1:1;
X2 = zeros(1, length(t));
for i = 1:length(B)
  X2 = X2 + B(i)*Z(i, :);
end
% 2. mida el grado de parecido con dichas senoidales representando el resul
% tado en un gr´afico de barras
display(" 4.2 - grado de parecido")
parecido2 = zeros(1, length(k));
for i = 1:length(k)
  % comparamos X2 contra S (no contra Z)
  parecido2(i) = producto_interno(X2, S(i,:)) / producto_interno(S(i,:), S(i,:));
end
parecido2'
figure(2)
clf
bar(k, parecido2)
xlabel("k")
ylabel("Grado de parecido")

# 4.3
#realice el grafico de barras para el caso de una señal cuadrada de 5,5Hz.

fs = 5.5; % frecuencia de la señal cuadrada
[tc,y] = generaondacuadrada(tini,tfin,1000,fs,0,1);
display(" 4.3 - señal cuadrada")
y
figure(4)
plot(tc,y, "LineWidth", 2)
xlabel("Tiempo (s)")
ylabel("Amplitud")
title("Señal Cuadrada de 5.5 Hz")


% ahora veo el grado de parecido con cada s_k
display(" 4.3 - grado de parecido")
parecido3 = zeros(1, length(k));
for i = 1:length(k)
  parecido3(i) = producto_interno(y, S(i, :))/producto_interno(S(i,:), S(i,:));
end
fprintf("\n\n")
parecido3'
figure(3)
clf
bar(k, parecido3)
xlabel("k")
ylabel("Grado de parecido")

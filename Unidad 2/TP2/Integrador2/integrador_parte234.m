
% Parte 2
impulso_unitario = @(n) (n==0);
N = 20;
n = 0:N-1;

ycoef = [1, -0.6];
xcoef = [1, 0.2];

h = respuesta_al_impulso_general(ycoef, xcoef, N);

figure(1);
stem(0:length(h)-1, h, 'filled', 'LineWidth', 1.5);
xlabel('n (muestras)');


% Parte 3
addpath('../../../Funciones');
l = 0:9;
a = 2;
x_pulso_rectangular = @(t) 1*(t>=0 & t<a);

x = x_pulso_rectangular(l);

% a) utilizando sumatoria de convolucion

y = convolucion_lineal_sumatoria(x, h);
disp('Resultado de la convolución lineal utilizando sumatoria:');
disp(y);

% b) utilizando la representacion matricial de la convolucion para las primeras muestras

X = x(:); % vector columna
h_columna = h(:); % vector columna
Y = convolucion_lineal_matricial(X,h_columna);
disp('Resultado de la convolución lineal utilizando la representación matricial:');
disp(Y);

% c) Utilizando la convolucion circular
% segun el pdf tengo que agregarle N-1 ceros a x e h, para que la 
% conv circular equivalga a la linal
Nx = length(x);
Nh = length(h);

x_m = [x, zeros(1, Nh-1)];
h_m = [h, zeros(1, Nx-1)];
yc = convolucion_circular_formula(x_m, h_m);
disp('Resultado de la convolución circular:');
disp(yc);


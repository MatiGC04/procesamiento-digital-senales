addpath('../../../../Funciones')
addpath('../../../Funciones')
h_a = @(n) sin(8*n);
a = 0.94; % o 2*rand()-1.

h_b = @(n) a.^n;
% 0<=n<= N-1. N: numero de muestras distintas de 0
N = 20;
n = 0:N-1;

impulso_unitario = @(n) (n==0);

x = @(n) impulso_unitario(n) - a*impulso_unitario(n-1);

% 3.1 Obtener respuestas de impulso de los sistemas A y B
x_n = x(n);
hA = h_a(n);
hB = h_b(n);

% grafico
figure(1);
subplot(3,1,1);
plot(n, x_n, 'o-', 'LineWidth', 1.5);
xlabel('n (muestras)');
ylabel('x[n]');
subplot(3,1,2);
plot(n, hA, 'o-', 'LineWidth', 1.5);
xlabel('n (muestras)');
ylabel('h_a[n]');
subplot(3,1,3);
plot(n, hB, 'o-', 'LineWidth', 1.5);
xlabel('n (muestras)');
ylabel('h_b[n]');

% 3.2 Obtener salida

w = convolucion_lineal(x_n, hA);
y = convolucion_lineal(w, hB);

figure(2);
subplot(2,1,1);

stem(0:length(w)-1, w, 'filled', 'LineWidth', 1.5);
legend('w[n] = x[n] * h_a[n]');
subplot(2,1,2);
stem(0:length(y)-1, y, 'filled', 'LineWidth', 1.5);
legend('y[n] = w[n] * h_b[n]');

% Invierto el orden de los sistemas
s1 = convolucion_lineal(x_n, hB);
s2 = convolucion_lineal(s1, hA);
figure(3);
subplot(2,1,1);
stem(0:length(s1)-1, s1, 'filled', 'LineWidth', 1.5);
legend('s1[n] = x[n] * h_b[n]');
subplot(2,1,2);
stem(0:length(s2)-1, s2, 'filled', 'LineWidth', 1.5);
legend('s2[n] = s1[n] * h_a[n]');


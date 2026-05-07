addpath('../../Funciones'); % para usar el integrador del TP3
% EJ3 TP3 - Aproximacion con funciones de Legendre

N_puntos = 1000;
t  = linspace(-1, 1, N_puntos);
dt = t(2) - t(1);

% Senal del ejemplo (funcion signo)
y_t = -1*(t < 0) + 1*(t >= 0);

% Funciones de Legendre ortonormales (las 4 del ejemplo)
phi0 = legendre_ortonormal(0, t);
phi1 = legendre_ortonormal(1, t);
phi2 = legendre_ortonormal(2, t);
phi3 = legendre_ortonormal(3, t);

% -----------------------------------------------------------------------------------------------------


% 3.1 - ECT con los coeficientes calculados en el ejemplo

a0 = producto_interno(y_t, phi0) * dt;
a1 = producto_interno(y_t, phi1) * dt;
a2 = producto_interno(y_t, phi2) * dt;
a3 = producto_interno(y_t, phi3) * dt;

fprintf('\n--- 3.1: Coeficientes del ejemplo ---\n');
fprintf('  alpha_0 = %8.5f\n', a0);
fprintf('  alpha_1 = %8.5f\n', a1);
fprintf('  alpha_2 = %8.5f\n', a2);
fprintf('  alpha_3 = %8.5f\n', a3);

y_aprox_4 = a0*phi0 + a1*phi1 + a2*phi2 + a3*phi3;
ect_4 = norma_p(y_t - y_aprox_4, 2)^2 * dt;
fprintf('  ECT con 4 coeficientes = %.6f\n', ect_4);

figure(1);
plot(t, y_t,'b','LineWidth', 1.5,'DisplayName','y(t) original');
hold on;
plot(t, y_aprox_4,'r--', 'LineWidth', 1.5, 'DisplayName', 'Aprox 4 coef');
xlabel('t'); ylabel('Amplitud');
title('3.1 - Aproximacion con 4 funciones de Legendre');
legend show; grid on;

% -----------------------------------------------------------------------------------------------------

% 3.2 - Superficie 3D: ECT variando alpha_1 y alpha_3

A1_vec = linspace(a1 - 0.5, a1 + 0.5, 50);
A3_vec = linspace(a3 - 0.5, a3 + 0.5, 50);

ECT_matrix = zeros(length(A1_vec), length(A3_vec));

for i = 1:length(A1_vec)
  for j = 1:length(A3_vec)
    y_var           = A1_vec(i)*phi1 + A3_vec(j)*phi3;
    ECT_matrix(i,j) = norma_p(y_t - y_var, 2)^2 * dt;
  end
end

figure(2);
surf(A1_vec, A3_vec, ECT_matrix');
xlabel('\alpha_1'); ylabel('\alpha_3'); zlabel('ECT');
title('3.2 - ECT en funcion de \alpha_1 y \alpha_3');
shading interp; colorbar;

% Marco el minimo en la superficie
[~, idx] = min(ECT_matrix(:));
[i_min, j_min] = ind2sub(size(ECT_matrix), idx); 
% esto devuelve las coordenadas (i_min, j_min) del minimo en la matriz ECT_matrix
hold on;
plot3(A1_vec(i_min), A3_vec(j_min), ECT_matrix(i_min,j_min),'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

% -----------------------------------------------------------------------------------------------------



% 3.3 - ECT acumulado al aumentar el numero de coeficientes

N_max = 12;

alphas   = zeros(1, N_max);
phis     = zeros(N_max, N_puntos);
ect_vs_n = zeros(1, N_max);

for n = 0:(N_max - 1)
  phi_n        = legendre_ortonormal(n, t);
  phis(n+1, :) = phi_n;
  alphas(n+1)  = producto_interno(y_t, phi_n) * dt;
end

fprintf('\n--- 3.3: ECT al aumentar coeficientes ---\n');
y_aprox_acc = zeros(1, N_puntos);

for n = 1:N_max
  y_aprox_acc = y_aprox_acc + alphas(n) * phis(n, :);
  ect_vs_n(n) = norma_p(y_t - y_aprox_acc, 2)^2 * dt;
  fprintf('  N = %2d funciones  ->  ECT = %.6f\n', n, ect_vs_n(n));
end

figure(3);
stem(1:N_max, ect_vs_n, 'filled', 'LineWidth', 1.5);
xlabel('N (cantidad de funciones)');
ylabel('ECT');
title('3.3 - ECT vs cantidad de funciones de Legendre');
grid on;

figure(4);
plot(t, y_t,'b','LineWidth', 1.5, 'DisplayName', 'y(t) original');
hold on;
plot(t, y_aprox_acc, 'r--', 'LineWidth', 1.5, 'DisplayName', sprintf('Aprox N=%d', N_max));
xlabel('t'); ylabel('Amplitud');
title(sprintf('3.3 - Aproximacion con %d funciones de Legendre', N_max));
#legend show;
grid on;
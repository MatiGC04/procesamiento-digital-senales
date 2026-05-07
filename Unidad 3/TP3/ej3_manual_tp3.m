t = linspace(-1, 1, 1000);
y_t = -1*(t<0) + 1*(t>=0);

# Funciones de Legendre (phi)
phi0 = ones(1,length(t)) / sqrt(2);
phi1 = sqrt(3/2) * t;
phi2 = sqrt(5/2) * (3/2*t.^2 - 1/2);
phi3 = sqrt(7/2) * (5/2*t.^3 - 3/2*t);

# Coeficientes (alpha) - dados por el PDF
a0 = 0;
a1 = sqrt(3/2);
a2 = 0;
a3 = -sqrt(7/32);

# Aproximacion
y_aprox = a0*phi0 + a1*phi1 + a2*phi2 + a3*phi3;

# 3.1 - ECT con coeficientes del ejemplo
ECT = sum((y_t - y_aprox).^2);
fprintf('3.1 - ECT con coeficientes del ejemplo: %f\n', ECT);

# 3.2 - Variacion de coeficientes en 3D
A1 = linspace(a1-0.5, a1+0.5, 50);  # menos puntos para que sea mas rapido
A3 = linspace(a3-0.5, a3+0.5, 50);

ECT_matrix = zeros(length(A1), length(A3));
for i = 1:length(A1)
  for j = 1:length(A3)
    y_var = A1(i)*phi1 + A3(j)*phi3;
    ECT_matrix(i,j) = sum((y_t - y_var).^2);
  end
end

figure(2);
surf(A1, A3, ECT_matrix');
xlabel('a1'); ylabel('a3'); zlabel('ECT');
title('Error Cuadratico Total en funcion de a1 y a3');

# 3.3 - Con más coeficientes a, para comprobar como se reduce el error

phi4 = sqrt(9/2) * (35/8*t.^4 - 30/8*t.^2 + 3/8);
phi5 = sqrt(11/2) * (63/8*t.^5 - 70/8*t.^3 + 15/8*t);

a4 = 0;
a5 = (1/8)*sqrt(11/2);


# Con 6 coeficientes
y_aprox_4 = y_aprox;  # ya tiene los primeros 4 coeficientes
y_aprox_6 = y_aprox_4 + a4*phi4 + a5*phi5;
ECT_6 = sum((y_t - y_aprox_6).^2);

fprintf('3.3 - ECT con 6 coeficientes: %f\n', ECT_6);
fprintf('3.3 - ECT con 4 coeficientes: %f\n', ECT);
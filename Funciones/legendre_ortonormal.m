function phi = legendre_ortonormal(n, t)
  % Devuelve la funcion de Legendre ortonormal de orden n
  % phi_n(t) = sqrt((2n+1)/2) * P_n(t)
  Pn = legendre(n, t);   % matriz: fila 1 = P_n(t), filas siguientes = asociados
  phi = sqrt((2*n + 1) / 2) * Pn(1, :);
end
function result = ECT(y, y_aprox, dt)
  % Error Cuadratico Total
  result = norma_p(y - y_aprox, 2, dt)^2;
end

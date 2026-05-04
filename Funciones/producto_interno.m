function [resultado] = producto_interno(x, y)
  y_conj = real(y) - j*imag(y);  # conjugado manual
  resultado = sum(x .* y_conj); # tambien podria usar simplemente conj(y)
endfunction




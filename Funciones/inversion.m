# -inversión: reversion temporal. f(t) = f(-t)
# -rectificación: transforma las señales en positivas. Se usa en fuentes que reciben corriente alterna,
# para pasarlo a continua. Entonces la operación seria: f(t) = |f(t)| o f(t) = max(f(t), 0)
# -cuantización en 8 niveles, consiste en cuantizar la amplitud que significa establecer un numero
# que limita la precisión de la señal a 8 niveles discretos. Equivale a dividir el intervalo
# de la amplitud en N partes y asignar el valor de acuerdo a la parte mas cercana sobre la que cae el valor medio
# para sistemas binarios N deberia ser potencia de dos

%voy a suponer que para estas operaciones voy a recibir una señal y un vector t.
function [yf] = inversion(y,t)
    yf = y(end:-1:1); # invierto el orden de las muestras

endfunction




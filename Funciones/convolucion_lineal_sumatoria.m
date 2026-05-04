
function y = convolucion_lineal_sumatoria(x, h)
    y = zeros((length(h) + length(x))-1,1); % Vector de salida con longitud suficiente para la convolución completa

    for k = 1 : length(y)
        suma = 0;
        for i = 1: length(x) % equivale a i=0: N-1
            # para evitar indices invalidos, e indices fuera del rango de h
            if (k-i)+1>=1 && (k-i)+1<=length(h)
                suma = suma + x(i)*h((k-i)+1); # necesito sumarle 1 a k-i para que tome los indices validos
            end
        end 
        y(k) = suma;
    end
endfunction
% Utilizo la ecuacion en diferencias para calcular la respuesta al impulso de un sistema dado por sus coeficientes de salida y (a) y de entrada x (b).
function h = respuesta_al_impulso_general(y_coef, x_coef, N)
    muestras = 0:N-1;
    
    if(N>length(y_coef))
        y_coef = [y_coef, zeros(1, N-length(y_coef))];
    end
    if(N>length(x_coef))
        x_coef = [x_coef, zeros(1, N-length(x_coef))];
    end

    x_unit = [1, zeros(1, N-1)]; % impulso unitario

    h = zeros(1, N);
    for n = 1: length(muestras)
        suma_M = 0;
        suma_N = 0;
        for k = 1: length(x_coef)
            indice_M = n - k + 1;
            if indice_M > 0 
                suma_M = suma_M + x_coef(k)* x_unit(indice_M);
            end
        end
        for k = 2: length(y_coef)
            indice_N = n - k+1;
            if indice_N > 0 
                suma_N = suma_N + y_coef(k)* h(indice_N);
            end
        end
        if y_coef(1) ~= 0
            h(n) = (suma_M - suma_N)/ y_coef(1);
        else
            h(n) = (suma_M - suma_N);
        end
    end
    


endfunction
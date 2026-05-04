function y = convolucion_lineal(x, h)
    % convolucion lineal por medio de multiplicacion termino a termino
    % Para cada elemento de x, calculo su contribucion a la salida
    % No necesito invertir nada porque no estoy rotando h, sino desplazando.
    % viendo cuanto contribuye cada elemento de x a cada elemento de y.
    
    
    largo_salida = length(x) + length(h) - 1;
    y = zeros(largo_salida, 1);
    
    for n=1: length(x)
        % h desplazada k-1 posiciones representa y[n-k] para todo n
        h_desplazada = [zeros(1,n-1) , h]; % zeros(1, n-1) genera un vector fila para concatenarse con h (que también es fila)
        vec_aux = x(n)*h_desplazada;
        for k=1: length(vec_aux)
            y(k) = y(k) + vec_aux(k);
        endfor
    endfor
endfunction 
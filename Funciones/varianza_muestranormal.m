function [v] = varianza_muestranormal(muestra);
    muestra = muestra(:)'; %Forzamos a que sea un vector fila
    N = length(muestra);
    media=(ones(1,N)*muestra')/N;   # ones(1,N) es un vector fila(1) de N columnas.
    #trasponer muestra permite hacer el producto matricial 1xN * Nx1 = 1x1 (escalar)

    vector_aux = muestra-media; 
    v = 1/(N-1)*(vector_aux*vector_aux'); 
    # 1xN * Nx1 = 1x1 (escalar con sus valores al cuadrado -> a^2 + b^2 +..
endfunction
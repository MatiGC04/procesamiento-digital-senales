function m = media_muestranormal(muestra)
    muestra = muestra(:)';   %fuerzo a que sea vector fila (1xN) para que me den las dim en la multiplicacion
    N = length(muestra);
    m=(muestra*ones(N,1))/N;
endfunction
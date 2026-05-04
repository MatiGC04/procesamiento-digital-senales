function y = convolucion_circular(x, h)
    if length(x) ~= length(h)
        error('Los vectores x y h deben tener la misma longitud para la convolución circular.');
    end

    #x = x(:);
    #h = h(:);
    N = length(x);
    y = zeros(N, 1);

    for k = 1:N
        % h se va rotando una posicion por cada k
        % k=1(base1) equivale a k=0(base0): h sin rotar
        r = k-1; # cuantas posiciones debo rotar h
        if r == 0
            h_rotada = h;
        else
            h_rotada = [h(r+1:end) , h(1:r)]
        end

        suma = 0;
        for l = 1:N
            suma = suma + x(l) * h_rotada(l);
        end
        y(k) = suma;
    end
endfunction
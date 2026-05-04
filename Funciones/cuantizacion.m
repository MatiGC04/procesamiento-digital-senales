function [p] = cuantizacion (y,N)
    % rESTO
    y_pos = y - min(y); % desplazamos la señal para que el minimo sea 0
    amplitud = max(y_pos); # la amplitud de la señal desplazada
    H = amplitud/(N-1); # el tamaño de cada nivel de cuantización
    % donde N es la canidad de niveles, para este enunciado es 8

    y_cuantizada = 0.*(y_pos<0) + H.*floor(y_pos/H).*(y_pos>=0 & y_pos<amplitud) + (N-1)*H.*(y_pos>=amplitud); # cuantizamos la señal desplazada
    p = y_cuantizada + min(y); # desplazamos la señal cuantizada de vuelta a su rango original
endfunction
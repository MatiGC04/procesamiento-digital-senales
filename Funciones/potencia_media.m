function [p_media] = potencia_media(x)
    p_media = (1/(2*length(x))) * sum(x.^2)
endfunction
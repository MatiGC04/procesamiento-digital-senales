function [resultado] = norma_p(x, p)
    if p == Inf
        resultado = max(abs(x));
        return
    end
    if p == -Inf
        resultado = min(abs(x));
        return
    end
    if p <= 0
        error("p debe ser un número positivo o infinito.")
    end
    resultado = sum(abs(x).^p)^(1/p);
endfunction
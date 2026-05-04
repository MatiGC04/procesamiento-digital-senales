function [var] = varianza(R)
    var = sum(R - (mean(R)).^2) ./ (Length(R) - 1);
endfunction
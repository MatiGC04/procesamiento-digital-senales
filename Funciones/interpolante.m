
function [x, t] = interpolante(t_viejo, x_viejo, fm_nuevo, I)
    T_viejo = t_viejo(2) - t_viejo(1); % como el t es uniforme como lo creamos siempre como ini:T:fin-T, entonces al restar nos queda: tini+T - tini = T
    T = 1/fm_nuevo;
    t = t_viejo(1):T:t_viejo(end); % como T va a ser mas rapido que el T_viejo habra mas muestras
    factor = round(fm_nuevo*T_viejo); % esto es para saber cuantas muestras nuevas hay por cada muestra vieja, es decir el factor de interpolacion
    x = zeros(1, length(t)); % inicializamos el vector de x con ceros, con la longitud del nuevo vector de tiempo

    n = length(x_viejo); % longitud del vector de muestras viejas
    m = length(t); % longitud del vector de tiempo nuevo
    for i = 1 : length(t)
        for j = 1 : length(t_viejo)
            delta =  [(i-1)*T ]./T_viejo - [(j-1)*T_viejo]./T_viejo ; 
            x(i) = x(i) + x_viejo(j) * I(delta); % esto es para calcular el valor de la muestra nueva, multiplicando el vector de muestras viejas por el vector de indices correspondientes a cada muestra nueva
        end
    end
endfunction


    
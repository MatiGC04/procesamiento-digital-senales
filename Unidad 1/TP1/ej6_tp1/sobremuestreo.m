function [x,t] = sobremuestreojr(t_viej,x_viej,fm_new,funcion_pesos)
    T_viej = t_viej(2)-t_viej(1);
    T = 1/fm_new;
    t = t_viej(1):T:t_viej(end);
    factor = round(fm_new * T_viej);  % cuantas muestras nuevas por muestra vieja
    x = zeros(1,length(t));
    for i=1:1:length(t)
        vec_distancias = (i-1)/factor - (0:length(t_viej)-1);
        %La idea es trabajar con los indices y no con los tiempos
        %al ser numeros discretos podemos trabajarlos facilmente sin 
        %incurrir en errores de redondeo
        vec_pesos = funcion_pesos(vec_distancias);
        x(i) = x_viej * vec_pesos';
    end
endfunction
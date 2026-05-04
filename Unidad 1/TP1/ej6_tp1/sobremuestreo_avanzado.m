function [x,t] = sobremuestreo_avanzado(t_viej,x_viej,fm_new,funcion_pesos)
    T_viej = t_viej(2)-t_viej(1);   %obtengo el perido ya que t esta definido como tini:T:fin-T, entonces al restar nos queda: tini+T - tini = T
    T = 1/fm_new;
    t = t_viej(1):T:t_viej(end);
    factor = round(fm_new * T_viej);  % cuantas muestras nuevas por muestra vieja
    indices_nuevos = ((0:length(t)-1)./factor)';
    indices_viejos = (0:length(t_viej)-1);
    distancias = indices_nuevos-indices_viejos; %Esto genera una matriz
    %donde cada fila esta dada por un vector de "distancias" entre un indice nuevo con respecto a los indices_viejos
    %cada columna lo unico que cambia es el indice del tiempos nuevo con el que calculamos esas distancias
    x = funcion_pesos(distancias)*x_viej';

endfunction
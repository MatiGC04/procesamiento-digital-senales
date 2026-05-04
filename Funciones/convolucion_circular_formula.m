function y = convolucion_circular_formula(x, h)
    % no debo hacer x periodica ya que con
    % mod(N+k-l,N)+1) ya estoy haciendo circular la convolucion, es decir, envolviendo los indices de x
    % Y tampoco debo definir h como nula fuera de rango ya que, 
    % nunca se va ir a indices fueras de su rango.


    % segundo h 
    if(length(x) ~= length(h))
        error('Los vectores x e h deben tener la misma longitud para la convolución circular.');
    end
    N = length(x);
    y = zeros(N, 1); % Vector de salida con la misma longitud que x
    for k = 1: length(x)
        suma = 0;
        for l = 1: length(x) % equivale a i=0: N-1
            % Para la convolución circular, usamos el operador mod para envolver los índices
            indice_x = mod(N+k-l,N)+1; % +1 para ajustar al índice de Octave
            suma = suma + h(l)*x(indice_x);
        end 
        y(k) = suma;
    end
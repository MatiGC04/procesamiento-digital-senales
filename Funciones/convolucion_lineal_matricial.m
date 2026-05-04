function Y = convolucion_lineal_matricial(x, h)
    % Asegurarse de que x y h sean vectores columna
    X = x(:);
    h = h(:);
    
    % Calcular la longitud de la salida
    largo_salida = length(X) + length(h) - 1;
    H = zeros(largo_salida, length(X));    
    for i = 1 : length(x)
        # de la fila i-esima hasta la 29, de la columna i, coloco el vector h
        H(i:i+length(h)-1, i) = h; % Colocar el vector h en la matriz H desplazado según el índice i
    end
    % Realizar la multiplicación matricial para obtener la convolución
    Y = H * X;
end
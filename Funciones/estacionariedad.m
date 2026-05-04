function [es_estacionario] = estacionariedad(X,R,N)
    if(R > 1) # si tenemos mas de una realizacion y mas de un instante de tiempo entonces podemos corroborar la estacionariedad
        tolerancia = 1./sqrt(R); # de acuerdo al error de la media muestral = desvio_muestral/raiz(N_muestras), como la varianza es 1 entonces el desvio_muestral es 1, entonces el error de la media muestral es 1/sqrt(N_muestras) y como tenemos R realizaciones entonces el error de la media muestral es 1/sqrt(R)
        # decidi usar el error de la media ya que yo para comprobar tanto estacionariedad como ergodicidad necesito comparar con el promedio.

        # corroborar estacionariedad
        # ¿la media y varianza son iguales en cualquier instante de tiempo?
        for i = 1 : N
            V(i) = var(X(:,i));
            Media(i) = mean(X(:,i));
        end
        
        
    
    else
        tolerancia = 1./sqrt(lenght(X)); # de acuerdo al error de la media muestral = desvio_muestral/raiz(N_muestras), como la varianza es 1 entonces el desvio_muestral es 1, entonces el error de la media muestral es 1/sqrt(N_muestras) y como tenemos R realizaciones entonces el error de la media muestral es 1/sqrt(R) 
        N = length(X); # si tenemos solo una realizacion entonces el numero de muestras es la longitud de la realizacion
        for i = 1 : N
            V(i) = var(X(i));
            Media(i) = mean(X(i));
        end
        # como ya tenemos la varianza y media de todas las r_i en cada instante n_i
        # entonces si el promedio de la V es menor que la tolerancia (recordar que como es distribucion normal deberia cumplirse que la varianza es 1)
        # y el promedio de la Media sea menor a la tolerancia (en la formula de la varianza es la diferencia entre cada muestra con la media,
        # entonces si reemplazo queda Xm - Xm = 0 entonces la varianza de la media deberia tender a 0)
        
    end

    # como ya tenemos la varianza y media de todas las r_i en cada instante n_i
    # entonces si el promedio de la V es menor que la tolerancia (recordar que como es distribucion normal deberia cumplirse que la varianza es 1)
    # y el promedio de la Media sea menor a la tolerancia (en la formula de la varianza es la diferencia entre cada muestra con la media,
    # entonces si reemplazo queda Xm - Xm = 0 entonces la varianza de la media deberia tender a 0)
    if (1 - tolerancia < mean(V) &&  mean(V) < 1 + tolerancia) && mean(Media) < tolerancia
        es_estacionario = true;
    else
        es_estacionario = false;
    end
endfunction
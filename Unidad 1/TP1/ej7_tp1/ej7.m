addpath('../../../Funciones')

N = 1000;
R = 500;
X = randn(R, N);

factor_ajuste = 4;


tolerancia_R = factor_ajuste*(1 / sqrt(R)); 
tolerancia_N = factor_ajuste*(1 / sqrt(N));

tolerancia_varR = factor_ajuste*(sqrt(2/(R-1))); # tendria que ir multiplicado por varianza, pero la var teoria es 1

% --- 1. Comprobar ESTACIONARIEDAD ---
% Estacionariedad: las medidas estadisticas (media y varianza)
% tienen que ser constante en cada instante de tiempo
% para cada realizacioón


for j = 1:N
    Media_en_cada_instanteN(j) = media_muestranormal(X(:, j));
    Varianza_en_cada_instanteN(j) = varianza_muestranormal(X(:, j));
end
# var(X, 0, 1) calcula la varianza de cada columna (instante de tiempo) sin normalizar por N-1 (porque el segundo argumento es 0)


% Para que sea estacionario, NINGUNA de las medias ni varianzas estadísticas a lo largo 
% del tiempo debe alejarse de los valores teóricos (0 y 1 respectivamente).
% Usamos max() y abs() para ver el peor caso en el tiempo.
error_max_media = max(abs(Media_en_cada_instanteN - 0));
error_max_var   = max(abs(Varianza_en_cada_instanteN - 1));

if (error_max_var < tolerancia_varR) && (error_max_media < tolerancia_R)
    disp('Es Estacionario: La media y varianza estadísticas son constantes en el tiempo.');
else
    disp('No es Estacionario');
end


# corroborar ergodicidad

# Ergodicidad, el promedio de una realizacion a lo largo del tiempo,
# es igual al promedio de todas las realizaciones en cualquier instante de tiempo,
# entonces tomo por ej la primera realizacion y obtengo su media

r_al_azar = randi(R); # randi(R) devuelve un numero entero aleatorio entre 1 y R
media_temporal_azar = media_muestranormal(X(r_al_azar, :)); 

errores_ergodicidad = abs(media_temporal_azar - Media_en_cada_instanteN);
error_max_ergodicidad = max(errores_ergodicidad);

# sumo las tolerancias ya que estoy comparando dos estimadores
# con errores diferentes
tolerancia_combinada = tolerancia_N + tolerancia_R;

# Por la teoría de propagación de errores, la varianza de una 
#resta es la suma de las varianzas. Al sumar las tolerancias, 
#contemplo el peor caso posible: que un estimador haya fluctuado 
#hacia arriba y el otro hacia abajo por culpa del ruido.




if error_max_ergodicidad < tolerancia_combinada
    fprintf('Es Ergódico: La media temporal de la realización %d equivale a la media estadística.\n', r_al_azar);
else
    disp('No es Ergódico');
end

# de todas formas por el teorema que vimos en clase, si una señal es ergodica entonces es estacionaria.
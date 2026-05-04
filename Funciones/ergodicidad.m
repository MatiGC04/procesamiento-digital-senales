# corroborar ergodicidad
# La idea es: ¿el promedio temporal de UNA realización 
# coincide con el promedio entre realizaciones?
function [es_ergodico] = ergodicidad(X,R,N,Media)
    if(R > 1)
        tolerancia = 1./sqrt(R);
        for i = 1 : R
            media_temporal(i) = mean(X(i,:)); # media temporal de cada realizacion
        end

        for j = 1 : N
            media_entre_realizaciones(j) = mean(X(:,j)); # media entre realizaciones de cada instante de tiempo
        end

        
    else
        
        tolerancia = 1./sqrt(lenght(X));
        for i = 1 : R
            media_temporal(i) = mean(X(i)); # media temporal de cada realizacion
        end

        for j = 1 : N
            media_entre_realizaciones(j) = mean(X(:,j)); # media entre realizaciones de cada instante de tiempo
        end
% promedio de todas las medias temporales
prom_temporal = mean(media_temporal);

% promedio de todas las medias entre realizaciones  
prom_ensemble = mean(Media);
if abs(prom_temporal - prom_ensemble) < tolerancia
    disp('Es ergódico');
else
    disp('No es ergódico');
end
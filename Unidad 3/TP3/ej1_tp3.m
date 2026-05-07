#addpath('../../../Funciones')
#addpath('../../../../Funciones')
addpath('../../Funciones')
clc

A = 1;
f = 0.5;
fase = 0;
tini = 0;
tfin = 20;

[ts,s] = generasenoidal(tini,tfin,f*100,f,fase,A);

[r] = generarampa(N, 1); # señal rampa con pendiente 1

[tc,c] = generaondacuadrada(tini,tfin,f*100,f,fase,A);

# genero señal aleatoria
s_aleatoria = rand(1, length(ts));

# Grafico
figure(1);
subplot(2,1,1);
plot(ts, s);
title('Señal Senoidal');
subplot(2,1,2);
plot(r);
title('Señal Rampa');
figure(2);
subplot(2,1,1);
plot(tc, c);
title('Señal Cuadrada');
subplot(2,1,2);
plot(ts,s_aleatoria);
title('Señal Aleatoria');




# debo determinar
#1. valor medio,
#2. m´aximo,
#3. m´ınimo,
#4. amplitud,
#5. energ´ıa,
#6. acci´on,
#7. potencia media y
#8. ra´ız del valor cuadr´atico medio

# obtengo el valor medio de las funciones, es decir sumo todas y divido la cantidad de muestras
valor_medio_s = sum(s) / length(s);
valor_medio_r = sum(r) / length(r);
valor_medio_c = sum(c) / length(c);
valor_medio_s_aleatoria = sum(s_aleatoria) / length(s_aleatoria);

display('Valor medio de la señal senoidal:');
disp(valor_medio_s);
display('Valor medio de la señal rampa:');
disp(valor_medio_r);
display('Valor medio de la señal cuadrada:');
disp(valor_medio_c);
display('Valor medio de la señal aleatoria:');
disp(valor_medio_s_aleatoria);

# Encontrar el maximo
display('El valor maximo de la señal senoidal es:');
disp(max(s));
display('El valor maximo de la señal rampa es:');
disp(max(r));
display('El valor maximo de la señal cuadrada es:');
disp(max(c));
display('El valor maximo de la señal aleatoria es:');
disp(max(s_aleatoria));

# Encontrar el Minimo
display('El valor minimo de la señal senoidal es:');
disp(min(s));
display('El valor minimo de la señal rampa es:');
disp(min(r));
display('El valor minimo de la señal cuadrada es:');
disp(min(c));
display('El valor minimo de la señal aleatoria es:');
disp(min(s_aleatoria));

# Encontrar Amplitud

amplitud_s = norma_p(s,Inf); # la norma con p=inf es el maximo valor absoluto de la señal
amplitud_r = norma_p(r,Inf);
amplitud_c = norma_p(c,Inf);
amplitud_s_aleatoria = norma_p(s_aleatoria,Inf);
display('La amplitud de la señal senoidal es:');
disp(amplitud_s);
display('La amplitud de la señal rampa es:');
disp(amplitud_r);
display('La amplitud de la señal cuadrada es:');
disp(amplitud_c);
display('La amplitud de la señal aleatoria es:');
disp(amplitud_s_aleatoria);

# Encontrar energia, seria la norma con p=2
p = 2;
energia_s = (norma_p(s,p))^2;
energia_r = (norma_p(r,p))^2;
energia_c = (norma_p(c,p))^2;
energia_s_aleatoria = (norma_p(s_aleatoria,p))^2;
display('La energia de la señal senoidal es:');
disp(energia_s);
display('La energia de la señal rampa es:');
disp(energia_r);
display('La energia de la señal cuadrada es:');
disp(energia_c);
display('La energia de la señal aleatoria es:');
disp(energia_s_aleatoria);

# Encontrar acción, seria la norma con p=1
p = 1;
accion_s = norma_p(s,p);
accion_r = norma_p(r,p);
accion_c = norma_p(c,p);
accion_s_aleatoria = norma_p(s_aleatoria,p);
display('La accion de la señal senoidal es:');
disp(accion_s);
display('La accion de la señal rampa es:');
disp(accion_r);
display('La accion de la señal cuadrada es:');
disp(accion_c);
display('La accion de la señal aleatoria es:');
disp(accion_s_aleatoria);

# Encontrar potencia media.
pmedia_s = potencia_media(s);
pmedia_r = potencia_media(r);
pmedia_c = potencia_media(c);
pmedia_s_aleatoria = potencia_media(s_aleatoria);

fprintf('La potencia media de la señal senoidal es: %f\n', pmedia_s);
fprintf('La potencia media de la señal rampa es: %f\n', pmedia_r);
fprintf('La potencia media de la señal cuadrada es: %f\n', pmedia_c);
fprintf('La potencia media de la señal aleatoria es: %f\n', pmedia_s_aleatoria);

# Encontrar valor cuadrático medio.
# es la raiz cuadrada de pmedia
vcuadratico_s = sqrt(pmedia_s);
vcuadratico_r = sqrt(pmedia_r);
vcuadratico_c = sqrt(pmedia_c);
vcuadratico_s_aleatoria = sqrt(pmedia_s_aleatoria);

fprintf('El valor cuadratico medio de la señal senoidal es: %f\n', vcuadratico_s);
fprintf('El valor cuadratico medio de la señal rampa es: %f\n', vcuadratico_r);
fprintf('El valor cuadratico medio de la señal cuadrada es: %f\n', vcuadratico_c);
fprintf('El valor cuadratico medio de la señal aleatoria es: %f\n', vcuadratico_s_aleatoria);

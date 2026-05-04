#Ejercicio 2: Compruebe que el producto interno mide el grado de parecido entre
#dos se˜nales dadas. Para ello, genere dos se˜nales senoidales y realice el produc
#to interno entre ellas. Eval´ue el efecto que producen los distintos par´ametros
#(A,f,φ) sobre el c´alculo del producto interno.
addpath('../../../Funciones');
clc;



# Genero dos señales de misma frecuencia y amplitud pero distinta fase
A = 1;
f = 0.5;
fase1 = 0;

fm = 10;

tini = 0;
tfin = 20;

[ts1,s1] = generasenoidal(tini,tfin,fm,f,fase1,A);
fase2 = pi/4; # cambio la fase de la segunda señal
[ts2,s2] = generasenoidal(tini,tfin,fm,f,fase2,A);

# calculo el producto interno entre las dos señales
resultado = producto_interno(s1, s2);
fprintf('El producto interno entre las dos señales es: %f\n', resultado);
plot(ts1, s1, 'b', ts2, s2, 'r');


# genero dos señales de misma frecuencia y fase pero distinta amplitud
A2 = 2; # cambio la amplitud de la segunda señal
[ts3,s3] = generasenoidal(tini,tfin,fm,f,fase1,A2);
resultado2 = producto_interno(s1, s3);
fprintf('El producto interno entre las dos señales es: %f\n', resultado2);

# genero dos señales de distinta frecuencia pero misma amplitud y fase
f2 = 1.10; # cambio la frecuencia de la segunda señal
[ts4,s4] = generasenoidal(tini,tfin,fm,f2,fase1,A);
resultado3 = producto_interno(s1, s4);
fprintf('El producto interno entre las dos señales es: %f\n', resultado3);
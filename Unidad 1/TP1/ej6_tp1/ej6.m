# Formas de Interpolación: interpolacion de rotenzel
# consiste en tomar el valor de la funcion y mantenerlo hasta el próximo tiempo donde se 
# fs = 0.5 para q valga 0 en la muestra entera .
fm = 10;
fs = 0.5;
tini = 0;
tfin = 1;
fase = 0;
[t_viejo,x_viejo] = senoidal(tini,tfin,fm,fs,fase);

figure(1)

stem(t_viejo,x_viejo,'bo-');
I1 = @(j) sin(pi*j)./pi*j *(j ~= 0) + 1*(j==0); % funcion I por trozos del ej1
I2 = @(j) 1*(j>=0 & j<1) + 0*(j<0 | j>=1); % funcion I por trozos del ej2
[y_interp,ti] = sobremuestreo_avanzado(t_viejo,x_viejo,fm*4,I2);

[y_interp2,ti2] = sobremuestreo(t_viejo,x_viejo,fm*4,I2);

figure(1)
title('Interpolacion Avanzada')
stem(ti,y_interp,'ro-');
figure(2)
title('Sob MATI')
stem(ti2,y_interp2,'go-');

figure(3)
title('Sob JR')

[y_interp3,ti3] = sobremuestreojr(t_viejo,x_viejo,fm*4,I2);
stem(ti3,y_interp3);


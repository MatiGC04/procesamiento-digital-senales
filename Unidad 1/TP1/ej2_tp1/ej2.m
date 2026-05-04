# inversión: reversion temporal. f(t) = f(-t)
# rectificación: transforma las señales en positivas. Se usa en fuentes que reciben corriente alterna,
# para pasarlo a continua. Entonces la operación seria: f(t) = |f(t)| o f(t) = max(f(t), 0)
# cuantización en 8 niveles, consiste en cuantizar la amplitud que significa establecer un numero
# que limita la precisión de la señal a 8 niveles discretos. Equivale a dividir el intervalo
# de la amplitud en N partes y asignar el valor de acuerdo a la parte mas cercana sobre la que cae el valor medio
# para sistemas binarios N deberia ser potencia de dos
addpath('../../../Funciones')

[t,y] = generasenoidal(0,1,100,5,0, 1);

yf_inversion = inversion(y,t);
yf_rectificacion = rectificacion(y);
yf_cuantizacion = cuantizacion(y,8);

figure(1);
title('Señal original');
plot(t,y); hold on;

figure(2);
title('Señal con inversión y rectificación');
plot(t,yf_inversion,'r','LineWidth',1); hold on;
legend('Inversion');
figure(3);
plot(t,yf_rectificacion,'b','LineWidth',2); 
legend('Rectificacion');
figure(4);
title('Señal con cuantización');
plot(t,yf_cuantizacion,'b','LineWidth',3); 
hold on;
plot(t,y,'-r');
legend('Cuantizacion','Señal Original');
xlabel('Tiempo (s)');
    


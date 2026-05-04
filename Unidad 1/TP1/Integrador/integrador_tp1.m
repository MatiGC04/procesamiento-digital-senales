addpath('../../../Funciones')

# Parte I
[t,y] = generasenoidal(0,1,400,10,pi/4,5);
figure(1);
plot(t,y);
title('Parte I');
xlabel('Tiempo (t)');
ylabel('Y(t)');

# Morfologica:
# El intervalo de tiempo es discreto ya que estamos muestreando a 400hz 
# es decir que el intervalo que se define en la funcion generasenoidal 
# va de 1/400 en 1/400.

# rectificar y cuantizar
y_rectificada = rectificacion(y);
y_cuant_rect = cuantizacion(y_rectificada, t, 16);

figure(2);
hold on;
#plot(t,y);
plot(t,y_cuant_rect);

# Parte II

%Item 1
r_blanco1 = randn(size(t));
r_blanco2 = randn(size(t));
varianza_arbitraria = 3;
varianza_arbitraria2 = 10;
# entonces como vimos para modificar la variaza multiplicamos por
r1 = sqrt(varianza_arbitraria) * r_blanco1;
r2 = sqrt(varianza_arbitraria2) * r_blanco2;
# sumo el ruido a la señal del item I

%Item 2
y_anterior = y_cuant_rect;
y_con_ruido1 = y_anterior + r1;
y_con_ruido2 = y_anterior + r2;
figure(3);
title('Señal con ruido con varianza igual a 3 y 5');
plot(t,y_con_ruido1, 'r'); hold on;
plot(t,y_con_ruido2, 'g');
hold on;
plot(t,y_anterior,'b');
legend('r1','r2','Señal original');

%Item 3
potencia_senal = sum(y_anterior.^2)/length(y_anterior);
potencia_ruido1 = sum(r1.^2)/length(r1);
potencia_ruido2 = sum(r2.^2)/length(r2);
SNR1 = 10*log10(potencia_senal/potencia_ruido1);
SNR2 = 10*log10(potencia_senal/potencia_ruido2);
fprintf('SNR con varianza %f: %f dB\n', varianza_arbitraria, SNR1);
fprintf('SNR con varianza %f: %f dB\n', varianza_arbitraria2, SNR2);


%Item 4
k1 = sqrt(potencia_senal/(potencia_ruido1*(10^0.6)));
k2 = sqrt(potencia_senal/(potencia_ruido2*(10^0.6)));
fprintf('La constante por la que hay que multiplicar el ruido para obtener una SNR de 6dB es: %f\n', k);
rnuevo1 = k1 * r1;
rnuevo2 = k2 * r2;

y_con_ruido_modificado1 = rnuevo1 + y;
y_con_ruido_modificado2 = rnuevo2 + y;

figure(4);
title('Señal con ruido modificado con 6dB de SNR');
plot(t,y_con_ruido_modificado1, 'r');
hold on;
plot(t,y_con_ruido_modificado2, 'g');hold on;
plot(t,y_anterior,'b');
title('Señal con ruido modificado con 6dB de SNR');
legend('y con r1*k','y con r2*k','Señal original');

%A mayor varianza mas grande es el desvio de los valores con respecto a la media
%esto se puede ver en el resultado de las relaciones S-R para r1 y r2, en r2 la relacion
%es mas baja, lo que quiere decir que la potencia del ruido es mayor.

# Parte 3

%Al reducir el número de bits (b), disminuye exponencialmente la cantidad de niveles disponibles
%(L = 2^b) para representar la amplitud de la señal. Si el rango de la señal se mantiene constante (es decir que la amplitud max y min no cambia a lo largo del tiempo), 
%tener menos niveles implica que la distancia o "salto" entre un nivel y el siguiente se vuelve mucho más grande.

%Si reducimos la fs a 15hz no se podra representar bien la señal ya que no se cumple con la relacion fm>2*fs, entonces 
%aparecera un efecto de aliasing, es decir que veremos una señal con una frecuencia aparente baja, eso ocurre
% ya que se esta queriendo muestrear mas lento que lo que cambia la funcion, perdiendo información.

%Como ya vimos para obtener una SNR DE 0db, encontraria un k que multiplique al ruido yque respete la relacion k = sqrt(SNR)
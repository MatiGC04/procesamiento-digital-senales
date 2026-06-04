

%h_w = 1*abs(w) < wc;

% si multiplico h(t) por una ventana puedo recortarla.
% el problema es que h(t) esta centrada entonces el sistema es no causal
% entonces deberia  desplazarla todo al eje + para que lo sea
% desventaja: hayt que hacer todo en lapiz y papel

% alternativa:
% la parte de generar H(w) y pasarla a h(t); lo hago
% lo hago usando versiones discretizadas, es decir, en vez de usar H(w) continua
% la genero muestreo, y si es una respuesta en frecuencia muestreada, puedo obtener
% la transformada de fourier inversa para obtener h[n]. Desventaja
% al usar la ifft y eso hace que que tengamos una version periorizada de h(t).
% Primero debo pasarle la funcion h(w) con la parte positiva primero y despues los tiempos negativos
% tambien aparece el fenomeno de aliasing temproal.

% Una forma de reducir el aliasing temporal que se produce al usar la transformada de fourier discreta
% Es el muestreo que yo haga en fm sea con muchas muestras.
% 

% tambien en vez de agarrar a la trasnformada y pegar la parte negativa delante de la postivia
% lo que se puede realizar es un retardo temporal en la respuesta deseada.
% En la guia de fourier, si utilizamos la regla de desplazamiento temporal.
% entonces si yo a la respuesta que tengo la multiplico por una expónencial puedo correr la grafica a donde yo quiera
% esta es la forma de corregir para hacerla causal.!!!!

% Repasemos el metodo de diseño de la teoria de filtros FIR

% eespecificamos el modulo y la fase para el filtro que deseaños
% 2 muestreamos dde la respuesta en frecuencia
% 3 aplicamos TDF inversa
% 4 truncamos temporalmente
% 5 corregimos amplitud
% 6 corregir causalidad

% debemos usar las distintas ventanas.
% notar las diferencias entre los lobulos centrales y laterales para cada ventana y ver los efectos que da

% Uso de la TDF para calcular h_d[n] (la respuesta al impulso temporal)
% necesitamos que el tamaño de muestras que hacemos ebn el muestreo de la respuesta deseada
% sea mucho mas grande que el tamaño N del filtro ... M>>N. 
% COnsideracion M = 10N
% nos aseguramos que al periodisarse la respuesta al impulso la copia este mas lejos y me perturve menos
% Para modificar el retardo multiplicamos por una exponencial

% RESUMEN:
% Resumen: Diseño FIR por Fourier y ventaneo
% 1. Especificación de los requerimientos (módulo, o mód. y fase)
% 2. Muestreo de la respuesta en frecuencia, M = 10N
% 3. Aplicación de la TDF inversa
% 4. Corrección para obtener la causalidad (si no se uso la fase)
% 5. Truncado temporal (ventanas temporales)
% 6. Corrección de amplitud (si se atenuó por demás)


%% coDIGO DEL PROFESOR:
fm=300; %frecuencia de muestreo
fr=50; %frecuencia de rechazo

%N=11; %longitud de filtro deseado
N=500;
M=10*N %Longitud de la respuesta en frecuencia deseada para frecuencias positivas
MTot= 2*M+1; %M para frecuencias positivas, Mpara frecuencias negativas , 1 para frecuencia 0
df=fm/(MTot); %deltaf para la resolucion frecuencial

%Construccion de la respuesta de magnitud
MD=ones(1,M+1);
n1=fix(fr/df); %calculo a que muestra corresponde la frecuencia fr
np=n1+1; %le sumo 1 para compensar el indexado desde 1
%nn=M-n1+1; %calculo la muestra en la que aparaece en la parte de frecuencias negativas

nm=ceil(2/df) %numero de muestras para cada lado correspondiente a 2Hz para cada lado

MD(np-nm:np+nm)=0; %Pongo ceros en la frecuencia deseada y una muestra para cada lado (ancho de banda de rechazo =4 HZ)
%MD(nn-nmnn+nm)=0; %lo mismo pero para frecuencias negativas

figure
plot(MD) #todos 1 menos en el rango que definimos 0


%Respuesta de fase: incluye un retarde de (N-1)/2 muestras
ph=exp(-j*2*pi*((N-1)/2)*[0:M]/(MTot));
%ph=[ph conj/fliplr(ph(2:end))];


%Respuesta deseada completa
R=MD.*ph;

%Parte de frecuencias negativas
R=[R conj(R(end:-1:2))];

h=real(ifft(R));
figure
plot(h)

figure
%hf=h(1:N).*hamming(N).';
%hf=h(1:N).*hanning(N).';
%hf=h(1:N).*boxcar(N).';
hf=h(1:N).*blackman(N).';

stem(hf)
hold on
freqz(hf,1,1000,fm);
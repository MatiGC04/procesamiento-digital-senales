% Implemente la convolución lineal mediante una sumatoria de convolución.
% Pruébela para convolucionar dos señales cualesquiera de longitud N muestras.
% Compare los resultados con los obtenidos mediante la función conv(x,y) y con la función filter.
% La función Y = filter(B,A,X) implementa la ecuación en diferencias, para
% los coeficientes dados en los vectores A y B y la señal de entrada X, según:
% a(1)*y(n) = b(1)*x(n) + b(2)*x(n-1) + ... - a(2)*y(n-1) - ...
% A partir de esto, determine los valores a ingresar en los vectores A y B para
% obtener la salida esperada.
N = 10;
h = randi(10, 1, N); % Vector fila de 1xN con enteros entre 1 y 10
x = [1, zeros(1,N-1)]; % Delta de Dirac de la misma longitud que y

# como h y x miden lo mismo podria poner 2*N -1 pero es para cualquier caso
y = zeros((length(h) + length(x))-1,1); % Vector de salida con longitud suficiente para la convolución completa

for k = 1 : length(y)
    suma = 0;
    for i = 1: length(x) % equivale a i=0: N-1
        # para evitar indices invalidos, e indices fuera del rango de h
        if (k-i)+1>=1 && (k-i)+1<=length(h)
            suma = suma + x(i)*h((k-i)+1); # necesito sumarle 1 a k-i para que tome los indices validos
        end
    end 
    y(k) = suma;
end

y1 = conv(x,h);

n = 1 : length(y);
figure('Name', 'Comparativa conv. lineal mediante suma vs conv', 'NumberTitle', 'on');

subplot(3,1,1);
stem(n, y);
grid on;
title('Sumatoria de convolución');

subplot(3,1,2);
stem(n, y1);
grid on;
title('conv(x,h)');

% --------------------------------------------
% Comparacion con funcion filter
% Para este ejerciio defino
#H = [6,2,9,6,9,6,1,5,6,7];
H = h; % para comparar con el mismo vector h que use para la convolucion lineal
X = [1, zeros(1,length(H)-1)];

A = [1];
B = H;

% ACLARACIÓN
% Filter procesa muestra a muestra y solo produce tantas salidas como muestras 
% tenga x. No "sabe" que h tiene más coeficientes que van a seguir contribuyendo 
% después de que x termina
% para obtener el mismo resultado, se podria extender la cantidad de 0s del vector X a (length(h) + length(x))-1
Y = filter(B,A,X);

subplot(3,1,3);
n1 = 1 : length(Y);
stem(n1, Y);
grid on;
title('filter(B,A,X)');

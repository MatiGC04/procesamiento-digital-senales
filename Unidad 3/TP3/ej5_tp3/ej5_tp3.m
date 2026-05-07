clc
addpath('../../../Funciones');

senales = load('te.txt');

fs = 11025;
Ts = 1/fs;
t = 0:length(senales)-1;
t = t * Ts;
plot(t, senales)
xlabel('Tiempo (s)')
ylabel('Amplitud')
title('Señales de Entrada')
xticks(0:0.5:10)

% ahora debo dividir la señal en segmentos
% según la grafica puedo ver 7 picos. entonces divido en intervalos
int1 = [1.70, 2.10];   
int2 = [2.40, 2.80];   
int3 = [3.55, 3.95];   
int4 = [4.25, 4.65];   
int5 = [5.50, 5.90];   
int6 = [6.50, 6.90];   
int7 = [7.15, 7.55];

% los intervalos estan en segundos, entonces
% paso los intervalos de segundos->indices.
% intervalo * frecuencia = segundos * muestras/segundo = muestras
idx1 = round(int1 * fs);
idx2 = round(int2 * fs);
idx3 = round(int3 * fs);
idx4 = round(int4 * fs);
idx5 = round(int5 * fs);
idx6 = round(int6 * fs);
idx7 = round(int7 * fs);

% ahora filtro las señales usando los indices calculados
s1 = senales(idx1(1):idx1(2));
s2 = senales(idx2(1):idx2(2));
s3 = senales(idx3(1):idx3(2));
s4 = senales(idx4(1):idx4(2));
s5 = senales(idx5(1):idx5(2));
s6 = senales(idx6(1):idx6(2));
s7 = senales(idx7(1):idx7(2));

% uso cell array porque cada segmento tiene distinta longitud
% S{i} accede al segmento i
S = {s1, s2, s3, s4, s5, s6, s7};

% armo el listado de frecuencias fila y columna (estandar DTMF)
ffila    = [697, 770, 852, 941];
fcolumna = [1209, 1336, 1477];

% prealoco las matrices de parecido para eficiencia
parecido_fila    = zeros(length(S), length(ffila));
parecido_columna = zeros(length(S), length(fcolumna));

% para cada segmento, genero senoidales de referencia
% con la MISMA longitud del segmento y calculo el producto interno

for i = 1:length(S)
    seg = S{i}(:);
    N   = length(seg);

    for j = 1:length(ffila)
        [~, ref_fila] = generasenoidal(0, N/fs, fs, ffila(j), 0, 1);
        ref_fila = ref_fila(:);
        % producto interno sin normalizar
        %parecido_fila(i,j) = abs(producto_interno(seg, ref_fila));
        % normalizado con norma-2 (la asociada al producto interno segun el libro)
        parecido_fila(i,j) = abs(producto_interno(seg, ref_fila)) / (norma_p(seg,2) * norma_p(ref_fila,2));
    end

    for k = 1:length(fcolumna)
        [~, ref_col] = generasenoidal(0, N/fs, fs, fcolumna(k), 0, 1);
        ref_col = ref_col(:);
        % producto interno sin normalizar
        %parecido_columna(i,k) = abs(producto_interno(seg, ref_col));
        % normalizado con norma-2 (la asociada al producto interno segun el libro)
        parecido_columna(i,k) = abs(producto_interno(seg, ref_col)) / (norma_p(seg,2) * norma_p(ref_col,2));
    end

    % Divido por la norma 2 de ambas señales para obtener el coseno(a) de ambas señales,
    % Al normalizar, el resultado varia entre 0 y 1, y es menos sensible a la amplitud del ruido
    % esto reduce errores de detección
end

% ahora debo en cada segmento filtrar maximos e identificar teclas ---
idx_fila = zeros(1, length(S));
idx_col  = zeros(1, length(S));
for i = 1:length(S)
    [~, idx_fila(i)] = max(parecido_fila(i,:));
    [~, idx_col(i)]  = max(parecido_columna(i,:));
end

matriz_teclas = ['1', '2', '3';
                 '4', '5', '6';
                 '7', '8', '9';
                 '*', '0', '#'];

% para cada señal, uso los indices del maximo de parecido
% para indexar directamente en la matriz de teclas
for i = 1:length(S)
    tecla = matriz_teclas(idx_fila(i), idx_col(i));
    fprintf('Señal %d: fila=%d Hz, columna=%d Hz → tecla: %s\n', ...
             i, ffila(idx_fila(i)), fcolumna(idx_col(i)), tecla);
end


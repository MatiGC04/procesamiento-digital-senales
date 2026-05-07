clc
addpath('../../../Funciones');

senales = load('te.txt');

fs = 11025;
Ts = 1/fs;
t = 0:length(senales)-1;
t = t * Ts;

% graficamos con el eje x en muestras para identificar intervalos directamente
plot(1:length(senales), senales)
xlabel('Muestras')
ylabel('Amplitud')
title('Señales de Entrada')

% defino los intervalos directamente en muestras (sin conversion)
% cada fila: [muestra_inicio, muestra_fin]
ventanas = [18750, 23100;   % segmento 1
            26500, 30900;   % segmento 2
            39100, 43500;   % segmento 3
            46800, 51200;   % segmento 4
            60600, 64900;   % segmento 5
            70000, 73950;   % segmento 6
            78800, 83100];  % segmento 7

% uso cell array porque cada segmento puede tener distinta longitud
% S{i} accede al segmento i
S = cell(1, rows(ventanas));
for i = 1:rows(ventanas)
    S{i} = senales(ventanas(i,1):ventanas(i,2));
end

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
        % producto interno normalizado con norma-2 (la asociada al producto
        % interno segun el libro). Al normalizar el resultado varia entre 0 y 1,
        % y es menos sensible a la amplitud del ruido, reduciendo errores de deteccion
        parecido_fila(i,j) = abs(producto_interno(seg, ref_fila)) / (norma_p(seg,2) * norma_p(ref_fila,2));
    end

    for k = 1:length(fcolumna)
        [~, ref_col] = generasenoidal(0, N/fs, fs, fcolumna(k), 0, 1);
        ref_col = ref_col(:);
        parecido_columna(i,k) = abs(producto_interno(seg, ref_col)) / (norma_p(seg,2) * norma_p(ref_col,2));
    end
end

% en cada segmento identifico el indice del maximo parecido
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
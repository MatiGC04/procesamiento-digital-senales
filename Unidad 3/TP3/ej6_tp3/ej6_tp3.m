% 1. Cargar el archivo
clc 
addpath('../../../Funciones');
[audio, fs] = audioread('escala.wav');
audio = audio';
% 2. Ver info básica (útil para verificar)
length(audio);   % total de muestras
fs              % frecuencia de muestreo (típico: 44100 Hz)

% 3. Muestras por segmento
N = round(0.5 * fs);   % 0.5 segundos

% 4. Separar los 8 tonos
for i = 1:8
    inicio = (i-1)*N + 1;
    fin    = i*N;
    segmento{i} = audio(inicio:fin);
end

f_LA = 440; % frecuencia de La4

fm = fs; % misma frecuencia de muestreo que el audio para evitar aliasing

#t = (0:1/fs:(N-1)-1/fs); %  menos preciso porque no genera N-1 puntos.
t = (0:N-1)/fs;  % exactamente N puntos, simple y directo
y_LA = sin(2 * pi * f_LA * t);

# ahora que tengo la señal con el tono, recorro el cell segmento y calculo la correlacion cruzada entre cada segmento y el tono generado

for i=1:8
    correlacion(i) = producto_interno(segmento{i}, y_LA)/(norma_p(segmento{i},2)*norma_p(y_LA,2)); 
    % normalizando solo queda el cos(a) siendo a el angulo comprendido entre el tono_i y el tono_La
end

# busco el tono maximo, es decir el que mas se parezca al tono la
[valor_maximo, indice_maximo] = max(correlacion);

disp(['El tono más parecido a La4 es el segmento ', num2str(indice_maximo), ' con una correlación de ', num2str(valor_maximo)]);
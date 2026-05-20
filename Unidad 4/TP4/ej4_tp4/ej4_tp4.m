% Ejercicio 4: Principio de incertidumbre tiempo-frecuencia
%
% La propiedad a verificar es:
%   - señal concentrada en tiempo  =>  espectro disperso en frecuencia
%   - señal dispersa en tiempo     =>  espectro concentrado en frecuencia
%
% Lo exploro de dos formas:
%   Parte 1: vario el ANCHO de una ventana rectangular y observo el espectro
%   Parte 2: comparo distintos TIPOS de ventana con el mismo ancho

fm = 1000;   % frecuencia de muestreo
N  = 1000;   % muestras totales (1 segundo)
n  = 0:N-1;  % indice de muestras

% Uso una senoidal como señal base sobre la que aplico las ventanas
x = sin(2*pi*50*n/fm);

% Eje de frecuencia centrado en 0 para graficar
eje_f = (-N/2 : N/2-1) * (fm/N);

%--------------------------------------------------------------------------
% PARTE 1: vario el ANCHO de la ventana rectangular
%
% Una ventana angosta concentra la señal en pocos instantes de tiempo,
% lo que obliga al espectro a dispersarse (necesita muchas frecuencias
% para representar un evento corto).
% Una ventana ancha hace lo opuesto: el espectro queda concentrado.

anchos = [50, 100, 200, 500]; % anchos en muestras, de angosta a ancha

figure(1); clf;
for idx = 1:length(anchos)
    M = anchos(idx);

    % Construyo ventana rectangular de M muestras centrada en el medio
    w = zeros(1, N);
    centro = round(N/2);
    w(centro - M/2 : centro + M/2 - 1) = 1; % M unos, resto ceros

    % Aplico la ventana: multiplico punto a punto con la señal
    x_v = x .* w;

    % Calculo la TDF y ajusto para centrar en 0 Hz
    X_v = fftshift(fft(x_v));

    % Grafico dominio temporal
    subplot(length(anchos), 2, 2*idx-1);
    plot(n/fm, x_v);
    ylabel('Amplitud');
    title(sprintf('Ventana rectangular  M=%d muestras (%.2f s)', M, M/fm));
    if idx == length(anchos), xlabel('Tiempo (s)'); end

    % Grafico espectro de magnitud, acoto a +-200 Hz para ver el pico
    subplot(length(anchos), 2, 2*idx);
    plot(eje_f, abs(X_v));
    xlim([-200 200]);
    ylabel('|X[k]|');
    title(sprintf('Espectro  M=%d', M));
    if idx == length(anchos), xlabel('Frecuencia (Hz)'); end
end
display('Parte 1: efecto del ancho de ventana rectangular sobre el espectro');

%--------------------------------------------------------------------------
% PARTE 2: comparo distintos TIPOS de ventana con el mismo ancho
%
% Cada tipo tiene una forma diferente que afecta el compromiso entre:
%   - lobulo principal (resolucion frecuencial)
%   - lobulos laterales (filtracion de frecuencias vecinas)
%
% La rectangular tiene el lobulo principal mas angosto (mejor resolucion)
% pero lobulos laterales grandes (peor filtracion).
% Blackman tiene lobulos laterales muy pequenos pero lobulo principal ancho.

M   = 200;       % ancho fijo para comparar todas las ventanas en igualdad
n_v = 0:M-1;     % indice local de la ventana, de 0 a M-1

% Defino cada ventana segun las formulas de la teoria

% i) Rectangular: todos los valores iguales a 1 (sin modificacion de la señal)
w_rect  = ones(1, M);

% ii) Hanning: coseno suave que lleva los extremos a cero
w_hann  = 0.5 - 0.5 * cos(2*pi*n_v/M);

% iii) Hamming: similar a Hanning pero los extremos no llegan exactamente a cero
w_hamm  = 27/50 - 23/50 * cos(2*pi*n_v/M);

% iv) Bartlett: forma triangular, sube linealmente hasta M/2 y baja
w_bart  = zeros(1, M);
w_bart(n_v <= M/2) = 2*n_v(n_v <= M/2) / M;
w_bart(n_v >  M/2) = 2 - 2*n_v(n_v > M/2) / M;

% v) Blackman: suma de tres cosenos, lobulos laterales muy atenuados
w_black = 21/50 - 0.5*cos(2*pi*n_v/M) + 2/25*cos(4*pi*n_v/M);

ventanas = {w_rect, w_hann, w_hamm, w_bart, w_black};
nombres  = {'Rectangular', 'Hanning', 'Hamming', 'Bartlett', 'Blackman'};

% Tomo el segmento central de la señal del mismo largo que la ventana
x_seg = x(N/2 - M/2 + 1 : N/2 + M/2);

figure(2); clf;
for idx = 1:length(ventanas)
    w_actual = ventanas{idx};

    % Aplico la ventana al segmento
    x_v = x_seg .* w_actual;

    % Uso zero padding (4*M) para interpolar el espectro y verlo mas suave.
    % Esto NO mejora la resolucion real, solo la visualizacion.
    Nfft     = 4 * M;
    X_v      = fft(x_v, Nfft);
    X_v_aj   = fftshift(X_v);
    eje_f_v  = (-Nfft/2 : Nfft/2-1) * (fm/Nfft);

    % Grafico señal ventaneada en tiempo
    subplot(length(ventanas), 2, 2*idx-1);
    plot(n_v/fm, x_v);
    ylabel('Amplitud');
    title(sprintf('Ventana %s', nombres{idx}));
    if idx == length(ventanas), xlabel('Tiempo (s)'); end

    % Grafico espectro de magnitud
    subplot(length(ventanas), 2, 2*idx);
    plot(eje_f_v, abs(X_v_aj));
    xlim([-200 200]);
    ylabel('|X[k]|');
    title(sprintf('Espectro %s', nombres{idx}));
    if idx == length(ventanas), xlabel('Frecuencia (Hz)'); end

    % Verifico Parseval para cada ventana: energia en tiempo debe igualar
    % energia en frecuencia (normalizada por Nfft)
    E_t = sum(x_v.^2);
    E_f = (1/Nfft) * sum(abs(X_v).^2);
    fprintf('%-12s  E_tiempo=%8.4f  E_freq=%8.4f  error=%.2e\n', ...
            nombres{idx}, E_t, E_f, abs(E_t - E_f));
end
display('Parte 2: comparacion de tipos de ventana con M=200 muestras fijas');
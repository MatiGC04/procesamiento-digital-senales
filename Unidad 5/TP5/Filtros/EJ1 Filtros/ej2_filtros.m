% ej 2: filtro FIR con multiples bandas de paso
% bandas: [100, 200] Hz, [1640, 3028] Hz, [5000, 6000] Hz
% en la ultima banda la magnitud es proporcional a la freq (rampa de 0 a 1)

% la freq mas alta q necesito pasar es 6000 Hz, por nyquist fm >= 2*6000 = 12000
% uso fm = 15000 para tener margen
fm = 15000;

% N es el largo del filtro, mas muestras mejor selectividad pero mas retardo
N = 200;

% M = 10*N es la cant de muestras para freq positivas
% el profe dice q M >> N para reducir el aliasing temporal q aparece
% al usar la IFFT (h[n] se periodiza, y si M es grande las copias
% caen lejos y no me joden las primeras N muestras)
M = 10*N;
MTot = 2*M+1; % total: M positivas + M negativas + 1 para f=0
df = fm/MTot; % resolucion frecuencial en Hz

fprintf('df = %.4f Hz | M = %d | MTot = %d\n', df, M, MTot);

%--------------------------------------------------------------------------
% armo la respuesta de magnitud deseada MD
% MD tiene M+1 muestras, va de f=0 hasta f=fm/2
% la muestra k corresponde a f = (k-1)*df
% arranco todo en cero (rechazo todo) y pongo 1 donde quiero dejar pasar

MD = zeros(1, M+1);

% banda 1: [100, 200] Hz con magnitud 1
% para pasar de freq a indice: k = fix(f/df) + 1
k1_ini = fix(100/df) + 1;
k1_fin = fix(200/df) + 1;
MD(k1_ini : k1_fin) = 1;
fprintf('Banda 1: indices %d a %d (%.1f a %.1f Hz)\n', k1_ini, k1_fin, (k1_ini-1)*df, (k1_fin-1)*df);

% banda 2: [1640, 3028] Hz con magnitud 1
k2_ini = fix(1640/df) + 1;
k2_fin = fix(3028/df) + 1;
MD(k2_ini : k2_fin) = 1;
fprintf('Banda 2: indices %d a %d (%.1f a %.1f Hz)\n', k2_ini, k2_fin, (k2_ini-1)*df, (k2_fin-1)*df);

% banda 3: [5000, 6000] Hz con magnitud proporcional a la freq
% aca no es 1 fija, crece linealmente de 0 (en 5000) a 1 (en 6000)
% osea mag = (f - 5000) / (6000 - 5000) = (f - 5000) / 1000
k3_ini = fix(5000/df) + 1;
k3_fin = fix(6000/df) + 1;
for k = k3_ini : k3_fin
    f_k = (k-1)*df; % freq q corresponde al indice k
    MD(k) = (f_k - 5000) / 1000; % rampa: 0 en 5000, 1 en 6000
end
fprintf('Banda 3: indices %d a %d (%.1f a %.1f Hz) - rampa\n', k3_ini, k3_fin, (k3_ini-1)*df, (k3_fin-1)*df);

figure(1)
clf
plot((0:M)*df, MD)
xlabel('Frecuencia (Hz)'); ylabel('Magnitud');
title('Respuesta de magnitud deseada MD')
xlim([0 fm/2])

%--------------------------------------------------------------------------
% fase para hacer el filtro causal
% por la propiedad de desplazamiento de la TDF, si multiplico H(w) por
% exp(-j*w*d), en el tiempo h[n] se corre d muestras
% uso d = (N-1)/2 para q quede centrada en las primeras N muestras
% es lo mismo q hace el profe en el ej1
ph = exp(-j*2*pi*((N-1)/2)*[0:M]/(MTot));

% respuesta completa (magnitud * fase) para freq positivas
R = MD.*ph;

% completo con freq negativas: para q h[n] sea real H(-f) = conj(H(f))
% las freq negativas son el conjugado de las positivas dadas vuelta
R = [R conj(R(end:-1:2))];

%--------------------------------------------------------------------------
% IFFT para obtener h[n]
% como M >> N las primeras N muestras son buena aprox sin q el aliasing
% temporal me arruine los valores
h = real(ifft(R));

figure(2)
clf
plot(h)
xlabel('Muestras'); ylabel('Amplitud');
title('h[n] completa (antes de truncar)')

%--------------------------------------------------------------------------
% trunco con ventanas: tomo las primeras N muestras y multiplico por la ventana
% cada ventana tiene distinto compromiso entre lobulo ppal y laterales:
% rectangular (boxcar): laterales altos (-13 dB), transicion rapida
% hanning: -31 dB, compromiso piola
% hamming: -41 dB, un toque mas ancho q hanning
% blackman: -57 dB, mejor atenuacion pero transicion mas lenta

hf_rect = h(1:N).*boxcar(N).';
hf_hann = h(1:N).*hanning(N).';
hf_hamm = h(1:N).*hamming(N).';
hf_black = h(1:N).*blackman(N).';

%--------------------------------------------------------------------------
% respuesta en freq de cada filtro ventaneado
% freqz(h, a, nfft, fm) te calcula y grafica la resp en freq
% le paso a=1 pq es FIR (no tiene parte recursiva)

figure(3)
clf
subplot(2,2,1)
freqz(hf_rect, 1, 2048, fm)
title('Rectangular')

subplot(2,2,2)
freqz(hf_hann, 1, 2048, fm)
title('Hanning')

subplot(2,2,3)
freqz(hf_hamm, 1, 2048, fm)
title('Hamming')

subplot(2,2,4)
freqz(hf_black, 1, 2048, fm)
title('Blackman')

%--------------------------------------------------------------------------
% verifico la rampa en la banda 3 [5000, 6000] Hz
% calculo la resp a mano para hacer zoom y comparar con la rampa ideal

Nfft = 4096;
f_eje = (0:Nfft-1)*fm/Nfft;

% rampa ideal para superponer
f_rampa = 5000:10:6000;
rampa_ideal = (f_rampa - 5000)/1000;

figure(4)
clf

H_rect = freqz(hf_rect, 1, Nfft);
H_hann = freqz(hf_hann, 1, Nfft);
H_hamm = freqz(hf_hamm, 1, Nfft);
H_black = freqz(hf_black, 1, Nfft);

subplot(2,2,1)
plot(f_eje, abs(H_rect)); hold on
plot(f_rampa, rampa_ideal, 'r--', 'linewidth', 2); hold off
xlim([4500 6500]); title('Banda 3 - Rectangular')
xlabel('Frecuencia (Hz)'); ylabel('Magnitud');
legend('Filtro', 'Rampa ideal')

subplot(2,2,2)
plot(f_eje, abs(H_hann)); hold on
plot(f_rampa, rampa_ideal, 'r--', 'linewidth', 2); hold off
xlim([4500 6500]); title('Banda 3 - Hanning')
xlabel('Frecuencia (Hz)'); ylabel('Magnitud');
legend('Filtro', 'Rampa ideal')

subplot(2,2,3)
plot(f_eje, abs(H_hamm)); hold on
plot(f_rampa, rampa_ideal, 'r--', 'linewidth', 2); hold off
xlim([4500 6500]); title('Banda 3 - Hamming')
xlabel('Frecuencia (Hz)'); ylabel('Magnitud');
legend('Filtro', 'Rampa ideal')

subplot(2,2,4)
plot(f_eje, abs(H_black)); hold on
plot(f_rampa, rampa_ideal, 'r--', 'linewidth', 2); hold off
xlim([4500 6500]); title('Banda 3 - Blackman')
xlabel('Frecuencia (Hz)'); ylabel('Magnitud');
legend('Filtro', 'Rampa ideal')

%--------------------------------------------------------------------------
% vista completa con hamming (buen compromiso)
figure(5)
clf
subplot(2,1,1)
plot(f_eje, abs(H_hamm))
xlabel('Frecuencia (Hz)'); ylabel('Magnitud');
title('Magnitud completa - Hamming')
xlim([0 fm/2])

subplot(2,1,2)
plot(f_eje, 20*log10(abs(H_hamm)+1e-10))
xlabel('Frecuencia (Hz)'); ylabel('Magnitud (dB)');
title('Magnitud en dB - Hamming')
xlim([0 fm/2])

% conclusiones:
% con rectangular las transiciones son rapidas pero aparece ripple
% (oscilaciones de gibbs), se nota mucho en la rampa
% hanning y hamming suavizan el ripple, la rampa en [5000,6000]
% se aprox mejor a la ideal, sobre todo con hamming
% blackman da la mejor atenuacion fuera de banda pero las transiciones
% se ensanchan y los bordes de las bandas no quedan tan abruptos
% si aumento N mejora la selectividad (transiciones mas finas y rampa
% mas precisa) pero mete mas retardo y mas computo

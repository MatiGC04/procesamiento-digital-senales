
f1 =10;
f2 =20;
T = 0.001; % periodo de muestreo
s = @(t) sin(2*pi*f1*t) + 4*sin(2*pi*f2*t); % señal a analizar
#Ejercicio 1

tini = 0; tfin = 1; fm = 1/T;

t = tini:T:tfin-T; % vector de tiempo
s_n = s(t); % señal discreta




N = length(s_n); % número de muestras

% Calculo la TDF S[k]. Para eso voy a usar la funcion fft.
S_k = fft(s_n); % usa la formula que esta en la teoria. El resultado da N muestras
                
figure(1)
clf; % Limpia la figura actual

% Gráfico en el dominio del tiempo
subplot(3,1,1);
plot(t, s_n);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal en el tiempo s[n]');

% Gráfico en el dominio de la frecuencia (TDF)
subplot(3,1,2);
plot(0:N-1, abs(S_k));
xlabel('Índice k');
ylabel('Magnitud |S[k]|');
title('Espectro de magnitud de S[k]');

# tengo que recortar laparte negativa de fft que obtengo, y pegarla en la parte negativa
# debo ajustar el espectro frecuencial para que laparte negativa quede al principio

s_negativa = S_k(N/2+1:end); % parte negativa de la FFT
s_positiva = S_k(1:N/2); % parte positiva de la FFT
S_k_ajustada = [s_negativa, s_positiva]; % ajusto el espectro frecuencial


% Gráfico en el dominio de la frecuencia (TDF) ajustado
subplot(3,1,3);
plot(-N/2:N/2-1, abs(S_k_ajustada));
xlabel('Índice k');
ylabel('Magnitud |S[k]|');
title('Espectro de magnitud de S[k] ajustado');


# Ejercicio 2

E_s1 = sum(s_n.^2); % energía de la señal s[n]

E_s2 = 1/N * sum(abs(S_k).^2); % energía de la señal s[n] usando la TDF

if abs(E_s1 - E_s2) < 1e-7
    disp('La energía calculada en el dominio del tiempo y el dominio de la frecuencia coincide.');
else
    disp('La energía calculada en el dominio del tiempo y el dominio de la frecuencia no coincide.');
end

%-----------------------------------------------------------------------------

# Realice los siguientes cambios y analice los resultados obtenidos:

s2 = @(t) s(t)  + 4;
s2_n = s2(t); % señal discreta


s2_negativa = s2_n(N/2+1:end); % parte negativa de la FFT
s2_positiva = s2_n(1:N/2); % parte positiva de la FFT
S2_k_ajustada = [s_negativa, s_positiva]; % ajusto el espectro frecuencial



% analizo los cambios en el espectro
figure(2)
clf
subplot(2,1,1);
plot(t, s2_n);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal s2[n] = s[n] + 4');
subplot(2,1,2);
plot(0:N-1, abs(fft(s2_n)));
xlabel('Índice k');
ylabel('Magnitud |S2[k]|');
title('Espectro de magnitud de S2[k]');

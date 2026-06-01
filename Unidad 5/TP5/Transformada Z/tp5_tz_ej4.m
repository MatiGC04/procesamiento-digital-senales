H = @(s) 12500*s ./ (44*s.^2 + 60625*s + 625e4);
w = linspace(0, 10000, 1000);

H_jw = H(1j*w);
mag = abs(H_jw);
mag_max = max(mag);

umbral = 10.^(-3/20);
wc = 0;
for k = 1: length(w)
    if mag(k) >= umbral*mag_max
        fprintf('La frecuencia de corte es: %.2f rad/s\n', w(k));
        wc = w(k);
        #break;
    end
end

% con Wc obtengo fc.

fc = wc / (2*pi);

fm = 4*fc; % por enunciado

T = 1/fm; 
fprintf('wc = %.2f rad/s\n', wc);
fprintf('fc = %.2f Hz\n', fc);
fprintf('fm = %.2f Hz\n', fm);
fprintf('T = %.6f s\n', T);

% ------------
% una vez que tengo T realizo las transformaciones

H_euler = @(z) H((1-z.^(-1))/T);

H_bilineal = @(z) H(2/T * (1-z.^(-1))./(1+z.^(-1)));

w = linspace(0, 2*pi*(fm/2), 10000);


H_e  = H_euler(exp(1j*w*T));

H_b  = H_bilineal(exp(1j*w*T));

H_c  = H(1j*w);  

figure(2)
plot(w/(2*pi), abs(H_c), 'b', w/(2*pi), abs(H_e), 'r', w/(2*pi), abs(H_b), 'g')
legend('Continuo', 'Euler', 'Bilineal')
xlabel('f [Hz]')
ylabel('|H|')
title('Comparación respuestas en frecuencia')
grid on
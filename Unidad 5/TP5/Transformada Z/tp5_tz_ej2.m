fs = 10000;                          % frecuencia de muestreo
f = linspace(0, fs/2, 1024);        % f de 0 a 5000 Hz
w = 2*pi * f / fs;                   % w = 2*pi*f/fs  (frecuencia digital)
z = exp(j*w);                        % z = e^(jw)  --> círculo unitario


H1 = 1 ./ (1 - 0.5*z.^(-1) + 0.25*z.^(-2));

plot(w, abs(H1));
hold on;
H2 = z.^(-1) ./(1-z.^(-1) - z.^(-2));
plot(w, abs(H2));

H3 = 7./(1-2*z.^(-1) + 6*z.^(-2));
plot(w, abs(H3));

# como h4 es una sumatoria
H4 = zeros(size(z));
for k = 0: 7
    H4 = H4 + 2.^(-k)*z.^(-k);
end
plot(w, abs(H4));
legend('H1', 'H2', 'H3', 'H4');
xlabel('Frecuencia angular w');
ylabel('|H(e^{jw})|');